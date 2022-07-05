let counters : (string, int) Hashtbl.t = Hashtbl.create 97

let increment loc =
  match Hashtbl.find_opt counters loc with
  | None -> Hashtbl.add counters loc 1
  | Some n -> Hashtbl.replace counters loc (n+1)

let print_covers () =
  Format.printf "Number of entries: %i\n" (Hashtbl.length counters);
  Hashtbl.iter (fun x y -> Format.printf "%s %d\n" x y) counters
