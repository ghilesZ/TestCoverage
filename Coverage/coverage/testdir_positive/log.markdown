### Declaration of type(s)
- source:

```ocaml
type nat = (int[@satisfying fun x -> x >= 0])

```

- Kind: abstract type
- type int
- Cardinality: ~2<sup>61</sup>
- Printer:

```ocaml
string_of_int
```

<details>
                     <summary>Collector</summary>
                     
```ocaml
                     Testify_runtime.Collect.int
```

</details>
- Specification:

```ocaml
fun x -> x >= 0
```

<details>
                       <summary>Boltzmann specification</summary>
                       
```
z^0
```

</details>

<details>
  <summary>Of_arbogen</summary>
  
```ocaml
  Testify_runtime.Arbg.to_int
```

</details>
- Generator:

```ocaml
Testify_runtime.weighted
  [ (0.5, fun rs -> (Testify_runtime.int_range 0x2000000000000000 max_int) rs)
  ; (0.5, fun rs -> (Testify_runtime.int_range 0 0x1fffffffffffffff) rs) ]
```


#### Declaration of a value *abs*
Return type `nat` is attached a specification. Generating a test.
