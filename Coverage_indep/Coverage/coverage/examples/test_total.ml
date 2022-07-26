let g =
  if true
    then 
     if true then () 
     else ();
  if false 
  then 4
else 
  if true then match 6 with
| 6 -> 5
| 7 -> 3
| _ -> 3
else 4;
