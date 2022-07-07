let y =
  let f x = match x with | 0 -> (-1) | _ -> x * x in
  Cover_runtime.increment "line : 5  col : 4 \n"; f 2
