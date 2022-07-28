# sokol-odin

[WIP] Auto-generated Odin bindings for the [sokol headers](https://github.com/floooh/sokol).

## BUILD

Supported platforms are: Windows, macOS, Linux (with X11)

On Linux install the following packages: libglu1-mesa-dev, mesa-common-dev, xorg-dev, libasound-dev
(or generally: the dev packages required for X11, GL and ALSA development)

1. First build the required static link libraries:

    ```sh
    # on macOS:
    ./build_clibs_macos.sh
    # on Linux:
    ./build_clibs_linux.sh
    # on Windows (from a 'Visual Studio Developer Command Prompt')
    build_clibs_windows.sh
    ```

2. Create a build directory and cd into it:
    ```sh
    mkdir build
    cd build
    ```

3. Build and run the samples:
    ```sh
    odin run ../examples/clear -debug
    odin run ../examples/triangle -debug
    odin run ../examples/quad -debug
    odin run ../examples/bufferoffsets -debug
    odin run ../examples/cube -debug
    odin run ../examples/noninterleaved -debug
    odin run ../examples/texcube -debug
    odin run ../examples/shapes -debug
    odin run ../examples/offscreen -debug
    odin run ../examples/instancing -debug
    odin run ../examples/mrt -debug
    odin run ../examples/blend -debug
    odin run ../examples/debugtext -debug
    odin run ../examples/debugtext-print -debug
    odin run ../examples/debugtext-userfont -debug
    odin run ../examples/saudio -debug
    odin run ../examples/sgl -debug
    odin run ../examples/sgl-points -debug
    odin run ../examples/sgl-context -debug
    ```
