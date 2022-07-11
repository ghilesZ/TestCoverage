(* This module provides helpers for ast building (and other stuff) *)

(* keep this before open as module Parse is shadowed by open
   Migrate_parsetree *)
let lparse s =
  try Parse.longident (Lexing.from_string s)
  with _ ->
    (* for operators *)
    Parse.longident (Lexing.from_string ("( " ^ s ^ " )"))

open Migrate_parsetree
open Ast_410
open Parsetree
open Ast_mapper
open Ast_helper
open Asttypes
open Location

module Conv = Convert (OCaml_410) (OCaml_current)

let print_expression fmt e =
  Format.fprintf fmt "%a%!" Pprintast.expression (Conv.copy_expression e)

let print_pat fmt p = Pprintast.pattern fmt (Conv.copy_pattern p)
let current_loc = ref Location.none

let update_loc l = current_loc := l

let string_ str = Exp.constant (Const.string str)

(* same as mkloc but with optional argument; default is Location.none*)
let def_loc ?loc s =
  let loc = match loc with None -> !current_loc | Some loc -> loc in
  Location.mkloc s loc

(* builds a Longident.t Location.t from a string *)
let lid_loc ?loc id = def_loc ?loc (lparse id)

(* given a string [name], builds the identifier [name] *)
let exp_id name = lid_loc name |> Exp.ident ~loc:!current_loc

(* same as apply but argument are not labelled *)
let apply_nolbl f args =
  Exp.apply ~loc:!current_loc f (List.map (fun a -> (Nolabel, a)) args)

(* same as apply_nolbl but function name is a string *)
let apply_nolbl_s s = apply_nolbl (exp_id s)

let seq e1 e2 =
  Exp.sequence e1 e2

let get_loc expr =
  let loc_l = string_of_int  expr.pexp_loc.loc_start.pos_lnum ^ "-" ^ string_of_int  expr.pexp_loc.loc_end.pos_lnum in
  let loc_c = string_of_int  (expr.pexp_loc.loc_start.pos_cnum - expr.pexp_loc.loc_start.pos_bol)^ "-" ^ string_of_int  (expr.pexp_loc.loc_end.pos_cnum - expr.pexp_loc.loc_end.pos_bol) in
  String.concat " "  ["line :";loc_l;" col :"; loc_c] ;;


let get_mess sloc =
  apply_nolbl_s "Cover_runtime.increment" [string_ sloc ];;


