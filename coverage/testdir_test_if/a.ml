let x =
  if true
  then (Cover_runtime.increment "line : 3-3  col : 5-6"; 2)
  else (Cover_runtime.increment "line : 4-4  col : 5-6"; 3)
let __funcov_x () =
  ((0.5 *. 1.) *. (Cover_runtime.isVisited_f "line : 3-3  col : 5-6")) +.
    ((0.5 *. (Cover_runtime.isVisited_f "line : 4-4  col : 5-6")) *. 1.)
