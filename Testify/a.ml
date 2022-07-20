type nat = ((int)[@satisfying fun x -> x >= 0])
let abs (x : Int.t) =
  Testify_runtime.on_passage "line 2 col 22 to line 2 col 55 " "fun";
  Testify_runtime.increment "line 2 col 22 to line 2 col 55 ";
  (if x >= 0 then x else - x : nat)
let __funcov_abs () =
  ((Testify_runtime.isVisited_f "line 2 col 22 to line 2 col 55 ") *. 1.) *.
    1.
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
let __funcov_arbitrary () = 1.
let () = Testify_runtime.run_test ()
let __funcov_arbitrary () = 1.