let rec rewrite (expr:expression) : expression =
  let desc' =
    match expr.pexp_desc with
    | Pexp_constant _ -> expr.pexp_desc
    | Pexp_ident _ -> expr.pexp_desc
    | Pexp_ifthenelse (condition, branch_then, None) ->
       Pexp_ifthenelse (rewrite condition, rewrite branch_then, None)
    | Pexp_ifthenelse (condition, br_then, Some(br_else)) ->
         (* let cov_abs  a b =
      let cov_then () = 1.0 in
      let cov_else () = 1.0 in
        a *. cov_then ()  +. b *. cov_else () in
      let str_cov = string_of_float (cov_abs 0.5 0.5) in
      let incr_message2 = apply_nolbl_s "print_string" [string_ str_cov ] in *)
      let sloc_then = get_loc br_then in
      let incr_message = get_mess sloc_then in
      let newbr_then =  seq incr_message (rewrite br_then) in
      let sloc_else = get_loc br_else in
      let incr_message = get_mess sloc_else in
      let newbr_else = seq incr_message (rewrite br_else) in
      Pexp_ifthenelse (condition, newbr_then, Some(newbr_else))

    | Pexp_construct (_, _) -> expr.pexp_desc

    | Pexp_while (condition, action) ->
      let sloc_action = get_loc action in
      let incr_message = get_mess sloc_action in
      let new_action = seq incr_message (rewrite action) in
      Pexp_while(condition, new_action)
   
    | Pexp_match (expression, case_list) ->
      let tracecase _cpt case =
        let sloc_case = get_loc case.pc_rhs in
        let incr_message = get_mess sloc_case in
         {case with pc_rhs = seq incr_message (rewrite case.pc_rhs)} in
      Pexp_match (expression,List.mapi tracecase case_list)

    | Pexp_try (expression, case_list) ->
      let tracecase _cpt case =
        let sloc_case = get_loc case.pc_rhs in
        let incr_message = get_mess sloc_case in
         {case with pc_rhs = seq incr_message (rewrite case.pc_rhs)} in
      Pexp_try (rewrite expression, List.mapi tracecase case_list)


    | Pexp_fun (label, ex, pattern, expression) ->
      (* let compiled_location = Format.asprintf "%a" Location.print_loc expr.pexp_loc in
      let incr_message = apply_nolbl_s "Cover_runtime.increment" [string_ compiled_location ] in
      let new_expression = seq incr_message (rewrite expression) in *)
      Pexp_fun (label, ex, pattern, expression)

    | Pexp_function (case_list) -> 
      let tracecase _cpt case =
        let sloc_case = get_loc case.pc_rhs in
        let incr_message = get_mess sloc_case in
         {case with pc_rhs = seq incr_message (rewrite case.pc_rhs)} in
      Pexp_function(List.mapi tracecase case_list)

    | Pexp_let (flag, arg_list, expression) -> 
        let sloc_expr = get_loc expression in
        let incr_message = get_mess sloc_expr in
        let new_expression = seq incr_message (rewrite expression) in
      Pexp_let (flag, arg_list, new_expression)

    | Pexp_apply (expression, arg_list) -> (* semble être en redondance avec pexp_function *)



      (* let compiled_location1 = string_of_int  expression.pexp_loc.loc_start.pos_lnum  in
      let compiled_location2 = string_of_int  (expression.pexp_loc.loc_start.pos_cnum - expression.pexp_loc.loc_start.pos_bol)  in
      let compiled_location = String.concat " "  ["line :";compiled_location1;" col :"; compiled_location2 ;"\n"] in
      let incr_message = apply_nolbl_s "Cover_runtime.increment" [string_ compiled_location ] in
      let new_expression = seq incr_message (rewrite expression) in *)

      Pexp_apply (expression, arg_list)
    | Pexp_sequence (e1, e2) -> 
      Pexp_sequence (rewrite e1, rewrite e2)

    | Pexp_tuple _

    | Pexp_variant (_, _)
    | Pexp_record (_, _)
    | Pexp_field (_, _)
    | Pexp_setfield (_, _, _)
    | Pexp_array (_)
    | Pexp_for (_, _, _, _, _)
    | Pexp_constraint (_, _)
    | Pexp_coerce (_, _, _)
    | Pexp_send (_, _)
    | Pexp_new _
    | Pexp_setinstvar (_,_)
    | Pexp_override (_)
    | Pexp_letmodule (_,_,_)
    | Pexp_letexception (_, _)
    | Pexp_assert _ | Pexp_lazy _
    | Pexp_poly (_, _)
    | Pexp_object _
    | Pexp_newtype (_, _)
    | Pexp_pack _
    | Pexp_open (_, _)
    | Pexp_letop _ | Pexp_extension _ | Pexp_unreachable ->
        Format.asprintf "%a: not implemented yet - skipping"
          print_expression expr |> failwith
  in
  {expr with pexp_desc=desc'}

let float_ x =
  Exp.constant(Pconst_float( (string_of_float x), None))



let (+@) e1 e2 =
apply_nolbl_s "+." [e1;e2]

let ($@) e1 e2 =    (*erreur si je mets * ou x *)
apply_nolbl_s "*." [e1;e2]

let (/@) e1 e2 =
apply_nolbl_s "/." [e1;e2]

let (=@) e1 e2 =
apply_nolbl_s "=." [e1;e2]

let case_to_exp case =
  case.pc_rhs

let visit_exp exp =  apply_nolbl_s "Cover_runtime.isVisited_f" [string_ (get_loc (exp))] 

let prod_vexp loc exp = 
    loc $@  exp

    


let  rec couverture expression = match expression.pexp_desc with
 

  | Pexp_ifthenelse (_condition, br_then, Some(br_else)) -> (float_ 0.5 $@ couverture br_then $@ apply_nolbl_s "Cover_runtime.isVisited_f" [string_ (get_loc br_then)]
  )+@ (float_ 0.5 $@ apply_nolbl_s "Cover_runtime.isVisited_f" [string_ (get_loc br_else)] $@ couverture br_else)
  | Pexp_constant (_c)  -> float_ 1.0
  | Pexp_sequence (e1, e2) -> (couverture e1 +@ couverture e2) /@ (float_ 2.0)
  | Pexp_match  (_expression, case_list) -> (* par simplicité on considère que chaque branche pèse 1/nb de cas*)
      let locs = List.map visit_exp (List.map case_to_exp case_list) in
      let list_couv = List.map couverture (List.map case_to_exp case_list) in
      let div_length exp =
        exp /@ (float_ (float_of_int (List.length case_list))) in
      let couv_quotient = List.map div_length list_couv in
      let couv_quotient_visited = List.map2 prod_vexp locs couv_quotient in
      let rec sum l  =
          match l with
          []->float_ 0.0
          |h::t-> h +@ (sum t) in
          sum couv_quotient_visited;
    
  | _ ->float_ 1.0  
  (* | _ ->  string_ "not implemented yet - skipping"   *)  (* ne reconnait pas () et donc multiplie string et float*)





let get_name vb =
  match vb.pvb_pat.ppat_desc with
  | Ppat_var {txt;_} -> txt
  | _ -> "arbitrary"

let cover_function vb  =
  let name = get_name vb in
  let fun_cov =
    Exp.fun_ Nolabel None
      (Pat.construct (lid_loc "()") None)
      (* (Exp.construct (lid_loc "()") None) *)
      (couverture vb.pvb_expr)
    
  in let get_cov_vb = Vb.mk (Pat.var (def_loc ("__funcov_"^name))) fun_cov in
  Str.value Nonrecursive [get_cov_vb] 


(* actual mapper *)
let mapper =
  let handle_bind _mapper (bind:value_binding) =
    {bind with pvb_expr = rewrite bind.pvb_expr}
  in
  let handle_str mapper (str:structure) =
    let rec aux acc str =
      match str with
      | [] ->  List.rev acc
      | ({pstr_desc= Pstr_value (_, [pvb]); _} as h) :: tl ->
         let get_cov = cover_function pvb in
         let h' = mapper.structure_item mapper h in
         aux ((get_cov::h' :: acc)) tl
      | h :: tl ->
          let h' = mapper.structure_item mapper h in
          aux (h' :: acc) tl
    in
    aux [] str
  in
  { default_mapper with
    value_binding= handle_bind; structure=handle_str}

let () =
  let open Migrate_parsetree in
  Driver.register ~name:"ppx_cover" ~args:[] Versions.ocaml_410
    (fun _config _cookies -> mapper) ;
