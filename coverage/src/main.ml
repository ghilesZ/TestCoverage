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

module Conv = Convert (OCaml_410) (OCaml_current)

let print_expression fmt e =
  Format.fprintf fmt "%a%!" Pprintast.expression (Conv.copy_expression e)

let print_pat fmt p = Pprintast.pattern fmt (Conv.copy_pattern p)
let current_loc = ref Location.none

let update_loc l = current_loc := l

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
       let msg = Const.string "I went through then branch" in
       let printmessage = apply_nolbl_s "print_endline" [Exp.constant msg] in
       let newbr_then = seq printmessage (rewrite br_then) in
       let msg = Const.string "I went through else branch" in
       let printmessage = apply_nolbl_s "print_endline" [Exp.constant msg] in
       let newbr_else = seq printmessage (rewrite br_else) in
       Pexp_ifthenelse (rewrite condition, newbr_then, Some(newbr_else))
    (* TODO: en dessous *)
    | Pexp_construct (_, _) -> expr.pexp_desc
    | Pexp_match (_, _)
    | Pexp_while (_, _)
    | Pexp_try (_, _)
    | Pexp_fun (_, _, _, _)
    | Pexp_apply (_, _)
    | Pexp_let (_, _, _)
    | Pexp_tuple _
    | Pexp_sequence (_, _)
    | Pexp_function (_)
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
