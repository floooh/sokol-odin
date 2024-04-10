@echo off

echo === D3D11 Debug ===
cl /c /D_DEBUG /DIMPL /DSOKOL_D3D11 c\sokol.c /Z7
lib /OUT:sokol\sokol_windows_x64_d3d11_debug.lib sokol.obj

echo === D3D11 Release ===
cl /c /O2 /DNDEBUG /DIMPL /DSOKOL_D3D11 c\sokol.c
lib /OUT:sokol\sokol_windows_x64_d3d11_release.lib sokol.obj

echo === GL Debug ===
cl /c /D_DEBUG /DIMPL /DSOKOL_GLCORE33 c\sokol.c /Z7
lib /OUT:sokol\sokol_windows_x64_gl_debug.lib sokol.obj

echo === GL Release ===
cl /c /O2 /DNDEBUG /DIMPL /DSOKOL_GLCORE33 c\sokol.c
lib /OUT:sokol\sokol_windows_x64_gl_release.lib sokol.obj

del sokol.obj

echo === D3D11 Debug DLL ===
cl /OUT:sokol\sokol_dll_windows_x64_d3d11_debug.dll /D_DEBUG /DIMPL /DSOKOL_D3D11 c\sokol_dll.c /Z7 /LDd /MDd /DLL

echo === D3D11 Release DLL ===
cl /OUT:sokol\sokol_dll_windows_x64_d3d11_release.dll /D_DEBUG /DIMPL /DSOKOL_D3D11 c\sokol_dll.c /LD /MD /DLL

echo === GL Debug DLL ===
cl /OUT:sokol\sokol_dll_windows_x64_gl_debug.dll /D_DEBUG /DIMPL /DSOKOL_GLCORE33 c\sokol_dll.c /Z7 /LDd /MDd /DLL

echo === GL Release DLL ===
cl /OUT:sokol\sokol_dll_windows_x64_gl_release.dll /D_DEBUG /DIMPL /DSOKOL_GLCORE33 c\sokol_dll.c /LD /MD /DLL