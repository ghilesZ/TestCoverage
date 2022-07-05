[@@@ocaml.warning "-32"]
let x =
  if false
  then
    (Cover_runtime.increment
       "File \"./examples/constant.ml\", lines 2-3, characters 8-6";
     2)
  else
    (Cover_runtime.increment
       "File \"./examples/constant.ml\", lines 2-3, characters 8-6";
     1)
let z = 6
let y =
  while false do
    Cover_runtime.increment
      "File \"./examples/constant.ml\", lines 8-11, characters 8-4";
    () done
