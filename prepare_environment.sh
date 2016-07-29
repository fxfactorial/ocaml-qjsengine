#!/bin/bash

mkdir -p path_dir

ln -fs $(which clang) path_dir/gcc

export PATH=$(pwd)/path_dir:${PATH}
