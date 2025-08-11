#!/usr/bin/env bash
set -e

if [ -z "$1" ]
then
    echo "usage: ./build_shaders.sh [path-to-sokol-shdc]"
    exit 1
fi

shdc="$1"

build_shader() {
    name=$1
    dir=examples/$name
    echo $dir
    $shdc -i $dir/shader.glsl -o $dir/shader.odin -l glsl430:metal_macos:hlsl5 -f sokol_odin
}

build_shader blend
build_shader bufferoffsets
build_shader cube
build_shader instancing
build_shader instancing-compute
build_shader mrt
build_shader noninterleaved
build_shader offscreen
build_shader quad
build_shader shapes
build_shader texcube
build_shader triangle
build_shader vertexpull
