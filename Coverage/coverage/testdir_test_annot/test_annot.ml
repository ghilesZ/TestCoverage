let f x = (if true then x else - x : int)
let () = Testify_runtime.run_test ()
