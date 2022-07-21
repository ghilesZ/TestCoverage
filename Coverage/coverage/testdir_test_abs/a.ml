let abs x =
  Cover_runtime.on_passage "line 2, col 2 to line 4 col 9 " "fun";
  Cover_runtime.increment "line 2, col 2 to line 4 col 9 ";
  if x >= 0
  then
    (Cover_runtime.on_passage "line 2, col 17 to line 2 col 18 " "then";
     Cover_runtime.increment "line 2, col 17 to line 2 col 18 ";
     x)
  else
    (Cover_runtime.on_passage "line 3, col 7 to line 4 col 9 " "else";
     Cover_runtime.increment "line 3, col 7 to line 4 col 9 ";
     if x = min_int
     then
       (Cover_runtime.on_passage "line 3, col 27 to line 3 col 72 " "then";
        Cover_runtime.increment "line 3, col 27 to line 3 col 72 ";
        failwith "min_int has no positive equivalent")
     else
       (Cover_runtime.on_passage "line 4, col 7 to line 4 col 9 " "else";
        Cover_runtime.increment "line 4, col 7 to line 4 col 9 ";
        - x))
let __funcov_abs () =
  ((Cover_runtime.isVisited_f "line 2, col 2 to line 4 col 9 ") *.
     ((((Cover_runtime.isVisited_f "line 2, col 17 to line 2 col 18 ") *. 1.)
         *. 0.5)
        +.
        (((Cover_runtime.isVisited_f "line 3, col 7 to line 4 col 9 ") *.
            ((((Cover_runtime.isVisited_f "line 3, col 27 to line 3 col 72 ")
                 *. 1.)
                *. 0.5)
               +.
               (((Cover_runtime.isVisited_f "line 4, col 7 to line 4 col 9 ")
                   *. 1.)
                  *. 0.5)))
           *. 0.5)))
    *. 1.
