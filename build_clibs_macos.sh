set -e

build_lib_release() {
    src=$1
    dst=$2
    backend=$3
    MACOSX_DEPLOYMENT_TARGET=10.13 clang -c -O2 -x objective-c -DNDEBUG -DIMPL -D$backend c/$src.c
    ar rcs $dst.a $src.o
}

build_lib_debug() {
    src=$1
    dst=$2
    backend=$3
    MACOSX_DEPLOYMENT_TARGET=10.13 clang -c -g -x objective-c -DIMPL -D$backend c/$src.c
    ar rcs $dst.a $src.o
}

build_lib_release sokol_gfx         sokol/gfx/sokol_gfx_macos_arm64_metal_release SOKOL_METAL
build_lib_release sokol_app         sokol/app/sokol_app_macos_arm64_metal_release SOKOL_METAL
build_lib_release sokol_glue        sokol/glue/sokol_glue_macos_arm64_metal_release SOKOL_METAL
build_lib_release sokol_debugtext   sokol/debugtext/sokol_debugtext_macos_arm64_metal_release SOKOL_METAL
build_lib_release sokol_shape       sokol/shape/sokol_shape_macos_arm64_metal_release SOKOL_METAL

build_lib_debug sokol_gfx           sokol/gfx/sokol_gfx_macos_arm64_metal_debug SOKOL_METAL
build_lib_debug sokol_app           sokol/app/sokol_app_macos_arm64_metal_debug SOKOL_METAL
build_lib_debug sokol_glue          sokol/glue/sokol_glue_macos_arm64_metal_debug SOKOL_METAL
build_lib_debug sokol_debugtext     sokol/debugtext/sokol_debugtext_macos_arm64_metal_debug SOKOL_METAL
build_lib_debug sokol_shape         sokol/shape/sokol_shape_macos_arm64_metal_debug SOKOL_METAL

rm *.o
