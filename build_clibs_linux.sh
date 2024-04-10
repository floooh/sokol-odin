set -e

echo === GL Debug ===
cc -pthread -c -g -DIMPL -DSOKOL_GLCORE33 c/sokol.c
ar rcs sokol/sokol_linux_x64_gl_debug.a sokol.o

echo === GL Release ===
cc -pthread -c -O2 -DNDEBUG -DIMPL -DSOKOL_GLCORE33 c/sokol.c
ar rcs sokol/sokol_linux_x64_gl_release.a sokol.o

rm *.o
