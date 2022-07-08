let y = true
let __funcov_y () = 1.
let g =
  if true
  then (Cover_runtime.increment "line : 9  col : 4"; ())
  else (Cover_runtime.increment "line : 9  col : 12"; ());
  if true
  then (Cover_runtime.increment "line : 11  col : 7"; 4)
  else (Cover_runtime.increment "line : 12  col : 5"; 3)
let __funcov_g () =
  ((((0.5 *. 1.) *. (Cover_runtime.isVisited_f "line : 9  col : 4")) +.
      ((0.5 *. (Cover_runtime.isVisited_f "line : 9  col : 12")) *. 1.))
     +.
     (((0.5 *. 1.) *. (Cover_runtime.isVisited_f "line : 11  col : 7")) +.
        ((0.5 *. (Cover_runtime.isVisited_f "line : 12  col : 5")) *. 1.)))
    /. 2.
