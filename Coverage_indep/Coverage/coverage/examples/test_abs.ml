
let abs x =
  if x >= 0 then x
  else if x = min_int then failwith "min_int has no positive equivalent"
  else -x
