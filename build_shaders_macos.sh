set -e

sokol_tools_root=../sokol-tools-bin

build_shader() {
    name=$1
    dir=examples/$name
    if [[ $(arch) =~ "arm64" ]]
    then
        shdc=$sokol_tools_root/bin/osx_arm64/sokol-shdc
    else
        shdc=$sokol_tools_root/bin/osx/sokol-shdc
    fi
    echo $dir
    $shdc -i $dir/shader.glsl -o $dir/shader.odin -l glsl330:metal_macos:hlsl4 -f sokol_odin
}

build_shader blend
build_shader bufferoffsets
build_shader cube
build_shader instancing
build_shader mrt
build_shader noninterleaved
build_shader offscreen
build_shader quad
build_shader shapes
build_shader texcube
build_shader triangle


