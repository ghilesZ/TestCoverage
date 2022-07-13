let g =
  if true
  then (Cover_runtime.increment "line 4, col 4 to line 4 col 6"; ())
  else (Cover_runtime.increment "line 4, col 12 to line 4 col 14"; ());
  if false
  then (Cover_runtime.increment "line 6, col 7 to line 6 col 8"; 4)
  else
    (Cover_runtime.increment "line 7, col 5 to line 10 col 8";
     (match 6 with
      | 6 -> (Cover_runtime.increment "line 8, col 7 to line 8 col 8"; 5)
      | 7 -> (Cover_runtime.increment "line 9, col 7 to line 9 col 8"; 3)
      | _ -> (Cover_runtime.increment "line 10, col 7 to line 10 col 8"; 3)))
let __funcov_g () =
  (((Cover_runtime.isVisited_f "line 2, col 2 to line 4 col 14") *.
      ((((Cover_runtime.isVisited_f "line 4, col 4 to line 4 col 6") *. 1.)
          *. 0.5)
         +.
         (((Cover_runtime.isVisited_f "line 4, col 12 to line 4 col 14") *.
             1.)
            *. 0.5)))
     *. 0.5)
    +.
    (((Cover_runtime.isVisited_f "line 5, col 2 to line 10 col 8") *.
        ((((Cover_runtime.isVisited_f "line 6, col 7 to line 6 col 8") *. 1.)
            *. 0.5)
           +.
           (((Cover_runtime.isVisited_f "line 7, col 5 to line 10 col 8") *.
               (((Cover_runtime.isVisited_f "line 8, col 7 to line 8 col 8")
                   *. (1. *. (1. /. 3.)))
                  +.
                  (((Cover_runtime.isVisited_f
                       "line 9, col 7 to line 9 col 8")
                      *. (1. *. (1. /. 3.)))
                     +.
                     (((Cover_runtime.isVisited_f
                          "line 10, col 7 to line 10 col 8")
                         *. (1. *. (1. /. 3.)))
                        +. 0.))))
              *. 0.5)))
       *. 0.5)
