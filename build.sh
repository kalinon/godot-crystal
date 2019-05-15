#!/usr/bin/env bash

set -ex

root_dir=$(pwd)

cd_root() {
  cd ${root_dir}
}

make_clean() {
  cd ./ext
  make clean
  cd_root
}

# Update submodules
git submodule update --init --recursive

# Check bindgen
if [ ! -e ./lib/bindgen/clang/bindgen ]; then
  cd ./lib/bindgen/clang/
  make
  cd_root
fi

if [ ! -e ./lib/bindgen/bin/bindgen ]; then
  ./lib/bindgen
  shards build
  cd_root
fi

# Generate bindings
if [ ! -e ./ext/godot-cpp/bin/libgodot-cpp.osx.debug.64.a ]; then
  cd ext/godot-cpp
  scons platform=osx generate_bindings=yes use_llvm=yes
  cd_root
fi

make_clean

./lib/bindgen/bin/bindgen ext/godot.yml

cd_root

crystal tool format
