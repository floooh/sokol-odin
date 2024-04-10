set -e

echo === Metal Debug arm64 ===
MACOSX_DEPLOYMENT_TARGET=10.13 cc -c -g -x objective-c -arch arm64 -DIMPL -DSOKOL_METAL c/sokol.c
ar rcs sokol/sokol_macos_arm64_metal_debug.a sokol.o

echo === Metal Release arm64 ===
MACOSX_DEPLOYMENT_TARGET=10.13 cc -c -O2 -x objective-c -arch arm64 -DNDEBUG -DIMPL -DSOKOL_METAL c/sokol.c
ar rcs sokol/sokol_macos_arm64_metal_release.a sokol.o

echo === Metal Debug x64 ===
MACOSX_DEPLOYMENT_TARGET=10.13 cc -c -g -x objective-c -arch x86_64 -DIMPL -DSOKOL_METAL c/sokol.c
ar rcs sokol/sokol_macos_x64_metal_debug.a sokol.o

echo === Metal Release x64 ===
MACOSX_DEPLOYMENT_TARGET=10.13 cc -c -O2 -x objective-c -arch x86_64 -DNDEBUG -DIMPL -DSOKOL_METAL c/sokol.c
ar rcs sokol/sokol_macos_x64_metal_release.a sokol.o



echo === GL Debug arm64 ===
MACOSX_DEPLOYMENT_TARGET=10.13 cc -c -g -x objective-c -arch arm64 -DIMPL -DSOKOL_GLCORE33 c/sokol.c
ar rcs sokol/sokol_macos_arm64_gl_debug.a sokol.o

echo === GL Release arm64 ===
MACOSX_DEPLOYMENT_TARGET=10.13 cc -c -O2 -x objective-c -arch arm64 -DNDEBUG -DIMPL -DSOKOL_GLCORE33 c/sokol.c
ar rcs sokol/sokol_macos_arm64_gl_release.a sokol.o

echo === GL Debug x64 ===
MACOSX_DEPLOYMENT_TARGET=10.13 cc -c -g -x objective-c -arch x86_64 -DIMPL -DSOKOL_GLCORE33 c/sokol.c
ar rcs sokol/sokol_macos_x64_gl_debug.a sokol.o

echo === GL Release x64 ===
MACOSX_DEPLOYMENT_TARGET=10.13 cc -c -O2 -x objective-c -arch x86_64 -DNDEBUG -DIMPL -DSOKOL_GLCORE33 c/sokol.c
ar rcs sokol/sokol_macos_x64_gl_release.a sokol.o

rm *.o
