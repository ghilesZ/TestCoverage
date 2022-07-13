let counters : (string, int) Hashtbl.t = Hashtbl.create 97
let passage : (string, string) Hashtbl.t = Hashtbl.create 97



let increment loc =
  match Hashtbl.find_opt counters loc with
  | None -> Hashtbl.add counters loc 1
  | Some n -> Hashtbl.replace counters loc (n+1)

let on_passage loc (branche : string) =
  Hashtbl.add passage loc branche


let print_covers () =
  Format.printf "Number of entries: %i\n" (Hashtbl.length counters);
  Hashtbl.iter (fun x y -> Format.printf "%s %d\n" x y) counters

let get loc =
  Hashtbl.find loc
let isVisited loc =
  try 
    Hashtbl.find counters loc > 0
  with
  | Not_found -> false

  let float_of_bool bool =
    if bool
      then 1.0
  else 0.0

let isVisited_f loc =
  if (isVisited loc)
    then 1.0
else 0.0



