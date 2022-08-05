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

let get_loc {pexp_loc={loc_start;loc_end; _};_}  =
  Format.asprintf "line %i col %i to line %i col %i " 
    loc_start.pos_lnum (loc_start.pos_cnum - loc_start.pos_bol) 
    loc_end.pos_lnum (loc_end.pos_cnum - loc_end.pos_bol)
    


let get_mess  sloc =
  apply_nolbl_s "Testify_runtime.increment" [string_  sloc]
  
let update_passage sloc branche =
  apply_nolbl_s "Testify_runtime.on_passage" [string_  sloc;string_ branche] 


   


let rec rewrite (expr:expression) : expression =
  let desc' =
    match expr.pexp_desc with
    | Pexp_constant _ -> expr.pexp_desc
    | Pexp_ident _ -> expr.pexp_desc
    | Pexp_ifthenelse (condition, br_then, None) ->
      let sloc_then = get_loc br_then  in
      let incr_message = get_mess  sloc_then  in
      let pass_message = update_passage sloc_then "then, none" in
      let newbr_then =  seq pass_message  (seq incr_message  (rewrite br_then)) in
       Pexp_ifthenelse (condition, newbr_then, None)
    | Pexp_ifthenelse (condition, br_then, Some(br_else)) ->
      let sloc_then = get_loc br_then  in
      let incr_message = get_mess  sloc_then  in
      let pass_message = update_passage sloc_then "then" in
      let newbr_then =  seq pass_message  (seq incr_message  (rewrite br_then)) in
      let sloc_else = get_loc br_else  in
      let incr_message = get_mess sloc_else in
      let pass_message = update_passage sloc_else "else" in
      let newbr_else = seq pass_message (seq incr_message (rewrite br_else)) in
      Pexp_ifthenelse (condition, newbr_then, Some(newbr_else))

    | Pexp_construct (_, _) -> expr.pexp_desc

    | Pexp_while (condition, action) ->
      let sloc_action = get_loc action  in
      let incr_message = get_mess sloc_action in
      let pass_message = update_passage sloc_action "do" in

      let new_action = seq pass_message(seq incr_message (rewrite action)) in
      Pexp_while(condition, new_action)
   
    | Pexp_match (expression, case_list) ->
      let tracecase _cpt case =
        let sloc_case = get_loc case.pc_rhs  in
        let pass_message = update_passage sloc_case "case match" in

        let incr_message = get_mess sloc_case in
         {case with pc_rhs = seq pass_message (seq incr_message (rewrite case.pc_rhs))} in
      Pexp_match (expression,List.mapi tracecase case_list)

    | Pexp_try (expression, case_list) ->
      let tracecase _cpt case =
        let sloc_case = get_loc case.pc_rhs in
        let pass_message = update_passage sloc_case "case try" in
        let incr_message = get_mess sloc_case in
         {case with pc_rhs =seq pass_message( seq incr_message (rewrite case.pc_rhs))} in
      Pexp_try (rewrite expression, List.mapi tracecase case_list)


    | Pexp_fun (label, ex, pattern, expression) ->
        let sloc_expr = get_loc expression in
        let incr_message = get_mess sloc_expr in
        let pass_message = update_passage sloc_expr "fun" in
        
 
        let new_expression =seq pass_message (seq incr_message (rewrite expression)) in
      Pexp_fun (label, ex, pattern,  new_expression)

    | Pexp_let (flag, arg_list, expression) -> 
        let sloc_expr = get_loc expression in
        let incr_message = get_mess sloc_expr in
        let pass_message = update_passage sloc_expr "let" in
        let new_expression =seq pass_message ( seq incr_message (rewrite expression)) in
      Pexp_let (flag, arg_list, new_expression) 

    | Pexp_apply (expression, arg_list) ->
        if ((List.length arg_list) < 2)
          then (Pexp_apply(expression, arg_list))
        else
          let _lab1,left_term = List.hd arg_list in
          let _alb2,right_term = List.hd (List.tl arg_list) in  
          let str_exp = Format.asprintf "%a" print_expression expression in
          let str_or =  "(||)" in 
          if (str_exp = str_or) 
            then 
              let new_exprdesc = Pexp_ifthenelse( rewrite left_term,  left_term, Some( right_term)) in
              let new_expr = {expr with pexp_desc=new_exprdesc} in
              (rewrite new_expr).pexp_desc   
           else
            let new_arg_list = [(Nolabel,rewrite left_term);(Nolabel, rewrite right_term)] in  
            Pexp_apply( expression, new_arg_list)

      | Pexp_sequence (e1, e2) -> 
        Pexp_sequence (rewrite e1, rewrite e2)
      | Pexp_function (a) (* on ne l'utilisera presque pas*) -> Pexp_function (a)

      | Pexp_tuple a -> Pexp_tuple a
      | Pexp_variant (a, b) -> Pexp_variant (a, b)
      | Pexp_record (a, b) -> Pexp_record (a, b)
      | Pexp_field (a, b) -> Pexp_field (a, b)
      | Pexp_setfield (a, b, c) -> Pexp_setfield (a, b, c)
      | Pexp_array (a) -> Pexp_array (a)
      | Pexp_for (a, b, c, d, e) -> Pexp_for (a, b, c, d, e)
      | Pexp_constraint (expression, b) -> 
        let sloc_expr = get_loc expression in
        let incr_message = get_mess sloc_expr in
        let pass_message = update_passage sloc_expr "let" in
        let new_expression =seq pass_message ( seq incr_message (rewrite expression)) in
        Pexp_constraint (new_expression, b)
      | Pexp_coerce (a, b, c) -> Pexp_coerce (a, b, c)
      | Pexp_send (a, b) -> Pexp_send (a, b)
      | Pexp_new a -> Pexp_new a 
      | Pexp_setinstvar (a,b) -> Pexp_setinstvar (a,b) 
      | Pexp_override (a) -> Pexp_override (a)
      | Pexp_letmodule (a,b,c) -> Pexp_letmodule (a,b,c)
      | Pexp_letexception (a, b) -> Pexp_letexception (a, b)
      | Pexp_assert a -> Pexp_assert a
      | Pexp_lazy b -> Pexp_lazy b
      | Pexp_poly (a, b) -> Pexp_poly (a, b)
      | Pexp_object a -> Pexp_object a
      | Pexp_newtype (a, b) -> Pexp_newtype (a, b)
      | Pexp_pack a -> Pexp_pack a
      | Pexp_open (a, b) -> Pexp_open (a, b)
      | Pexp_letop a -> Pexp_letop a | Pexp_extension b -> Pexp_extension b | Pexp_unreachable -> Pexp_unreachable
          (* Format.asprintf "%a: not implemented yet - skipping"
            print_expression expr |> failwith *)
  in
  {expr with pexp_desc=desc'}

let float_ x =
  Exp.constant(Pconst_float( (string_of_float x), None))

(* Beacuse ppx rewriter works on AST*)

let ( +@ ) e1 e2 =
apply_nolbl_s "+." [e1;e2]

let ( *@ ) e1 e2 =    
apply_nolbl_s "*." [e1;e2]

let ( /@ ) e1 e2 =
apply_nolbl_s "/." [e1;e2]

let ( =@ ) e1 e2 =
apply_nolbl_s "=." [e1;e2]

let case_to_exp case =
  case.pc_rhs

let visit_exp exp =  apply_nolbl_s "Testify_runtime.isVisited_f" [string_ (get_loc (exp) )] 

let prod_vexp loc exp = 
    loc *@  exp

  
(* Calculation of the coverage*)


let  rec couverture expression  = 
match expression.pexp_desc with
 

  | Pexp_ifthenelse (_condition, br_then, Some(br_else)) ->
    (propagate br_then 0.5) +@ (propagate br_else 0.5)
  (* string_  apply_nolbl_s "Format.print_string !cpt"  *)
  | Pexp_constant (_c)  -> float_ 1.0
  | Pexp_sequence (e1, e2) -> (propagate e1 0.5  +@ propagate e2 0.5 )
  | Pexp_match  (_expression, case_list) -> 
      let locs = List.map visit_exp (List.map case_to_exp case_list) in
      let list_couv = List.map couverture  (List.map case_to_exp case_list)  in
      let div_length exp =
        exp /@ (float_ (float_of_int (List.length case_list))) in
      let couv_recu exp =
          couverture  (apply_nolbl_s "Testify_runtime.get" [string_ (get_loc exp )]) in
      let list_avec_recu = List.map couv_recu (List.map case_to_exp case_list) in
      let couv_quotient = List.map div_length list_couv in
      let prod_recu =
        List.map2 prod_vexp list_avec_recu couv_quotient in
      let couv_quotient_visited = List.map2 prod_vexp locs prod_recu in
      let rec sum l  =
          match l with
          []->float_ 0.0
          |h::t-> h +@ (sum t) in
          sum couv_quotient_visited;

    | Pexp_fun(_label, _ex, _pattern, expression ) -> propagate expression  1.0
    | Pexp_apply(expression, arg_list) -> if ((List.length arg_list) < 2)
      then float_ 1.0
    else
      let _lab1,left_term = List.hd arg_list in
      let _alb2,right_term = List.hd (List.tl arg_list) in  
      let str_exp = Format.asprintf "%a" print_expression expression in
      let str_or =  "(||)" in 
      if (str_exp = str_or) then
        propagate left_term 0.5 +@ propagate right_term 0.5
      else float_ 1.0

      |Pexp_constraint(a,_b) -> propagate a 1.0
  | _ ->float_ 1.0

  and propagate  exp weight  = ((visit_exp exp) *@ (couverture  exp)  *@ float_ weight  
  )
 

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
      (couverture  vb.pvb_expr) in
    

    
   let get_cov_vb = Vb.mk (Pat.var (def_loc ("__funcov_"^name))) fun_cov in
  Str.value Nonrecursive [get_cov_vb] 


  let   rewrite2 (expr:expression) : expression =
  let desc' =

  match expr.pexp_desc with
(* match Pexp_ifthenelse((Exp.constant (Const.string  (string_of_bool true))), Exp.constant (Const.int 2),  None) with  *)
(* | Pexp_ifthenelse (_a,_b, None)-> apply_nolbl_s "if" *)
| (_) ->  (Exp.constant (Const.string "rien")).pexp_desc in
(* | _ ->  Format.asprintf "%a: not implemented yet - skipping" 
print_expression expr in *)
(* actual mapper *)
{expr with pexp_desc=desc'}

let mapper =
  let handle_bind _mapper (bind:value_binding) =
    {bind with pvb_expr = rewrite bind.pvb_expr}
    
  
  (* let handle_bind2 _mapper (bind:value_binding)  =
    {bind with pvb_expr = rewrite2 bind.pvb_expr } *)
    
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
    (fun _config _cookies -> mapper) 
    (* let a = Exp.constant(Pconst_integer ("", None)) *)

    

   