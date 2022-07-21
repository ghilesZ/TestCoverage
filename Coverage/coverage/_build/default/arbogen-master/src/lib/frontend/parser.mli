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

val start :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Options.parameter list * ParseTree.t
