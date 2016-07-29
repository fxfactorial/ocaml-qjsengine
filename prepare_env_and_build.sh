#!/bin/bash

mkdir -p path_dir

ln -fs $(which clang) path_dir/gcc

PATH=$(pwd)/path_dir:${PATH} ocaml setup.ml -build
