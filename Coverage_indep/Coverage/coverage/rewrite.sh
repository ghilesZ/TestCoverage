set -euC

if [ $# -eq 0 ]; then
    echo 'Error: was expecting some OCaml file'
    exit 1
fi
fbname=$(basename "$1" .ml)

dir="testdir_$fbname"

rm -rf "$dir"
mkdir -p "$dir"

dune exec src/rewriter.exe -- "$1" > "$dir/a.ml"
echo "(env
  (dev
    (flags (:standard -w -32))))(executable (name a)(libraries testify_runtime)) " > "$dir/dune"
dune build "$dir"
cd "$dir"


