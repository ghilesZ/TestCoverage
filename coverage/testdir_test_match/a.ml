let y =
  match 0 with
  | 0 -> (Cover_runtime.increment "line : 2  col : 6 \n"; 1)
  | _ -> (Cover_runtime.increment "line : 3  col : 7 \n"; 5)
