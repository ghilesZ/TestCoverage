let y =
  match 0 with
  | 0 -> (Cover_runtime.increment "line : 2-2  col : 6-7"; 1)
  | 5 -> (Cover_runtime.increment "line : 3-3  col : 7-8"; 6)
  | _ -> (Cover_runtime.increment "line : 4-4  col : 7-8"; 5)
let __funcov_y () =
  ((Cover_runtime.isVisited_f "line : 2-2  col : 6-7") *. (1. /. 3.)) +.
    (((Cover_runtime.isVisited_f "line : 3-3  col : 7-8") *. (1. /. 3.)) +.
       (((Cover_runtime.isVisited_f "line : 4-4  col : 7-8") *. (1. /. 3.))
          +. 0.))


          let () =
          print_float(__funcov_y());