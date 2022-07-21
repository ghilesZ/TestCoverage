set -euC

if [ $# -eq 0 ]; then
    echo 'Error: was expecting some OCaml file'
    exit 1
fi
fbname=$(basename "$1" .ml)
dir_testify="$PWD/../../Testify"
dir_coverage="$PWD"
cd "$dir_testify"
rm -rf "$dir_testify/testdir_$fbname"
mkdir -p "$dir_testify/testdir_$fbname"
cd "$dir_coverage"
dune exec src/rewriter.exe -- "$1" > "$dir_testify/testdir_$fbname/a.ml"
echo "(env
  (dev
    (flags (:standard -w -32))))(executable (name a)(libraries testify_runtime)) " > "$dir_testify/testdir_$fbname/dune"
dune build "$dir_testify/testdir_$fbname/a.ml"
cd "$dir_testify"

