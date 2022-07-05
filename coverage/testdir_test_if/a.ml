let f () =
  Cover_runtime.increment
    "File \"./examples/test_if.ml\", lines 1-4, characters 6-6";
  if true
  then
    (Cover_runtime.increment
       "File \"./examples/test_if.ml\", line 3, characters 5-6";
     2)
  else
    (Cover_runtime.increment
       "File \"./examples/test_if.ml\", lines 2-4, characters 0-6";
     3)
