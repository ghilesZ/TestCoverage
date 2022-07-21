let x =
  if true
  then
    (Testify_runtime.on_passage "line 3 col 5 to line 3 col 6 " "then";
     Testify_runtime.increment "line 3 col 5 to line 3 col 6 ";
     2)
  else
    (Testify_runtime.on_passage "line 4 col 5 to line 4 col 6 " "else";
     Testify_runtime.increment "line 4 col 5 to line 4 col 6 ";
     3)
let __funcov_x () =
  (((Testify_runtime.isVisited_f "line 3 col 5 to line 3 col 6 ") *. 1.) *.
     0.5)
    +.
    (((Testify_runtime.isVisited_f "line 4 col 5 to line 4 col 6 ") *. 1.) *.
       0.5)
