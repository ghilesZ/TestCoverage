[@@@ocaml.warning "-32"]
let x =
  if false
  then (print_endline "I went through then branch"; 2)
  else (print_endline "I went through else branch"; 1)
let z = 6
let y =
  while false do
    Cover_runtime.increment
      "File \"./examples/constant.ml\", line 4, characters 8-30";
    () done
let x =
  match 2 with
  | 2 -> (print_endline "I went through case number 0"; 3)
  | 5 -> (print_endline "I went through case number 1"; 11)
  | _ -> (print_endline "I went through case number 2"; 12)


let () = Hashtbl.iter print_truc Cover_runtime.counters