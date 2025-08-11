[![Odin](https://github.com/floooh/sokol-odin/actions/workflows/main.yml/badge.svg)](https://github.com/floooh/sokol-odin/actions/workflows/main.yml)

Auto-generated [Odin](https://github.com/odin-lang/odin) bindings for the [sokol headers](https://github.com/floooh/sokol).

To include sokol in your project you can copy the [sokol](sokol/) directory.

## BUILD

Supported platforms are: Windows, macOS, Linux (with X11)

On Linux install the following packages: libglu1-mesa-dev, mesa-common-dev, xorg-dev, libasound-dev
(or generally: the dev packages required for X11, GL and ALSA development)

1. First build the required static link libraries:

    ```
    cd sokol
    # on macOS:
    ./build_clibs_macos.sh
    # on Linux:
    ./build_clibs_linux.sh
    # on Windows with MSVC (from a 'Visual Studio Developer Command Prompt')
    build_clibs_windows.cmd
    cd ..
    ```

2. Create a build directory and cd into it:
    ```
    mkdir build
    cd build
    ```

3. Build and run the samples:
    ```
    odin run ../examples/clear -strict-style -debug
    odin run ../examples/triangle -strict-style -debug
    odin run ../examples/quad -strict-style -debug
    odin run ../examples/bufferoffsets -strict-style -debug
    odin run ../examples/cube -strict-style -debug
    odin run ../examples/noninterleaved -strict-style -debug
    odin run ../examples/texcube -strict-style -debug
    odin run ../examples/shapes -strict-style -debug
    odin run ../examples/offscreen -strict-style -debug
    odin run ../examples/instancing -strict-style -debug
    odin run ../examples/mrt -strict-style -debug
    odin run ../examples/blend -strict-style -debug
    odin run ../examples/debugtext -strict-style -debug
    odin run ../examples/debugtext-print -strict-style -debug
    odin run ../examples/debugtext-userfont -strict-style -debug
    odin run ../examples/saudio -strict-style -debug
    odin run ../examples/sgl -strict-style -debug
    odin run ../examples/sgl-points -strict-style -debug
    odin run ../examples/sgl-context -strict-style -debug
    odin run ../examples/vertexpull -strict-style -debug
    ```

    By default, the backend 3D API will be selected based on the target platform:

    - macOS: Metal
    - Windows: D3D11
    - Linux: GL

    To force the GL backend on macOS or Windows, build with ```-define:SOKOL_USE_GL=true```:

    ```
    odin run ../examples/clear -debug -define:SOKOL_USE_GL=true
    ```

    The ```clear``` sample prints the selected backend to the terminal:

    ```
    odin run ../examples/clear -debug -define:SOKOL_USE_GL=true
    >> using GL backend
    ```

    On Windows, you can get rid of the automatically opened terminal window
    by building with the ```-subsystem:windows``` option:

    ```
    odin build ../examples/clear -subsystem:windows
    ```
