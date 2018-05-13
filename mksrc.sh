#!/bin/sh

echo "Checking out ocaml-container..."
git submodule update --init
cd ocaml-containers
git checkout 2.2
echo "Making..."
make clean
make build
echo "Copying sources..."
rm -rf ../default/src/*
cp _build/default/src/core/*.ml ../src
cp _build/default/src/core/*.mli ../src
cp _build/default/src/monomorphic/*.ml ../src
cp _build/default/src/monomorphic/*.mli ../src
cd ../uchar/src
cp uchar.ml* ../../src
cd ../../src
cp ../result.ml ./
rm *Labels.ml*
rm CCIO.ml* # not needed
for i in *.ml; do sed -i.bak "/# /d" $i; done #Delete cppo lines
sed -i.bak "/IO/d" containers.ml
sed -i.bak "/Labels/d" containers.ml
echo "Copying LICENSE..."
rm *.bak
cp ../ocaml-containers/LICENSE ./
echo "Done."
