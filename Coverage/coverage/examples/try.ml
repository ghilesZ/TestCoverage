

let f a = try 4/a 
with 
| Division_by_zero -> 5 
| _ -> 3
