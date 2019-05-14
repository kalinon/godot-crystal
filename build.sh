
root_dir=$(pwd)

# Update submodules
git submodule update --init --recursive

# Generate bindings
cd ext/godot-cpp
scons platform=osx generate_bindings=yes

cd $(root_dir)
