let x = ref 2 

while !x < 5 
do
match !x with
| 4 -> 6
| _ -> 4;
done;