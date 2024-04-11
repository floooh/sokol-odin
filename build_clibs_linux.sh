set -e

build_lib_x64_release() {
    src=$1
    dst=$2
    backend=$3
    echo $dst
    cc -pthread -c -O2 -DNDEBUG -DIMPL -D$backend c/$src.c
    ar rcs $dst.a $src.o
}

build_lib_x64_debug() {
    src=$1
    dst=$2
    backend=$3
    echo $dst
    cc -pthread -c -g -DIMPL -D$backend c/$src.c
    ar rcs $dst.a $src.o
}

# x64 + GL + Release
build_lib_x64_release sokol_log         sokol/log/sokol_log_linux_x64_gl_release SOKOL_GLCORE33
build_lib_x64_release sokol_gfx         sokol/gfx/sokol_gfx_linux_x64_gl_release SOKOL_GLCORE33
build_lib_x64_release sokol_app         sokol/app/sokol_app_linux_x64_gl_release SOKOL_GLCORE33
build_lib_x64_release sokol_glue        sokol/glue/sokol_glue_linux_x64_gl_release SOKOL_GLCORE33
build_lib_x64_release sokol_time        sokol/time/sokol_time_linux_x64_gl_release SOKOL_GLCORE33
build_lib_x64_release sokol_audio       sokol/audio/sokol_audio_linux_x64_gl_release SOKOL_GLCORE33
build_lib_x64_release sokol_debugtext   sokol/debugtext/sokol_debugtext_linux_x64_gl_release SOKOL_GLCORE33
build_lib_x64_release sokol_shape       sokol/shape/sokol_shape_linux_x64_gl_release SOKOL_GLCORE33
build_lib_x64_release sokol_gl          sokol/gl/sokol_gl_linux_x64_gl_release SOKOL_GLCORE33

# x64 + GL + Debug
build_lib_x64_debug sokol_log           sokol/log/sokol_log_linux_x64_gl_debug SOKOL_GLCORE33
build_lib_x64_debug sokol_gfx           sokol/gfx/sokol_gfx_linux_x64_gl_debug SOKOL_GLCORE33
build_lib_x64_debug sokol_app           sokol/app/sokol_app_linux_x64_gl_debug SOKOL_GLCORE33
build_lib_x64_debug sokol_glue          sokol/glue/sokol_glue_linux_x64_gl_debug SOKOL_GLCORE33
build_lib_x64_debug sokol_time          sokol/time/sokol_time_linux_x64_gl_debug SOKOL_GLCORE33
build_lib_x64_debug sokol_audio         sokol/audio/sokol_audio_linux_x64_gl_debug SOKOL_GLCORE33
build_lib_x64_debug sokol_debugtext     sokol/debugtext/sokol_debugtext_linux_x64_gl_debug SOKOL_GLCORE33
build_lib_x64_debug sokol_shape         sokol/shape/sokol_shape_linux_x64_gl_debug SOKOL_GLCORE33
build_lib_x64_debug sokol_gl            sokol/gl/sokol_gl_linux_x64_gl_debug SOKOL_GLCORE33

rm *.o
