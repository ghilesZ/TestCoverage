type nat = ((int)[@satisfying fun x -> x >= 0])
let abs (x : Int.t) = (if x >= 0 then x else - x : nat)
let () =
  Testify_runtime.add_fun 0x2710 "abs"
    "File \"./examples/testifytests/positive.ml\", line 3, characters 0-52"
    (Testify_runtime.opt_print snd)
    (Testify_runtime.opt_gen
       (fun rs ->
          let x1 = QCheck.Gen.int rs in
          let x2 = abs x1 in
          (x2,
            ((("(abs " ^ (string_of_int x1)) ^ ")") ^
               (" = " ^ (string_of_int x2))))))
    (Testify_runtime.sat_output
       ((let open Testify_runtime.Operators in fun x -> x >= 0)
       [@warning "-33"]))
let () = Testify_runtime.run_test ()
