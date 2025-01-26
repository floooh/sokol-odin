set -e

declare -a libs=("log" "gfx" "app" "glue" "time" "audio" "debugtext" "shape" "gl")

for l in "${libs[@]}"
do
    echo "${l}/sokol_${l}_wasm_gl_debug.lib"
    emcc -c -g -DIMPL -DSOKOL_GLES3 c/sokol_$l.c
    emar rcs $l/sokol_${l}_wasm_gl_debug.lib sokol_$l.o
    rm sokol_$l.o
done

for l in "${libs[@]}"
do
    echo "${l}/sokol_${l}_wasm_gl_release.lib"
    emcc -c -O2 -DNDEBUG -DIMPL -DSOKOL_GLES3 c/sokol_$l.c
    emar rcs $l/sokol_${l}_wasm_gl_release.lib sokol_$l.o
    rm sokol_$l.o
done
