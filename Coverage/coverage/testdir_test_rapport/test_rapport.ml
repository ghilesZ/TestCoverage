let f x =
  if x < 3
  then
    match x with
    | 1 -> "one"
    | 2 -> "two"
    | _ -> "strictly less than 3; different from 1 and 2 "
  else "greater than 3"
let () = Testify_runtime.run_test ()
