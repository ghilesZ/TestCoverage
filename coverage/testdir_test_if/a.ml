let x =
  if true
  then (Cover_runtime.increment "line : 3  col : 5"; 2)
  else (Cover_runtime.increment "line : 3  col : 22"; 3)
let __funcov_x () =
  ((0.5 *. 1.) *. (Cover_runtime.isVisited_f "line : 3  col : 5")) +.
    ((0.5 *. (Cover_runtime.isVisited_f "line : 3  col : 22")) *. 1.)
;;if false then 12 else 14
let y =
  if false
  then (Cover_runtime.increment "line : 6  col : 7"; 4)
  else (Cover_runtime.increment "line : 7  col : 5"; 6)
let __funcov_y () =
  ((0.5 *. 1.) *. (Cover_runtime.isVisited_f "line : 6  col : 7")) +.
    ((0.5 *. (Cover_runtime.isVisited_f "line : 7  col : 5")) *. 1.)
