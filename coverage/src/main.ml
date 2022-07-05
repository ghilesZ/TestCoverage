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

let rec rewrite (expr:expression) : expression =
  let desc' =
    match expr.pexp_desc with
    | Pexp_constant _ -> expr.pexp_desc
    | Pexp_ident _ -> expr.pexp_desc
    | Pexp_ifthenelse (condition, branch_then, None) ->
       Pexp_ifthenelse (rewrite condition, rewrite branch_then, None)
    | Pexp_ifthenelse (condition, br_then, Some(br_else)) ->
       let compiled_location1 = string_of_int  br_then.pexp_loc.loc_start.pos_lnum  in
       let compiled_location2 = string_of_int  (br_then.pexp_loc.loc_start.pos_cnum - br_then.pexp_loc.loc_start.pos_bol)  in
       let compiled_location = String.concat " "  ["line :";compiled_location1;" col :"; compiled_location2] in
       let incr_message = apply_nolbl_s "Cover_runtime.increment" [string_ compiled_location ] in
       let newbr_then =  seq incr_message  (rewrite br_then) in
       let compiled_location1 = string_of_int  br_else.pexp_loc.loc_start.pos_lnum  in
       let compiled_location2 = string_of_int  (br_else.pexp_loc.loc_start.pos_cnum - br_else.pexp_loc.loc_start.pos_bol)  in
       let compiled_location = String.concat " "  ["line :";compiled_location1;" col :"; compiled_location2] in
       let incr_message = apply_nolbl_s "Cover_runtime.increment" [string_ compiled_location ] in
       let newbr_else = seq incr_message (rewrite br_else) in
       Pexp_ifthenelse (condition, newbr_then, Some(newbr_else))
    | Pexp_construct (_, _) -> expr.pexp_desc
    | Pexp_while (condition, action) ->
      let compiled_location1 = string_of_int  action.pexp_loc.loc_start.pos_lnum  in
      let compiled_location2 = string_of_int  (action.pexp_loc.loc_start.pos_cnum - action.pexp_loc.loc_start.pos_bol)  in
      let compiled_location = String.concat " "  ["line :";compiled_location1;" col :"; compiled_location2] in
      let incr_message = apply_nolbl_s "Cover_runtime.increment" [string_ compiled_location ] in
       let new_action = seq incr_message (rewrite action) in
       Pexp_while(condition, new_action)
    (* | Pexp_function (case) ->
       let msg = Const.string "I went through %s" Parsetree.case.pc_lhs.pattern_desc in
       let printmessage = apply_nolbl_s "print_endline" [Exp.constant msg] in
       let new_case = seq printmessage (rewrite case) in
       Pexp_function (new_case) *)
    | Pexp_match (expression, case_list) ->
      (* let l = List.length case_list in
       * let cpt = ref 0 in
       * let reflist = ref [] in
       * while !cpt < l
       * do
       *   let str = Format.asprintf "I went through case number %i" !cpt in
       *   let msg = Const.string str in
       *   let printmessage = apply_nolbl_s "print_endline" [Exp.constant msg] in
       *   let fst = List.nth case_list !cpt in
       *   let new_case = {fst with pc_rhs = seq printmessage (rewrite fst.pc_rhs)} in
       *   reflist := !reflist @ [new_case];
       *   cpt := !cpt+1;
       * done;
       * Pexp_match (rewrite expression, !reflist) *)
       let tracecase cpt case =
          let str = Format.asprintf "I went through case number %i" cpt in
          let msg = Const.string str in
          let printmessage = apply_nolbl_s "print_endline" [Exp.constant msg] in
         {case with pc_rhs = seq printmessage (rewrite case.pc_rhs)}

       in
       (* let rec trace idx cases =
        *   match cases with
        *   | [] -> []
        *   | h::t -> (tracecase idx h)::(trace (idx+1) t)
        * in Pexp_match (rewrite expression, trace 1 case_list) *)
       Pexp_match (expression,List.mapi tracecase case_list)

    | Pexp_try (expression, case_list) ->
      let tracecase cpt case =
        let str = Format.asprintf "I went through case number %i" cpt in
        let msg = Const.string str in
        let printmessage = apply_nolbl_s "print_endline" [Exp.constant msg] in
       {case with pc_rhs = seq printmessage (rewrite case.pc_rhs)} in

      Pexp_try (rewrite expression, List.mapi tracecase case_list)


    | Pexp_fun (label, ex, pattern, expression) ->

      (* let compiled_location = Format.asprintf "%a" Location.print_loc expr.pexp_loc in
      let incr_message = apply_nolbl_s "Cover_runtime.increment" [string_ compiled_location ] in
      let new_expression = seq incr_message (rewrite expression) in *)

      Pexp_fun (label, ex, pattern, expression)

    | Pexp_function (case_list) -> 

      let tracecase _cpt case =
      
        let compiled_location = Format.asprintf "%a" Location.print_loc expr.pexp_loc in
        let incr_message = apply_nolbl_s "Cover_runtime.increment" [string_ compiled_location ] in
         {case with pc_rhs = seq incr_message (rewrite case.pc_rhs)} in
      
    
      Pexp_function(List.mapi tracecase case_list)
    | Pexp_let (flag, arg_list, expression) -> 
      let compiled_location = Format.asprintf "%a" Location.print_loc expr.pexp_loc in
      let incr_message = apply_nolbl_s "Cover_runtime.increment" [string_ compiled_location ] in
      let new_expression = seq incr_message (rewrite expression) in

      
      
      Pexp_let (flag, arg_list, new_expression)

    | Pexp_apply (_, _)
    | Pexp_tuple _
    | Pexp_sequence (_, _)

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

(* actual mapper *)
let mapper =
  let handle_bind _mapper (bind:value_binding) =
    {bind with pvb_expr = rewrite bind.pvb_expr}
  in
  { default_mapper with
    value_binding= handle_bind }

let () =
  let open Migrate_parsetree in
  Driver.register ~name:"ppx_cover" ~args:[] Versions.ocaml_410
    (fun _config _cookies -> mapper) ;
