type token =
  | UIDENT of (string)
  | LIDENT of (string)
  | EOF
  | SET
  | NUMI of (int)
  | NUMF of (float)
  | SEQ
  | PLUS
  | EQUAL
  | TIMES
  | LWEIGHT
  | RWEIGHT
  | LPAREN
  | RPAREN
  | ONE
  | Z

open Parsing;;
let _ = parse_error;;
let yytransl_const = [|
    0 (* EOF *);
  259 (* SET *);
  262 (* SEQ *);
  263 (* PLUS *);
  264 (* EQUAL *);
  265 (* TIMES *);
  266 (* LWEIGHT *);
  267 (* RWEIGHT *);
  268 (* LPAREN *);
  269 (* RPAREN *);
  270 (* ONE *);
  271 (* Z *);
    0|]

let yytransl_block = [|
  257 (* UIDENT *);
  258 (* LIDENT *);
  260 (* NUMI *);
  261 (* NUMF *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\002\000\004\000\005\000\005\000\005\000\003\000\
\003\000\006\000\007\000\007\000\008\000\008\000\009\000\009\000\
\010\000\010\000\011\000\011\000\011\000\011\000\011\000\011\000\
\000\000"

let yylen = "\002\000\
\003\000\000\000\002\000\003\000\001\000\001\000\001\000\001\000\
\002\000\003\000\001\000\001\000\003\000\003\000\001\000\001\000\
\003\000\003\000\003\000\001\000\004\000\003\000\001\000\001\000\
\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\025\000\000\000\000\000\000\000\000\000\
\000\000\000\000\003\000\007\000\006\000\005\000\004\000\000\000\
\001\000\009\000\020\000\000\000\000\000\000\000\024\000\023\000\
\010\000\011\000\000\000\015\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\022\000\019\000\014\000\000\000\018\000\
\000\000\021\000"

let yydgoto = "\002\000\
\004\000\005\000\009\000\006\000\015\000\010\000\025\000\026\000\
\027\000\028\000\029\000"

let yysindex = "\005\000\
\005\255\000\000\008\255\000\000\011\255\005\255\014\255\009\255\
\020\000\011\255\000\000\000\000\000\000\000\000\000\000\255\254\
\000\000\000\000\000\000\010\255\017\255\255\254\000\000\000\000\
\000\000\000\000\016\255\000\000\015\255\255\254\018\255\012\255\
\255\254\255\254\013\255\000\000\000\000\000\000\016\255\000\000\
\015\255\000\000"

let yyrindex = "\000\000\
\026\255\000\000\000\000\000\000\000\000\026\255\000\000\000\000\
\000\000\028\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\003\000\000\000\001\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\004\000\000\000\
\002\000\000\000"

let yygindex = "\000\000\
\000\000\024\000\021\000\000\000\000\000\000\000\241\255\255\255\
\006\000\007\000\008\000"

let yytablesize = 273
let yytable = "\019\000\
\016\000\017\000\012\000\013\000\020\000\001\000\032\000\003\000\
\021\000\007\000\022\000\008\000\023\000\024\000\035\000\012\000\
\016\000\013\000\014\000\017\000\031\000\030\000\033\000\034\000\
\037\000\042\000\002\000\008\000\036\000\011\000\018\000\038\000\
\000\000\000\000\000\000\000\000\000\000\000\000\039\000\000\000\
\040\000\041\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\016\000\017\000\012\000\013\000\000\000\000\000\016\000\
\017\000\000\000\000\000\000\000\000\000\016\000\017\000\012\000\
\013\000"

let yycheck = "\001\001\
\000\000\000\000\000\000\000\000\006\001\001\000\022\000\003\001\
\010\001\002\001\012\001\001\001\014\001\015\001\030\000\002\001\
\008\001\004\001\005\001\000\000\004\001\012\001\007\001\009\001\
\013\001\013\001\001\001\000\000\011\001\006\000\010\000\033\000\
\255\255\255\255\255\255\255\255\255\255\255\255\033\000\255\255\
\034\000\034\000\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\001\001\001\001\001\001\001\001\255\255\255\255\007\001\
\007\001\255\255\255\255\255\255\255\255\013\001\013\001\013\001\
\013\001"

let yynames_const = "\
  EOF\000\
  SET\000\
  SEQ\000\
  PLUS\000\
  EQUAL\000\
  TIMES\000\
  LWEIGHT\000\
  RWEIGHT\000\
  LPAREN\000\
  RPAREN\000\
  ONE\000\
  Z\000\
  "

let yynames_block = "\
  UIDENT\000\
  LIDENT\000\
  NUMI\000\
  NUMF\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'option_list) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'rule_list) in
    Obj.repr(
# 21 "arbogen-master/src/lib/frontend/parser.mly"
                            ( _1, _2 )
# 193 "arbogen-master/src/lib/frontend/parser.ml"
               : Options.parameter list * ParseTree.t))
; (fun __caml_parser_env ->
    Obj.repr(
# 28 "arbogen-master/src/lib/frontend/parser.mly"
    ( [] )
# 199 "arbogen-master/src/lib/frontend/parser.ml"
               : 'option_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'arbogen_option) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'option_list) in
    Obj.repr(
# 29 "arbogen-master/src/lib/frontend/parser.mly"
                               ( _1 :: _2 )
# 207 "arbogen-master/src/lib/frontend/parser.ml"
               : 'option_list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'value) in
    Obj.repr(
# 32 "arbogen-master/src/lib/frontend/parser.mly"
                   ( (_2, _3) )
# 215 "arbogen-master/src/lib/frontend/parser.ml"
               : 'arbogen_option))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : float) in
    Obj.repr(
# 35 "arbogen-master/src/lib/frontend/parser.mly"
            ( Options.Value.Float _1 )
# 222 "arbogen-master/src/lib/frontend/parser.ml"
               : 'value))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 36 "arbogen-master/src/lib/frontend/parser.mly"
            ( Options.Value.Int _1 )
# 229 "arbogen-master/src/lib/frontend/parser.ml"
               : 'value))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 37 "arbogen-master/src/lib/frontend/parser.mly"
            ( Options.Value.String _1 )
# 236 "arbogen-master/src/lib/frontend/parser.ml"
               : 'value))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'rule) in
    Obj.repr(
# 44 "arbogen-master/src/lib/frontend/parser.mly"
                   ( [_1] )
# 243 "arbogen-master/src/lib/frontend/parser.ml"
               : 'rule_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'rule) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'rule_list) in
    Obj.repr(
# 45 "arbogen-master/src/lib/frontend/parser.mly"
                   ( _1 :: _2 )
# 251 "arbogen-master/src/lib/frontend/parser.ml"
               : 'rule_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 48 "arbogen-master/src/lib/frontend/parser.mly"
                    ( _1, _3 )
# 259 "arbogen-master/src/lib/frontend/parser.ml"
               : 'rule))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'union) in
    Obj.repr(
# 53 "arbogen-master/src/lib/frontend/parser.mly"
                    ( Grammar.union _1 )
# 266 "arbogen-master/src/lib/frontend/parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'pof) in
    Obj.repr(
# 54 "arbogen-master/src/lib/frontend/parser.mly"
                    ( _1 )
# 273 "arbogen-master/src/lib/frontend/parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'pof) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'pof) in
    Obj.repr(
# 57 "arbogen-master/src/lib/frontend/parser.mly"
                    ( [_1; _3] )
# 281 "arbogen-master/src/lib/frontend/parser.ml"
               : 'union))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'pof) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'union) in
    Obj.repr(
# 58 "arbogen-master/src/lib/frontend/parser.mly"
                    ( _1 :: _3 )
# 289 "arbogen-master/src/lib/frontend/parser.ml"
               : 'union))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'product) in
    Obj.repr(
# 62 "arbogen-master/src/lib/frontend/parser.mly"
            ( Grammar.product _1 )
# 296 "arbogen-master/src/lib/frontend/parser.ml"
               : 'pof))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'factor) in
    Obj.repr(
# 63 "arbogen-master/src/lib/frontend/parser.mly"
            ( _1 )
# 303 "arbogen-master/src/lib/frontend/parser.ml"
               : 'pof))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'factor) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'factor) in
    Obj.repr(
# 66 "arbogen-master/src/lib/frontend/parser.mly"
                            ( [_1; _3] )
# 311 "arbogen-master/src/lib/frontend/parser.ml"
               : 'product))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'factor) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'product) in
    Obj.repr(
# 67 "arbogen-master/src/lib/frontend/parser.mly"
                            ( _1 :: _3 )
# 319 "arbogen-master/src/lib/frontend/parser.ml"
               : 'product))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 70 "arbogen-master/src/lib/frontend/parser.mly"
                            ( _2 )
# 326 "arbogen-master/src/lib/frontend/parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 71 "arbogen-master/src/lib/frontend/parser.mly"
                            ( Grammar.Ref _1 )
# 333 "arbogen-master/src/lib/frontend/parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 72 "arbogen-master/src/lib/frontend/parser.mly"
                            ( Grammar.Seq _3 )
# 340 "arbogen-master/src/lib/frontend/parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : int) in
    Obj.repr(
# 73 "arbogen-master/src/lib/frontend/parser.mly"
                            ( Grammar.Z _2 )
# 347 "arbogen-master/src/lib/frontend/parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    Obj.repr(
# 74 "arbogen-master/src/lib/frontend/parser.mly"
                            ( Grammar.Z 1 )
# 353 "arbogen-master/src/lib/frontend/parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    Obj.repr(
# 75 "arbogen-master/src/lib/frontend/parser.mly"
                            ( Grammar.Z 0 )
# 359 "arbogen-master/src/lib/frontend/parser.ml"
               : 'factor))
(* Entry start *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let start (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Options.parameter list * ParseTree.t)
