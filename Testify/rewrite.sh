#!/bin/sh

set -euC

if [ $# -eq 0 ]; then
    echo 'Error: was expecting some OCaml file'
    exit 1
fi
fbname=$(basename "$1" .ml)
dir="$PWD/../Coverage/coverage/testdir_$fbname"
rm -rf "$dir"
mkdir -p "$dir"
dune exec src/rewriter.exe -- "$1" -log > "$dir/$fbname.ml"
[ ! -f log.svg ] || mv log.svg "$dir"/
mv log.markdown "$dir"
echo "(executable (name $fbname)(libraries testify_runtime)) " > "$dir/dune"
dune build "$dir/$fbname.ml"
cd "$dir/.."
./rewrite.sh "$PWD/testdir_$fbname/$fbname.ml"

