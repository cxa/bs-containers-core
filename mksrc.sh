#!/bin/sh

echo "Checking out ocaml-container..."
git submodule update --init
cd ocaml-containers
git checkout 1.2
echo "Copying sources..."
cp src/core/*.ml ../src
cp src/core/*.mli ../src
cd ../src
rm *Labels.ml* # which bsb can not compile
rm *.cppo.ml*
sed -i '' "/Labels/d" containers.ml
echo "Copying LICENSE..."
cp ../ocaml-containers/LICENSE ./
echo "Done."
