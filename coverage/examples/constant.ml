[@@@ocaml.warning "-32"]
let x = if false then  2
else 1
let z = 6



let y = while
 false 
 do () 
done
(* let b = let cpt = ref 0 in
  while !cpt < 2
do cpt := !cpt+1;

done; *)

(* let f a =
  a+1 *)

(* let x = match 5 with
  | 2 ->3
  | 5 -> 11
  | _ -> 12 *)
