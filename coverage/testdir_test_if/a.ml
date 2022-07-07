let x =
  if true
  then ((Cover_runtime.increment "line : 3  col : 5"; print_string "1."); 2)
  else (Cover_runtime.increment "line : 3  col : 22"; 3)
let y =
  if false
  then ((Cover_runtime.increment "line : 6  col : 7"; print_string "1."); 4)
  else (Cover_runtime.increment "line : 7  col : 5"; 6)
