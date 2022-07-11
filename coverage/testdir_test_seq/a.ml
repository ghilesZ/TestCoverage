let y = true
let __funcov_y () = 1.
let g =
  if true
  then (Cover_runtime.increment "line : 9-9  col : 4-6"; ())
  else (Cover_runtime.increment "line : 9-9  col : 12-14"; ());
  if true
  then (Cover_runtime.increment "line : 11-11  col : 7-8"; 4)
  else (Cover_runtime.increment "line : 12-12  col : 5-6"; 3)
let __funcov_g () =
  ((((0.5 *. 1.) *. (Cover_runtime.isVisited_f "line : 9-9  col : 4-6")) +.
      ((0.5 *. (Cover_runtime.isVisited_f "line : 9-9  col : 12-14")) *. 1.))
     +.
     (((0.5 *. 1.) *. (Cover_runtime.isVisited_f "line : 11-11  col : 7-8"))
        +.
        ((0.5 *. (Cover_runtime.isVisited_f "line : 12-12  col : 5-6")) *. 1.)))
    /. 2.
