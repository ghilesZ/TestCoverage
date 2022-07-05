let x =
  if true
  then (Cover_runtime.increment "line : 3  col : 5"; 2)
  else (Cover_runtime.increment "line : 3  col : 22"; 3)
