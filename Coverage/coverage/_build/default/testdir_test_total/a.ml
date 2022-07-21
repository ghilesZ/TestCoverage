let g =
  if true
  then
    (if true
     then
       (Cover_runtime.on_passage "line 4, col 18 to line 4 col 20 " "then";
        Cover_runtime.increment "line 4, col 18 to line 4 col 20 ";
        ())
     else
       (Cover_runtime.on_passage "line 5, col 10 to line 5 col 12 " "else";
        Cover_runtime.increment "line 5, col 10 to line 5 col 12 ";
        ()));
  if false
  then
    (Cover_runtime.on_passage "line 7, col 7 to line 7 col 8 " "then";
     Cover_runtime.increment "line 7, col 7 to line 7 col 8 ";
     4)
  else
    (Cover_runtime.on_passage "line 9, col 2 to line 13 col 6 " "else";
     Cover_runtime.increment "line 9, col 2 to line 13 col 6 ";
     if true
     then
       (Cover_runtime.on_passage "line 9, col 15 to line 12 col 8 " "then";
        Cover_runtime.increment "line 9, col 15 to line 12 col 8 ";
        (match 6 with
         | 6 ->
             (Cover_runtime.on_passage "line 10, col 7 to line 10 col 8 "
                "case match";
              Cover_runtime.increment "line 10, col 7 to line 10 col 8 ";
              5)
         | 7 ->
             (Cover_runtime.on_passage "line 11, col 7 to line 11 col 8 "
                "case match";
              Cover_runtime.increment "line 11, col 7 to line 11 col 8 ";
              3)
         | _ ->
             (Cover_runtime.on_passage "line 12, col 7 to line 12 col 8 "
                "case match";
              Cover_runtime.increment "line 12, col 7 to line 12 col 8 ";
              3)))
     else
       (Cover_runtime.on_passage "line 13, col 5 to line 13 col 6 " "else";
        Cover_runtime.increment "line 13, col 5 to line 13 col 6 ";
        4))
let __funcov_g () =
  (((Cover_runtime.isVisited_f "line 2, col 2 to line 5 col 12 ") *. 1.) *.
     0.5)
    +.
    (((Cover_runtime.isVisited_f "line 6, col 2 to line 13 col 6 ") *.
        ((((Cover_runtime.isVisited_f "line 7, col 7 to line 7 col 8 ") *. 1.)
            *. 0.5)
           +.
           (((Cover_runtime.isVisited_f "line 9, col 2 to line 13 col 6 ") *.
               ((((Cover_runtime.isVisited_f
                     "line 9, col 15 to line 12 col 8 ")
                    *.
                    (((Cover_runtime.isVisited_f
                         "line 10, col 7 to line 10 col 8 ")
                        *. (1. *. (1. /. 3.)))
                       +.
                       (((Cover_runtime.isVisited_f
                            "line 11, col 7 to line 11 col 8 ")
                           *. (1. *. (1. /. 3.)))
                          +.
                          (((Cover_runtime.isVisited_f
                               "line 12, col 7 to line 12 col 8 ")
                              *. (1. *. (1. /. 3.)))
                             +. 0.))))
                   *. 0.5)
                  +.
                  (((Cover_runtime.isVisited_f
                       "line 13, col 5 to line 13 col 6 ")
                      *. 1.)
                     *. 0.5)))
              *. 0.5)))
       *. 0.5)
