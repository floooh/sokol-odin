@echo off

set sources=log app gfx glue time audio debugtext shape gl

REM Debug
for %%s in (%sources%) do (
    echo %%s\sokol_%%s_wasm_gl_debug.a
    call emcc -c -g -DIMPL -DSOKOL_GLES3 c\sokol_%%s.c
    call emar rcs %%s\sokol_%%s_wasm_gl_debug.a sokol_%%s.o
    del sokol_%%s.o
)

REM Release
for %%s in (%sources%) do (
    echo %%s\sokol_%%s_wasm_gl_release.a
    call emcc -c -O2 -DNDEBUG -DIMPL -DSOKOL_GLES3 c\sokol_%%s.c
    call emar rcs %%s\sokol_%%s_wasm_gl_release.a sokol_%%s.o
    del sokol_%%s.o
)
