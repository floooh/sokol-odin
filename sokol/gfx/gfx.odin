// machine generated, do not edit

package sokol_gfx

/*

    sokol_gfx.h -- simple 3D API wrapper

    Project URL: https://github.com/floooh/sokol

    Example code: https://github.com/floooh/sokol-samples

    Do this:
        #define SOKOL_IMPL or
        #define SOKOL_GFX_IMPL
    before you include this file in *one* C or C++ file to create the
    implementation.

    In the same place define one of the following to select the rendering
    backend:
        #define SOKOL_GLCORE
        #define SOKOL_GLES3
        #define SOKOL_D3D11
        #define SOKOL_METAL
        #define SOKOL_WGPU
        #define SOKOL_DUMMY_BACKEND

    I.e. for the desktop GL it should look like this:

    #include ...
    #include ...
    #define SOKOL_IMPL
    #define SOKOL_GLCORE
    #include "sokol_gfx.h"

    The dummy backend replaces the platform-specific backend code with empty
    stub functions. This is useful for writing tests that need to run on the
    command line.

    Optionally provide the following defines with your own implementations:

    SOKOL_ASSERT(c)             - your own assert macro (default: assert(c))
    SOKOL_UNREACHABLE()         - a guard macro for unreachable code (default: assert(false))
    SOKOL_GFX_API_DECL          - public function declaration prefix (default: extern)
    SOKOL_API_DECL              - same as SOKOL_GFX_API_DECL
    SOKOL_API_IMPL              - public function implementation prefix (default: -)
    SOKOL_TRACE_HOOKS           - enable trace hook callbacks (search below for TRACE HOOKS)
    SOKOL_EXTERNAL_GL_LOADER    - indicates that you're using your own GL loader, in this case
                                  sokol_gfx.h will not include any platform GL headers and disable
                                  the integrated Win32 GL loader

    If sokol_gfx.h is compiled as a DLL, define the following before
    including the declaration or implementation:

    SOKOL_DLL

    On Windows, SOKOL_DLL will define SOKOL_GFX_API_DECL as __declspec(dllexport)
    or __declspec(dllimport) as needed.

    If you want to compile without deprecated structs and functions,
    define:

    SOKOL_NO_DEPRECATED

    Optionally define the following to force debug checks and validations
    even in release mode:

    SOKOL_DEBUG - by default this is defined if _DEBUG is defined

    sokol_gfx DOES NOT:
    ===================
    - create a window, swapchain or the 3D-API context/device, you must do this
      before sokol_gfx is initialized, and pass any required information
      (like 3D device pointers) to the sokol_gfx initialization call

    - present the rendered frame, how this is done exactly usually depends
      on how the window and 3D-API context/device was created

    - provide a unified shader language, instead 3D-API-specific shader
      source-code or shader-bytecode must be provided (for the "official"
      offline shader cross-compiler / code-generator, see here:
      https://github.com/floooh/sokol-tools/blob/master/docs/sokol-shdc.md)


    STEP BY STEP
    ============
    --- to initialize sokol_gfx, after creating a window and a 3D-API
        context/device, call:

            sg_setup(const sg_desc*)

        Depending on the selected 3D backend, sokol-gfx requires some
        information, like a device pointer, default swapchain pixel formats
        and so on. If you are using sokol_app.h for the window system
        glue, you can use a helper function provided in the sokol_glue.h
        header:

            #include "sokol_gfx.h"
            #include "sokol_app.h"
            #include "sokol_glue.h"
            //...
            sg_setup(&(sg_desc){
                .environment = sglue_environment(),
            });

        To get any logging output for errors and from the validation layer, you
        need to provide a logging callback. Easiest way is through sokol_log.h:

            #include "sokol_log.h"
            //...
            sg_setup(&(sg_desc){
                //...
                .logger.func = slog_func,
            });

    --- create resource objects (at least buffers, shaders and pipelines,
        and optionally images, samplers and render-pass-attachments):

            sg_buffer sg_make_buffer(const sg_buffer_desc*)
            sg_image sg_make_image(const sg_image_desc*)
            sg_sampler sg_make_sampler(const sg_sampler_desc*)
            sg_shader sg_make_shader(const sg_shader_desc*)
            sg_pipeline sg_make_pipeline(const sg_pipeline_desc*)
            sg_attachments sg_make_attachments(const sg_attachments_desc*)

    --- start a render pass:

            sg_begin_pass(const sg_pass* pass);

        Typically, passes render into an externally provided swapchain which
        presents the rendering result on the display. Such a 'swapchain pass'
        is started like this:

            sg_begin_pass(&(sg_pass){ .action = { ... }, .swapchain = sglue_swapchain() })

        ...where .action is an sg_pass_action struct containing actions to be performed
        at the start and end of a render pass (such as clearing the render surfaces to
        a specific color), and .swapchain is an sg_swapchain
        struct all the required information to render into the swapchain's surfaces.

        To start an 'offscreen pass' into sokol-gfx image objects, an sg_attachment
        object handle is required instead of an sg_swapchain struct. An offscreen
        pass is started like this (assuming attachments is an sg_attachments handle):

            sg_begin_pass(&(sg_pass){ .action = { ... }, .attachments = attachments });

    --- set the render pipeline state for the next draw call with:

            sg_apply_pipeline(sg_pipeline pip)

    --- fill an sg_bindings struct with the resource bindings for the next
        draw call (0..N vertex buffers, 0 or 1 index buffer, 0..N images,
        samplers and storage-buffers), and call:

            sg_apply_bindings(const sg_bindings* bindings)

        to update the resource bindings

    --- optionally update shader uniform data with:

            sg_apply_uniforms(int ub_slot, const sg_range* data)

        Read the section 'UNIFORM DATA LAYOUT' to learn about the expected memory layout
        of the uniform data passed into sg_apply_uniforms().

    --- kick off a draw call with:

            sg_draw(int base_element, int num_elements, int num_instances)

        The sg_draw() function unifies all the different ways to render primitives
        in a single call (indexed vs non-indexed rendering, and instanced vs non-instanced
        rendering). In case of indexed rendering, base_element and num_element specify
        indices in the currently bound index buffer. In case of non-indexed rendering
        base_element and num_elements specify vertices in the currently bound
        vertex-buffer(s). To perform instanced rendering, the rendering pipeline
        must be setup for instancing (see sg_pipeline_desc below), a separate vertex buffer
        containing per-instance data must be bound, and the num_instances parameter
        must be > 1.

    --- finish the current rendering pass with:

            sg_end_pass()

    --- when done with the current frame, call

            sg_commit()

    --- at the end of your program, shutdown sokol_gfx with:

            sg_shutdown()

    --- if you need to destroy resources before sg_shutdown(), call:

            sg_destroy_buffer(sg_buffer buf)
            sg_destroy_image(sg_image img)
            sg_destroy_sampler(sg_sampler smp)
            sg_destroy_shader(sg_shader shd)
            sg_destroy_pipeline(sg_pipeline pip)
            sg_destroy_attachments(sg_attachments atts)

    --- to set a new viewport rectangle, call

            sg_apply_viewport(int x, int y, int width, int height, bool origin_top_left)

        ...or if you want to specify the viewport rectangle with float values:

            sg_apply_viewportf(float x, float y, float width, float height, bool origin_top_left)

    --- to set a new scissor rect, call:

            sg_apply_scissor_rect(int x, int y, int width, int height, bool origin_top_left)

        ...or with float values:

            sg_apply_scissor_rectf(float x, float y, float width, float height, bool origin_top_left)

        Both sg_apply_viewport() and sg_apply_scissor_rect() must be called
        inside a rendering pass

        Note that sg_begin_default_pass() and sg_begin_pass() will reset both the
        viewport and scissor rectangles to cover the entire framebuffer.

    --- to update (overwrite) the content of buffer and image resources, call:

            sg_update_buffer(sg_buffer buf, const sg_range* data)
            sg_update_image(sg_image img, const sg_image_data* data)

        Buffers and images to be updated must have been created with
        SG_USAGE_DYNAMIC or SG_USAGE_STREAM

        Only one update per frame is allowed for buffer and image resources when
        using the sg_update_*() functions. The rationale is to have a simple
        countermeasure to avoid the CPU scribbling over data the GPU is currently
        using, or the CPU having to wait for the GPU

        Buffer and image updates can be partial, as long as a rendering
        operation only references the valid (updated) data in the
        buffer or image.

    --- to append a chunk of data to a buffer resource, call:

            int sg_append_buffer(sg_buffer buf, const sg_range* data)

        The difference to sg_update_buffer() is that sg_append_buffer()
        can be called multiple times per frame to append new data to the
        buffer piece by piece, optionally interleaved with draw calls referencing
        the previously written data.

        sg_append_buffer() returns a byte offset to the start of the
        written data, this offset can be assigned to
        sg_bindings.vertex_buffer_offsets[n] or
        sg_bindings.index_buffer_offset

        Code example:

        for (...) {
            const void* data = ...;
            const int num_bytes = ...;
            int offset = sg_append_buffer(buf, &(sg_range) { .ptr=data, .size=num_bytes });
            bindings.vertex_buffer_offsets[0] = offset;
            sg_apply_pipeline(pip);
            sg_apply_bindings(&bindings);
            sg_apply_uniforms(...);
            sg_draw(...);
        }

        A buffer to be used with sg_append_buffer() must have been created
        with SG_USAGE_DYNAMIC or SG_USAGE_STREAM.

        If the application appends more data to the buffer then fits into
        the buffer, the buffer will go into the "overflow" state for the
        rest of the frame.

        Any draw calls attempting to render an overflown buffer will be
        silently dropped (in debug mode this will also result in a
        validation error).

        You can also check manually if a buffer is in overflow-state by calling

            bool sg_query_buffer_overflow(sg_buffer buf)

        You can manually check to see if an overflow would occur before adding
        any data to a buffer by calling

            bool sg_query_buffer_will_overflow(sg_buffer buf, size_t size)

        NOTE: Due to restrictions in underlying 3D-APIs, appended chunks of
        data will be 4-byte aligned in the destination buffer. This means
        that there will be gaps in index buffers containing 16-bit indices
        when the number of indices in a call to sg_append_buffer() is
        odd. This isn't a problem when each call to sg_append_buffer()
        is associated with one draw call, but will be problematic when
        a single indexed draw call spans several appended chunks of indices.

    --- to check at runtime for optional features, limits and pixelformat support,
        call:

            sg_features sg_query_features()
            sg_limits sg_query_limits()
            sg_pixelformat_info sg_query_pixelformat(sg_pixel_format fmt)

    --- if you need to call into the underlying 3D-API directly, you must call:

            sg_reset_state_cache()

        ...before calling sokol_gfx functions again

    --- you can inspect the original sg_desc structure handed to sg_setup()
        by calling sg_query_desc(). This will return an sg_desc struct with
        the default values patched in instead of any zero-initialized values

    --- you can get a desc struct matching the creation attributes of a
        specific resource object via:

            sg_buffer_desc sg_query_buffer_desc(sg_buffer buf)
            sg_image_desc sg_query_image_desc(sg_image img)
            sg_sampler_desc sg_query_sampler_desc(sg_sampler smp)
            sg_shader_desc sq_query_shader_desc(sg_shader shd)
            sg_pipeline_desc sg_query_pipeline_desc(sg_pipeline pip)
            sg_attachments_desc sg_query_attachments_desc(sg_attachments atts)

        ...but NOTE that the returned desc structs may be incomplete, only
        creation attributes that are kept around internally after resource
        creation will be filled in, and in some cases (like shaders) that's
        very little. Any missing attributes will be set to zero. The returned
        desc structs might still be useful as partial blueprint for creating
        similar resources if filled up with the missing attributes.

        Calling the query-desc functions on an invalid resource will return
        completely zeroed structs (it makes sense to check  the resource state
        with sg_query_*_state() first)

    --- you can query the default resource creation parameters through the functions

            sg_buffer_desc sg_query_buffer_defaults(const sg_buffer_desc* desc)
            sg_image_desc sg_query_image_defaults(const sg_image_desc* desc)
            sg_sampler_desc sg_query_sampler_defaults(const sg_sampler_desc* desc)
            sg_shader_desc sg_query_shader_defaults(const sg_shader_desc* desc)
            sg_pipeline_desc sg_query_pipeline_defaults(const sg_pipeline_desc* desc)
            sg_attachments_desc sg_query_attachments_defaults(const sg_attachments_desc* desc)

        These functions take a pointer to a desc structure which may contain
        zero-initialized items for default values. These zero-init values
        will be replaced with their concrete values in the returned desc
        struct.

    --- you can inspect various internal resource runtime values via:

            sg_buffer_info sg_query_buffer_info(sg_buffer buf)
            sg_image_info sg_query_image_info(sg_image img)
            sg_sampler_info sg_query_sampler_info(sg_sampler smp)
            sg_shader_info sg_query_shader_info(sg_shader shd)
            sg_pipeline_info sg_query_pipeline_info(sg_pipeline pip)
            sg_attachments_info sg_query_attachments_info(sg_attachments atts)

        ...please note that the returned info-structs are tied quite closely
        to sokol_gfx.h internals, and may change more often than other
        public API functions and structs.

    --- you can query frame stats and control stats collection via:

            sg_query_frame_stats()
            sg_enable_frame_stats()
            sg_disable_frame_stats()
            sg_frame_stats_enabled()

    --- you can ask at runtime what backend sokol_gfx.h has been compiled for:

            sg_backend sg_query_backend(void)

    --- call the following helper functions to compute the number of
        bytes in a texture row or surface for a specific pixel format.
        These functions might be helpful when preparing image data for consumption
        by sg_make_image() or sg_update_image():

            int sg_query_row_pitch(sg_pixel_format fmt, int width, int int row_align_bytes);
            int sg_query_surface_pitch(sg_pixel_format fmt, int width, int height, int row_align_bytes);

        Width and height are generally in number pixels, but note that 'row' has different meaning
        for uncompressed vs compressed pixel formats: for uncompressed formats, a row is identical
        with a single line if pixels, while in compressed formats, one row is a line of *compression blocks*.

        This is why calling sg_query_surface_pitch() for a compressed pixel format and height
        N, N+1, N+2, ... may return the same result.

        The row_align_bytes parammeter is for added flexibility. For image data that goes into
        the sg_make_image() or sg_update_image() this should generally be 1, because these
        functions take tightly packed image data as input no matter what alignment restrictions
        exist in the backend 3D APIs.

    ON INITIALIZATION:
    ==================
    When calling sg_setup(), a pointer to an sg_desc struct must be provided
    which contains initialization options. These options provide two types
    of information to sokol-gfx:

        (1) upper bounds and limits needed to allocate various internal
            data structures:
                - the max number of resources of each type that can
                  be alive at the same time, this is used for allocating
                  internal pools
                - the max overall size of uniform data that can be
                  updated per frame, including a worst-case alignment
                  per uniform update (this worst-case alignment is 256 bytes)
                - the max size of all dynamic resource updates (sg_update_buffer,
                  sg_append_buffer and sg_update_image) per frame
            Not all of those limit values are used by all backends, but it is
            good practice to provide them none-the-less.

        (2) 3D backend "environment information" in a nested sg_environment struct:
            - pointers to backend-specific context- or device-objects (for instance
              the D3D11, WebGPU or Metal device objects)
            - defaults for external swapchain pixel formats and sample counts,
              these will be used as default values in image and pipeline objects,
              and the sg_swapchain struct passed into sg_begin_pass()
            Usually you provide a complete sg_environment struct through
            a helper function, as an example look at the sglue_environment()
            function in the sokol_glue.h header.

    See the documentation block of the sg_desc struct below for more information.


    ON RENDER PASSES
    ================
    Relevant samples:
        - https://floooh.github.io/sokol-html5/offscreen-sapp.html
        - https://floooh.github.io/sokol-html5/offscreen-msaa-sapp.html
        - https://floooh.github.io/sokol-html5/mrt-sapp.html
        - https://floooh.github.io/sokol-html5/mrt-pixelformats-sapp.html

    A render pass groups rendering commands into a set of render target images
    (called 'pass attachments'). Render target images can be used in subsequent
    passes as textures (it is invalid to use the same image both as render target
    and as texture in the same pass).

    The following sokol-gfx functions must only be called inside a render pass:

        sg_apply_viewport(f)
        sg_apply_scissor_rect(f)
        sg_apply_pipeline
        sg_apply_bindings
        sg_apply_uniforms
        sg_draw

    A frame must have at least one 'swapchain render pass' which renders into an
    externally provided swapchain provided as an sg_swapchain struct to the
    sg_begin_pass() function. If you use sokol_gfx.h together with sokol_app.h,
    just call the sglue_swapchain() helper function in sokol_glue.h to
    provide the swapchain information. Otherwise the following information
    must be provided:

        - the color pixel-format of the swapchain's render surface
        - an optional depth/stencil pixel format if the swapchain
          has a depth/stencil buffer
        - an optional sample-count for MSAA rendering
        - NOTE: the above three values can be zero-initialized, in that
          case the defaults from the sg_environment struct will be used that
          had been passed to the sg_setup() function.
        - a number of backend specific objects:
            - GL/GLES3: just a GL framebuffer handle
            - D3D11:
                - an ID3D11RenderTargetView for the rendering surface
                - if MSAA is used, an ID3D11RenderTargetView as
                  MSAA resolve-target
                - an optional ID3D11DepthStencilView for the
                  depth/stencil buffer
            - WebGPU
                - a WGPUTextureView object for the rendering surface
                - if MSAA is used, a WGPUTextureView object as MSAA resolve target
                - an optional WGPUTextureView for the
            - Metal (NOTE that the roles of provided surfaces is slightly
              different in Metal than in D3D11 or WebGPU, notably, the
              CAMetalDrawable is either rendered to directly, or serves
              as MSAA resolve target):
                - a CAMetalDrawable object which is either rendered
                  into directly, or in case of MSAA rendering, serves
                  as MSAA-resolve-target
                - if MSAA is used, an multisampled MTLTexture where
                  rendering goes into
                - an optional MTLTexture for the depth/stencil buffer

    It's recommended that you create a helper function which returns an
    initialized sg_swapchain struct by value. This can then be directly plugged
    into the sg_begin_pass function like this:

        sg_begin_pass(&(sg_pass){ .swapchain = sglue_swapchain() });

    As an example for such a helper function check out the function sglue_swapchain()
    in the sokol_glue.h header.

    For offscreen render passes, the render target images used in a render pass
    are baked into an immutable sg_attachments object.

    For a simple offscreen scenario with one color-, one depth-stencil-render
    target and without multisampling, creating an attachment object looks like this:

    First create two render target images, one with a color pixel format,
    and one with the depth- or depth-stencil pixel format. Both images
    must have the same dimensions:

        const sg_image color_img = sg_make_image(&(sg_image_desc){
            .render_target = true,
            .width = 256,
            .height = 256,
            .pixel_format = SG_PIXELFORMAT_RGBA8,
            .sample_count = 1,
        });
        const sg_image depth_img = sg_make_image(&(sg_image_desc){
            .render_target = true,
            .width = 256,
            .height = 256,
            .pixel_format = SG_PIXELFORMAT_DEPTH,
            .sample_count = 1,
        });

    NOTE: when creating render target images, have in mind that some default values
    are aligned with the default environment attributes in the sg_environment struct
    that was passed into the sg_setup() call:

        - the default value for sg_image_desc.pixel_format is taken from
          sg_environment.defaults.color_format
        - the default value for sg_image_desc.sample_count is taken from
          sg_environment.defaults.sample_count
        - the default value for sg_image_desc.num_mipmaps is always 1

    Next create an attachments object:

        const sg_attachments atts = sg_make_attachments(&(sg_attachments_desc){
            .colors[0].image = color_img,
            .depth_stencil.image = depth_img,
        });

    This attachments object is then passed into the sg_begin_pass() function
    in place of the swapchain struct:

        sg_begin_pass(&(sg_pass){ .attachments = atts });

    Swapchain and offscreen passes form dependency trees each with a swapchain
    pass at the root, offscreen passes as nodes, and render target images as
    dependencies between passes.

    sg_pass_action structs are used to define actions that should happen at the
    start and end of rendering passes (such as clearing pass attachments to a
    specific color or depth-value, or performing an MSAA resolve operation at
    the end of a pass).

    A typical sg_pass_action object which clears the color attachment to black
    might look like this:

        const sg_pass_action = {
            .colors[0] = {
                .load_action = SG_LOADACTION_CLEAR,
                .clear_value = { 0.0f, 0.0f, 0.0f, 1.0f }
            }
        };

    This omits the defaults for the color attachment store action, and
    the depth-stencil-attachments actions. The same pass action with the
    defaults explicitly filled in would look like this:

        const sg_pass_action pass_action = {
            .colors[0] = {
                .load_action = SG_LOADACTION_CLEAR,
                .store_action = SG_STOREACTION_STORE,
                .clear_value = { 0.0f, 0.0f, 0.0f, 1.0f }
            },
            .depth = = {
                .load_action = SG_LOADACTION_CLEAR,
                .store_action = SG_STOREACTION_DONTCARE,
                .clear_value = 1.0f,
            },
            .stencil = {
                .load_action = SG_LOADACTION_CLEAR,
                .store_action = SG_STOREACTION_DONTCARE,
                .clear_value = 0
            }
        };

    With the sg_pass object and sg_pass_action struct in place everything
    is ready now for the actual render pass:

    Using such this prepared sg_pass_action in a swapchain pass looks like
    this:

        sg_begin_pass(&(sg_pass){
            .action = pass_action,
            .swapchain = sglue_swapchain()
        });
        ...
        sg_end_pass();

    ...of alternatively in one offscreen pass:

        sg_begin_pass(&(sg_pass){
            .action = pass_action,
            .attachments = attachments,
        });
        ...
        sg_end_pass();

    Offscreen rendering can also go into a mipmap, or a slice/face of
    a cube-, array- or 3d-image (which some restrictions, for instance
    it's not possible to create a 3D image with a depth/stencil pixel format,
    these exceptions are generally caught by the sokol-gfx validation layer).

    The mipmap/slice selection happens at attachments creation time, for instance
    to render into mipmap 2 of slice 3 of an array texture:

        const sg_attachments atts = sg_make_attachments(&(sg_attachments_desc){
            .colors[0] = {
                .image = color_img,
                .mip_level = 2,
                .slice = 3,
            },
            .depth_stencil.image = depth_img,
        });

    If MSAA offscreen rendering is desired, the multi-sample rendering result
    must be 'resolved' into a separate 'resolve image', before that image can
    be used as texture.

    NOTE: currently multisample-images cannot be bound as textures.

    Creating a simple attachments object for multisampled rendering requires
    3 attachment images: the color attachment image which has a sample
    count > 1, a resolve attachment image of the same size and pixel format
    but a sample count == 1, and a depth/stencil attachment image with
    the same size and sample count as the color attachment image:

        const sg_image color_img = sg_make_image(&(sg_image_desc){
            .render_target = true,
            .width = 256,
            .height = 256,
            .pixel_format = SG_PIXELFORMAT_RGBA8,
            .sample_count = 4,
        });
        const sg_image resolve_img = sg_make_image(&(sg_image_desc){
            .render_target = true,
            .width = 256,
            .height = 256,
            .pixel_format = SG_PIXELFORMAT_RGBA8,
            .sample_count = 1,
        });
        const sg_image depth_img = sg_make_image(&(sg_image_desc){
            .render_target = true,
            .width = 256,
            .height = 256,
            .pixel_format = SG_PIXELFORMAT_DEPTH,
            .sample_count = 4,
        });

    ...create the attachments object:

        const sg_attachments atts = sg_make_attachments(&(sg_attachments_desc){
            .colors[0].image = color_img,
            .resolves[0].image = resolve_img,
            .depth_stencil.image = depth_img,
        });

    If an attachments object defines a resolve image in a specific resolve attachment slot,
    an 'msaa resolve operation' will happen in sg_end_pass().

    In this scenario, the content of the MSAA color attachment doesn't need to be
    preserved (since it's only needed inside sg_end_pass for the msaa-resolve), so
    the .store_action should be set to "don't care":

        const sg_pass_action = {
            .colors[0] = {
                .load_action = SG_LOADACTION_CLEAR,
                .store_action = SG_STOREACTION_DONTCARE,
                .clear_value = { 0.0f, 0.0f, 0.0f, 1.0f }
            }
        };

    The actual render pass looks as usual:

        sg_begin_pass(&(sg_pass){ .action = pass_action, .attachments = atts });
        ...
        sg_end_pass();

    ...after sg_end_pass() the only difference to the non-msaa scenario is that the
    rendering result which is going to be used as texture in a followup pass is
    in 'resolve_img', not in 'color_img' (in fact, trying to bind color_img as a
    texture would result in a validation error).


    ON SHADER CREATION
    ==================
    sokol-gfx doesn't come with an integrated shader cross-compiler, instead
    backend-specific shader sources or binary blobs need to be provided when
    creating a shader object, along with information about the shader resource
    binding interface needed to bind sokol-gfx resources to the proper
    shader inputs.

    The easiest way to provide all this shader creation data is to use the
    sokol-shdc shader compiler tool to compile shaders from a common
    GLSL syntax into backend-specific sources or binary blobs, along with
    shader interface information and uniform blocks mapped to C structs.

    To create a shader using a C header which has been code-generated by sokol-shdc:

        // include the C header code-generated by sokol-shdc:
        #include "myshader.glsl.h"
        ...

        // create shader using a code-generated helper function from the C header:
        sg_shader shd = sg_make_shader(myshader_shader_desc(sg_query_backend()));

    The samples in the 'sapp' subdirectory of the sokol-samples project
    also use the sokol-shdc approach:

        https://github.com/floooh/sokol-samples/tree/master/sapp

    If you're planning to use sokol-shdc, you can stop reading here, instead
    continue with the sokol-shdc documentation:

        https://github.com/floooh/sokol-tools/blob/master/docs/sokol-shdc.md

    To create shaders with backend-specific shader code or binary blobs,
    the sg_make_shader() function requires the following information:

    - Shader code or shader binary blobs for the vertex- and fragment- shader-stage:
        - for the desktop GL backend, source code can be provided in '#version 410' or
          '#version 430', version 430 is required for storage buffer support, but note
          that this is not available on macOS
        - for the GLES3 backend, source code must be provided in '#version 300 es' syntax
        - for the D3D11 backend, shaders can be provided as source or binary blobs, the
          source code should be in HLSL4.0 (for best compatibility) or alternatively
          in HLSL5.0 syntax (other versions may work but are not tested), NOTE: when
          shader source code is provided for the D3D11 backend, sokol-gfx will dynamically
          load 'd3dcompiler_47.dll'
        - for the Metal backends, shaders can be provided as source or binary blobs, the
          MSL version should be in 'metal-1.1' (other versions may work but are not tested)
        - for the WebGPU backend, shaders must be provided as WGSL source code
        - optionally the following shader-code related attributes can be provided:
            - an entry function name (only on D3D11 or Metal, but not OpenGL)
            - on D3D11 only, a compilation target (default is "vs_4_0" and "ps_4_0")

    - Depending on backend, information about the input vertex attributes used by the
      vertex shader:
        - Metal: no information needed since vertex attributes are always bound
          by their attribute location defined in the shader via '[[attribute(N)]]'
        - WebGPU: no information needed since vertex attributes are always
          bound by their attribute location defined in the shader via `@location(N)`
        - GLSL: vertex attribute names can be optionally provided, in that case their
          location will be looked up by name, otherwise, the vertex attribute location
          can be defined with 'layout(location = N)'
        - D3D11: a 'semantic name' and 'semantic index' must be provided for each vertex
          attribute, e.g. if the vertex attribute is defined as 'TEXCOORD1' in the shader,
          the semantic name would be 'TEXCOORD', and the semantic index would be '1'

      NOTE that vertex attributes currently must not have gaps. This requirement
      may be relaxed in the future.

    - Information about each uniform block used in the shader:
        - the shader stage of the uniform block (vertex or fragment)
        - the size of the uniform block in number of bytes
        - a memory layout hint (currently 'native' or 'std140') where 'native' defines a
          backend-specific memory layout which shouldn't be used for cross-platform code.
          Only std140 guarantees a backend-agnostic memory layout.
        - a backend-specific bind slot:
            - D3D11/HLSL: the buffer register N (`register(bN)`) where N is 0..7
            - Metal/MSL: the buffer bind slot N (`[[buffer(N)]]`) where N is 0..7
            - WebGPU: the binding N in `@group(0) @binding(N)` where N is 0..15
        - For GLSL only: a description of the internal uniform block layout, which maps
          member types and their offsets on the CPU side to uniform variable names
          in the GLSL shader
        - please also NOTE the documentation sections about UNIFORM DATA LAYOUT
          and CROSS-BACKEND COMMON UNIFORM DATA LAYOUT below!

    - A description of each storage buffer used in the shader:
        - the shader stage of the storage buffer
        - a boolean 'readonly' flag, note that currently only
          readonly storage buffers are supported
        - a backend-specific bind slot:
            - D3D11/HLSL: the texture register N (`register(tN)`) where N is 0..23
              (in HLSL, storage buffers and texture share the same bind space)
            - Metal/MSL: the buffer bind slot N (`[[buffer(N)]]`) where N is 8..15
            - WebGPU/WGSL: the binding N in `@group(0) @binding(N)` where N is 0..127
            - GL/GLSL: the buffer binding N in `layout(binding=N)` where N is 0..7
        - note that storage buffers are not supported on all backends
          and platforms

    - A description of each texture/image used in the shader:
        - the shader stage of the texture (vertex or fragment)
        - the expected image type:
            - SG_IMAGETYPE_2D
            - SG_IMAGETYPE_CUBE
            - SG_IMAGETYPE_3D
            - SG_IMAGETYPE_ARRAY
        - the expected 'image sample type':
            - SG_IMAGESAMPLETYPE_FLOAT
            - SG_IMAGESAMPLETYPE_DEPTH
            - SG_IMAGESAMPLETYPE_SINT
            - SG_IMAGESAMPLETYPE_UINT
            - SG_IMAGESAMPLETYPE_UNFILTERABLE_FLOAT
        - a flag whether the texture is expected to be multisampled
          (currently it's not supported to fetch data from multisampled
          textures in shaders, but this is planned for a later time)
        - a backend-specific bind slot:
            - D3D11/HLSL: the texture register N (`register(tN)`) where N is 0..23
              (in HLSL, storage buffers and texture share the same bind space)
            - Metal/MSL: the texture bind slot N (`[[texture(N)]]`) where N is 0..15
            - WebGPU/WGSL: the binding N in `@group(0) @binding(N)` where N is 0..127

    - A description of each sampler used in the shader:
        - the shader stage of the sampler (vertex or fragment)
        - the expected sampler type:
            - SG_SAMPLERTYPE_FILTERING,
            - SG_SAMPLERTYPE_NONFILTERING,
            - SG_SAMPLERTYPE_COMPARISON,
        - a backend-specific bind slot:
            - D3D11/HLSL: the sampler register N (`register(sN)`) where N is 0..15
            - Metal/MSL: the sampler bind slot N (`[[sampler(N)]]`) where N is 0..15
            - WebGPU/WGSL: the binding N in `@group(0) @binding(N)` where N is 0..127

    - An array of 'image-sampler-pairs' used by the shader to sample textures,
      for D3D11, Metal and WebGPU this is used for validation purposes to check
      whether the texture and sampler are compatible with each other (especially
      WebGPU is very picky about combining the correct
      texture-sample-type with the correct sampler-type). For GLSL an
      additional 'combined-image-sampler name' must be provided because 'OpenGL
      style GLSL' cannot handle separate texture and sampler objects, but still
      groups them into a traditional GLSL 'sampler object'.

    Compatibility rules for image-sample-type vs sampler-type are as follows:

        - SG_IMAGESAMPLETYPE_FLOAT => (SG_SAMPLERTYPE_FILTERING or SG_SAMPLERTYPE_NONFILTERING)
        - SG_IMAGESAMPLETYPE_UNFILTERABLE_FLOAT => SG_SAMPLERTYPE_NONFILTERING
        - SG_IMAGESAMPLETYPE_SINT => SG_SAMPLERTYPE_NONFILTERING
        - SG_IMAGESAMPLETYPE_UINT => SG_SAMPLERTYPE_NONFILTERING
        - SG_IMAGESAMPLETYPE_DEPTH => SG_SAMPLERTYPE_COMPARISON

    Backend-specific bindslot ranges (not relevant when using sokol-shdc):

        - D3D11/HLSL:
            - separate bindslot space per shader stage
            - uniform blocks (as cbuffer): `register(b0..b7)`
            - textures and storage buffers: `register(t0..t23)`
            - samplers: `register(s0..s15)`
        - Metal/MSL:
            - separate bindslot space per shader stage
            - uniform blocks: `[[buffer(0..7)]]`
            - storage buffers: `[[buffer(8..15)]]`
            - textures: `[[texture(0..15)]]`
            - samplers: `[[sampler(0..15)]]`
        - WebGPU/WGSL:
            - common bindslot space across shader stages
            - uniform blocks: `@group(0) @binding(0..15)`
            - textures, samplers and storage buffers: `@group(1) @binding(0..127)`
        - GL/GLSL:
            - uniforms and image-samplers are bound by name
            - storage buffers: `layout(std430, binding=0..7)` (common
              bindslot space across shader stages)

    For example code of how to create backend-specific shader objects,
    please refer to the following samples:

        - for D3D11:    https://github.com/floooh/sokol-samples/tree/master/d3d11
        - for Metal:    https://github.com/floooh/sokol-samples/tree/master/metal
        - for OpenGL:   https://github.com/floooh/sokol-samples/tree/master/glfw
        - for GLES3:    https://github.com/floooh/sokol-samples/tree/master/html5
        - for WebGPI:   https://github.com/floooh/sokol-samples/tree/master/wgpu


    ON SG_IMAGESAMPLETYPE_UNFILTERABLE_FLOAT AND SG_SAMPLERTYPE_NONFILTERING
    ========================================================================
    The WebGPU backend introduces the concept of 'unfilterable-float' textures,
    which can only be combined with 'nonfiltering' samplers (this is a restriction
    specific to WebGPU, but since the same sokol-gfx code should work across
    all backend, the sokol-gfx validation layer also enforces this restriction
    - the alternative would be undefined behaviour in some backend APIs on
    some devices).

    The background is that some mobile devices (most notably iOS devices) can
    not perform linear filtering when sampling textures with certain pixel
    formats, most notable the 32F formats:

        - SG_PIXELFORMAT_R32F
        - SG_PIXELFORMAT_RG32F
        - SG_PIXELFORMAT_RGBA32F

    The information of whether a shader is going to be used with such an
    unfilterable-float texture must already be provided in the sg_shader_desc
    struct when creating the shader (see the above section "ON SHADER CREATION").

    If you are using the sokol-shdc shader compiler, the information whether a
    texture/sampler binding expects an 'unfilterable-float/nonfiltering'
    texture/sampler combination cannot be inferred from the shader source
    alone, you'll need to provide this hint via annotation-tags. For instance
    here is an example from the ozz-skin-sapp.c sample shader which samples an
    RGBA32F texture with skinning matrices in the vertex shader:

    ```glsl
    @image_sample_type joint_tex unfilterable_float
    uniform texture2D joint_tex;
    @sampler_type smp nonfiltering
    uniform sampler smp;
    ```

    This will result in SG_IMAGESAMPLETYPE_UNFILTERABLE_FLOAT and
    SG_SAMPLERTYPE_NONFILTERING being written to the code-generated
    sg_shader_desc struct.


    UNIFORM DATA LAYOUT:
    ====================
    NOTE: if you use the sokol-shdc shader compiler tool, you don't need to worry
    about the following details.

    The data that's passed into the sg_apply_uniforms() function must adhere to
    specific layout rules so that the GPU shader finds the uniform block
    items at the right offset.

    For the D3D11 and Metal backends, sokol-gfx only cares about the size of uniform
    blocks, but not about the internal layout. The data will just be copied into
    a uniform/constant buffer in a single operation and it's up you to arrange the
    CPU-side layout so that it matches the GPU side layout. This also means that with
    the D3D11 and Metal backends you are not limited to a 'cross-platform' subset
    of uniform variable types.

    If you ever only use one of the D3D11, Metal *or* WebGPU backend, you can stop reading here.

    For the GL backends, the internal layout of uniform blocks matters though,
    and you are limited to a small number of uniform variable types. This is
    because sokol-gfx must be able to locate the uniform block members in order
    to upload them to the GPU with glUniformXXX() calls.

    To describe the uniform block layout to sokol-gfx, the following information
    must be passed to the sg_make_shader() call in the sg_shader_desc struct:

        - a hint about the used packing rule (either SG_UNIFORMLAYOUT_NATIVE or
          SG_UNIFORMLAYOUT_STD140)
        - a list of the uniform block members types in the correct order they
          appear on the CPU side

    For example if the GLSL shader has the following uniform declarations:

        uniform mat4 mvp;
        uniform vec2 offset0;
        uniform vec2 offset1;
        uniform vec2 offset2;

    ...and on the CPU side, there's a similar C struct:

        typedef struct {
            float mvp[16];
            float offset0[2];
            float offset1[2];
            float offset2[2];
        } params_t;

    ...the uniform block description in the sg_shader_desc must look like this:

        sg_shader_desc desc = {
            .vs.uniform_blocks[0] = {
                .size = sizeof(params_t),
                .layout = SG_UNIFORMLAYOUT_NATIVE,  // this is the default and can be omitted
                .uniforms = {
                    // order must be the same as in 'params_t':
                    [0] = { .name = "mvp", .type = SG_UNIFORMTYPE_MAT4 },
                    [1] = { .name = "offset0", .type = SG_UNIFORMTYPE_VEC2 },
                    [2] = { .name = "offset1", .type = SG_UNIFORMTYPE_VEC2 },
                    [3] = { .name = "offset2", .type = SG_UNIFORMTYPE_VEC2 },
                }
            }
        };

    With this information sokol-gfx can now compute the correct offsets of the data items
    within the uniform block struct.

    The SG_UNIFORMLAYOUT_NATIVE packing rule works fine if only the GL backends are used,
    but for proper D3D11/Metal/GL a subset of the std140 layout must be used which is
    described in the next section:


    CROSS-BACKEND COMMON UNIFORM DATA LAYOUT
    ========================================
    For cross-platform / cross-3D-backend code it is important that the same uniform block
    layout on the CPU side can be used for all sokol-gfx backends. To achieve this,
    a common subset of the std140 layout must be used:

    - The uniform block layout hint in sg_shader_desc must be explicitly set to
      SG_UNIFORMLAYOUT_STD140.
    - Only the following GLSL uniform types can be used (with their associated sokol-gfx enums):
        - float => SG_UNIFORMTYPE_FLOAT
        - vec2  => SG_UNIFORMTYPE_FLOAT2
        - vec3  => SG_UNIFORMTYPE_FLOAT3
        - vec4  => SG_UNIFORMTYPE_FLOAT4
        - int   => SG_UNIFORMTYPE_INT
        - ivec2 => SG_UNIFORMTYPE_INT2
        - ivec3 => SG_UNIFORMTYPE_INT3
        - ivec4 => SG_UNIFORMTYPE_INT4
        - mat4  => SG_UNIFORMTYPE_MAT4
    - Alignment for those types must be as follows (in bytes):
        - float => 4
        - vec2  => 8
        - vec3  => 16
        - vec4  => 16
        - int   => 4
        - ivec2 => 8
        - ivec3 => 16
        - ivec4 => 16
        - mat4  => 16
    - Arrays are only allowed for the following types: vec4, int4, mat4.

    Note that the HLSL cbuffer layout rules are slightly different from the
    std140 layout rules, this means that the cbuffer declarations in HLSL code
    must be tweaked so that the layout is compatible with std140.

    The by far easiest way to tackle the common uniform block layout problem is
    to use the sokol-shdc shader cross-compiler tool!

    ON STORAGE BUFFERS
    ==================
    Storage buffers can be used to pass large amounts of random access structured
    data from the CPU side to the shaders. They are similar to data textures, but are
    more convenient to use both on the CPU and shader side since they can be accessed
    in shaders as as a 1-dimensional array of struct items.

    Storage buffers are *NOT* supported on the following platform/backend combos:

    - macOS+GL (because storage buffers require GL 4.3, while macOS only goes up to GL 4.1)
    - all GLES3 platforms (WebGL2, iOS, Android - with the option that support on
      Android may be added at a later point)

    Currently only 'readonly' storage buffers are supported (meaning it's not possible
    to write to storage buffers from shaders).

    To use storage buffers, the following steps are required:

        - write a shader which uses storage buffers (also see the example links below)
        - create one or more storage buffers via sg_make_buffer() with the
          buffer type SG_BUFFERTYPE_STORAGEBUFFER
        - when creating a shader via sg_make_shader(), populate the sg_shader_desc
          struct with binding info (when using sokol-shdc, this step will be taken care
          of automatically)
            - which storage buffer bind slots on the vertex- and fragment-stage
              are occupied
            - whether the storage buffer on that bind slot is readonly (this is currently required
              to be true)
        - when calling sg_apply_bindings(), apply the matching bind slots with the previously
          created storage buffers
        - ...and that's it.

    For more details, see the following backend-agnostic sokol samples:

    - simple vertex pulling from a storage buffer:
        - C code: https://github.com/floooh/sokol-samples/blob/master/sapp/vertexpull-sapp.c
        - shader: https://github.com/floooh/sokol-samples/blob/master/sapp/vertexpull-sapp.glsl
    - instanced rendering via storage buffers (vertex- and instance-pulling):
        - C code: https://github.com/floooh/sokol-samples/blob/master/sapp/instancing-pull-sapp.c
        - shader: https://github.com/floooh/sokol-samples/blob/master/sapp/instancing-pull-sapp.glsl
    - storage buffers both on the vertex- and fragment-stage:
        - C code: https://github.com/floooh/sokol-samples/blob/master/sapp/sbuftex-sapp.c
        - shader: https://github.com/floooh/sokol-samples/blob/master/sapp/sbuftex-sapp.glsl
    - the Ozz animation sample rewritten to pull all rendering data from storage buffers:
        - C code: https://github.com/floooh/sokol-samples/blob/master/sapp/ozz-storagebuffer-sapp.cc
        - shader: https://github.com/floooh/sokol-samples/blob/master/sapp/ozz-storagebuffer-sapp.glsl

    ...also see the following backend-specific vertex pulling samples (those also don't use sokol-shdc):

    - D3D11: https://github.com/floooh/sokol-samples/blob/master/d3d11/vertexpulling-d3d11.c
    - desktop GL: https://github.com/floooh/sokol-samples/blob/master/glfw/vertexpulling-glfw.c
    - Metal: https://github.com/floooh/sokol-samples/blob/master/metal/vertexpulling-metal.c
    - WebGPU: https://github.com/floooh/sokol-samples/blob/master/wgpu/vertexpulling-wgpu.c

    Storage buffer shader authoring caveats when using sokol-shdc:

        - declare a storage buffer interface block with `layout(binding=N) readonly buffer [name] { ... }`
          (where 'N' is the index in `sg_bindings.storage_buffers[N]`)
        - declare a struct which describes a single array item in the storage buffer interface block
        - only put a single flexible array member into the storage buffer interface block

        E.g. a complete example in 'sokol-shdc GLSL':

        ```glsl
        // declare a struct:
        struct sb_vertex {
            vec3 pos;
            vec4 color;
        }
        // declare a buffer interface block with a single flexible struct array:
        layout(binding=0) readonly buffer vertices {
            sb_vertex vtx[];
        }
        // in the shader function, access the storage buffer like this:
        void main() {
            vec3 pos = vtx[gl_VertexIndex].pos;
            ...
        }
        ```

    Backend-specific storage-buffer caveats (not relevant when using sokol-shdc):

        D3D11:
            - storage buffers are created as 'raw' Byte Address Buffers
              (https://learn.microsoft.com/en-us/windows/win32/direct3d11/overviews-direct3d-11-resources-intro#raw-views-of-buffers)
            - in HLSL, use a ByteAddressBuffer to access the buffer content
              (https://learn.microsoft.com/en-us/windows/win32/direct3dhlsl/sm5-object-byteaddressbuffer)
            - in D3D11, storage buffers and textures share the same bind slots (declared as
              `register(tN)` in HLSL), where N must be in the range 0..23)

        Metal:
            - in Metal there is no internal difference between vertex-, uniform- and
              storage-buffers, all are bound to the same 'buffer bind slots' with the
              following reserved ranges:
                - vertex shader stage:
                    - uniform buffers: slots 0..7
                    - storage buffers: slots 8..15
                    - vertex buffers: slots 15..23
                - fragment shader stage:
                    - uniform buffers: slots 0..7
                    - storage buffers: slots 8..15
            - this means in MSL, storage buffer bindings start at [[buffer(8)]] both in
              the vertex and fragment stage

        GL:
            - the GL backend doesn't use name-lookup to find storage buffer bindings, this
              means you must annotate buffers with `layout(std430, binding=N)` in GLSL
            - ...where N is 0..7 in the vertex shader, and 8..15 in the fragment shader

        WebGPU:
            - in WGSL, textures, samplers and storage buffers all use a shared
              bindspace across all shader stages on bindgroup 1:

              `@group(1) @binding(0..127)

    TRACE HOOKS:
    ============
    sokol_gfx.h optionally allows to install "trace hook" callbacks for
    each public API functions. When a public API function is called, and
    a trace hook callback has been installed for this function, the
    callback will be invoked with the parameters and result of the function.
    This is useful for things like debugging- and profiling-tools, or
    keeping track of resource creation and destruction.

    To use the trace hook feature:

    --- Define SOKOL_TRACE_HOOKS before including the implementation.

    --- Setup an sg_trace_hooks structure with your callback function
        pointers (keep all function pointers you're not interested
        in zero-initialized), optionally set the user_data member
        in the sg_trace_hooks struct.

    --- Install the trace hooks by calling sg_install_trace_hooks(),
        the return value of this function is another sg_trace_hooks
        struct which contains the previously set of trace hooks.
        You should keep this struct around, and call those previous
        functions pointers from your own trace callbacks for proper
        chaining.

    As an example of how trace hooks are used, have a look at the
    imgui/sokol_gfx_imgui.h header which implements a realtime
    debugging UI for sokol_gfx.h on top of Dear ImGui.


    A NOTE ON PORTABLE PACKED VERTEX FORMATS:
    =========================================
    There are two things to consider when using packed
    vertex formats like UBYTE4, SHORT2, etc which need to work
    across all backends:

    - D3D11 can only convert *normalized* vertex formats to
      floating point during vertex fetch, normalized formats
      have a trailing 'N', and are "normalized" to a range
      -1.0..+1.0 (for the signed formats) or 0.0..1.0 (for the
      unsigned formats):

        - SG_VERTEXFORMAT_BYTE4N
        - SG_VERTEXFORMAT_UBYTE4N
        - SG_VERTEXFORMAT_SHORT2N
        - SG_VERTEXFORMAT_USHORT2N
        - SG_VERTEXFORMAT_SHORT4N
        - SG_VERTEXFORMAT_USHORT4N

      D3D11 will not convert *non-normalized* vertex formats to floating point
      vertex shader inputs, those can only be uses with the *ivecn* vertex shader
      input types when D3D11 is used as backend (GL and Metal can use both formats)

        - SG_VERTEXFORMAT_BYTE4,
        - SG_VERTEXFORMAT_UBYTE4
        - SG_VERTEXFORMAT_SHORT2
        - SG_VERTEXFORMAT_SHORT4

    For a vertex input layout which works on all platforms, only use the following
    vertex formats, and if needed "expand" the normalized vertex shader
    inputs in the vertex shader by multiplying with 127.0, 255.0, 32767.0 or
    65535.0:

        - SG_VERTEXFORMAT_FLOAT,
        - SG_VERTEXFORMAT_FLOAT2,
        - SG_VERTEXFORMAT_FLOAT3,
        - SG_VERTEXFORMAT_FLOAT4,
        - SG_VERTEXFORMAT_BYTE4N,
        - SG_VERTEXFORMAT_UBYTE4N,
        - SG_VERTEXFORMAT_SHORT2N,
        - SG_VERTEXFORMAT_USHORT2N
        - SG_VERTEXFORMAT_SHORT4N,
        - SG_VERTEXFORMAT_USHORT4N
        - SG_VERTEXFORMAT_UINT10_N2
        - SG_VERTEXFORMAT_HALF2
        - SG_VERTEXFORMAT_HALF4


    MEMORY ALLOCATION OVERRIDE
    ==========================
    You can override the memory allocation functions at initialization time
    like this:

        void* my_alloc(size_t size, void* user_data) {
            return malloc(size);
        }

        void my_free(void* ptr, void* user_data) {
            free(ptr);
        }

        ...
            sg_setup(&(sg_desc){
                // ...
                .allocator = {
                    .alloc_fn = my_alloc,
                    .free_fn = my_free,
                    .user_data = ...,
                }
            });
        ...

    If no overrides are provided, malloc and free will be used.

    This only affects memory allocation calls done by sokol_gfx.h
    itself though, not any allocations in OS libraries.


    ERROR REPORTING AND LOGGING
    ===========================
    To get any logging information at all you need to provide a logging callback in the setup call
    the easiest way is to use sokol_log.h:

        #include "sokol_log.h"

        sg_setup(&(sg_desc){ .logger.func = slog_func });

    To override logging with your own callback, first write a logging function like this:

        void my_log(const char* tag,                // e.g. 'sg'
                    uint32_t log_level,             // 0=panic, 1=error, 2=warn, 3=info
                    uint32_t log_item_id,           // SG_LOGITEM_*
                    const char* message_or_null,    // a message string, may be nullptr in release mode
                    uint32_t line_nr,               // line number in sokol_gfx.h
                    const char* filename_or_null,   // source filename, may be nullptr in release mode
                    void* user_data)
        {
            ...
        }

    ...and then setup sokol-gfx like this:

        sg_setup(&(sg_desc){
            .logger = {
                .func = my_log,
                .user_data = my_user_data,
            }
        });

    The provided logging function must be reentrant (e.g. be callable from
    different threads).

    If you don't want to provide your own custom logger it is highly recommended to use
    the standard logger in sokol_log.h instead, otherwise you won't see any warnings or
    errors.


    COMMIT LISTENERS
    ================
    It's possible to hook callback functions into sokol-gfx which are called from
    inside sg_commit() in unspecified order. This is mainly useful for libraries
    that build on top of sokol_gfx.h to be notified about the end/start of a frame.

    To add a commit listener, call:

        static void my_commit_listener(void* user_data) {
            ...
        }

        bool success = sg_add_commit_listener((sg_commit_listener){
            .func = my_commit_listener,
            .user_data = ...,
        });

    The function returns false if the internal array of commit listeners is full,
    or the same commit listener had already been added.

    If the function returns true, my_commit_listener() will be called each frame
    from inside sg_commit().

    By default, 1024 distinct commit listeners can be added, but this number
    can be tweaked in the sg_setup() call:

        sg_setup(&(sg_desc){
            .max_commit_listeners = 2048,
        });

    An sg_commit_listener item is equal to another if both the function
    pointer and user_data field are equal.

    To remove a commit listener:

        bool success = sg_remove_commit_listener((sg_commit_listener){
            .func = my_commit_listener,
            .user_data = ...,
        });

    ...where the .func and .user_data field are equal to a previous
    sg_add_commit_listener() call. The function returns true if the commit
    listener item was found and removed, and false otherwise.


    RESOURCE CREATION AND DESTRUCTION IN DETAIL
    ===========================================
    The 'vanilla' way to create resource objects is with the 'make functions':

        sg_buffer sg_make_buffer(const sg_buffer_desc* desc)
        sg_image sg_make_image(const sg_image_desc* desc)
        sg_sampler sg_make_sampler(const sg_sampler_desc* desc)
        sg_shader sg_make_shader(const sg_shader_desc* desc)
        sg_pipeline sg_make_pipeline(const sg_pipeline_desc* desc)
        sg_attachments sg_make_attachments(const sg_attachments_desc* desc)

    This will result in one of three cases:

        1. The returned handle is invalid. This happens when there are no more
           free slots in the resource pool for this resource type. An invalid
           handle is associated with the INVALID resource state, for instance:

                sg_buffer buf = sg_make_buffer(...)
                if (sg_query_buffer_state(buf) == SG_RESOURCESTATE_INVALID) {
                    // buffer pool is exhausted
                }

        2. The returned handle is valid, but creating the underlying resource
           has failed for some reason. This results in a resource object in the
           FAILED state. The reason *why* resource creation has failed differ
           by resource type. Look for log messages with more details. A failed
           resource state can be checked with:

                sg_buffer buf = sg_make_buffer(...)
                if (sg_query_buffer_state(buf) == SG_RESOURCESTATE_FAILED) {
                    // creating the resource has failed
                }

        3. And finally, if everything goes right, the returned resource is
           in resource state VALID and ready to use. This can be checked
           with:

                sg_buffer buf = sg_make_buffer(...)
                if (sg_query_buffer_state(buf) == SG_RESOURCESTATE_VALID) {
                    // creating the resource has failed
                }

    When calling the 'make functions', the created resource goes through a number
    of states:

        - INITIAL: the resource slot associated with the new resource is currently
          free (technically, there is no resource yet, just an empty pool slot)
        - ALLOC: a handle for the new resource has been allocated, this just means
          a pool slot has been reserved.
        - VALID or FAILED: in VALID state any 3D API backend resource objects have
          been successfully created, otherwise if anything went wrong, the resource
          will be in FAILED state.

    Sometimes it makes sense to first grab a handle, but initialize the
    underlying resource at a later time. For instance when loading data
    asynchronously from a slow data source, you may know what buffers and
    textures are needed at an early stage of the loading process, but actually
    loading the buffer or texture content can only be completed at a later time.

    For such situations, sokol-gfx resource objects can be created in two steps.
    You can allocate a handle upfront with one of the 'alloc functions':

        sg_buffer sg_alloc_buffer(void)
        sg_image sg_alloc_image(void)
        sg_sampler sg_alloc_sampler(void)
        sg_shader sg_alloc_shader(void)
        sg_pipeline sg_alloc_pipeline(void)
        sg_attachments sg_alloc_attachments(void)

    This will return a handle with the underlying resource object in the
    ALLOC state:

        sg_image img = sg_alloc_image();
        if (sg_query_image_state(img) == SG_RESOURCESTATE_ALLOC) {
            // allocating an image handle has succeeded, otherwise
            // the image pool is full
        }

    Such an 'incomplete' handle can be used in most sokol-gfx rendering functions
    without doing any harm, sokol-gfx will simply skip any rendering operation
    that involve resources which are not in VALID state.

    At a later time (for instance once the texture has completed loading
    asynchronously), the resource creation can be completed by calling one of
    the 'init functions', those functions take an existing resource handle and
    'desc struct':

        void sg_init_buffer(sg_buffer buf, const sg_buffer_desc* desc)
        void sg_init_image(sg_image img, const sg_image_desc* desc)
        void sg_init_sampler(sg_sampler smp, const sg_sampler_desc* desc)
        void sg_init_shader(sg_shader shd, const sg_shader_desc* desc)
        void sg_init_pipeline(sg_pipeline pip, const sg_pipeline_desc* desc)
        void sg_init_attachments(sg_attachments atts, const sg_attachments_desc* desc)

    The init functions expect a resource in ALLOC state, and after the function
    returns, the resource will be either in VALID or FAILED state. Calling
    an 'alloc function' followed by the matching 'init function' is fully
    equivalent with calling the 'make function' alone.

    Destruction can also happen as a two-step process. The 'uninit functions'
    will put a resource object from the VALID or FAILED state back into the
    ALLOC state:

        void sg_uninit_buffer(sg_buffer buf)
        void sg_uninit_image(sg_image img)
        void sg_uninit_sampler(sg_sampler smp)
        void sg_uninit_shader(sg_shader shd)
        void sg_uninit_pipeline(sg_pipeline pip)
        void sg_uninit_attachments(sg_attachments pass)

    Calling the 'uninit functions' with a resource that is not in the VALID or
    FAILED state is a no-op.

    To finally free the pool slot for recycling call the 'dealloc functions':

        void sg_dealloc_buffer(sg_buffer buf)
        void sg_dealloc_image(sg_image img)
        void sg_dealloc_sampler(sg_sampler smp)
        void sg_dealloc_shader(sg_shader shd)
        void sg_dealloc_pipeline(sg_pipeline pip)
        void sg_dealloc_attachments(sg_attachments atts)

    Calling the 'dealloc functions' on a resource that's not in ALLOC state is
    a no-op, but will generate a warning log message.

    Calling an 'uninit function' and 'dealloc function' in sequence is equivalent
    with calling the associated 'destroy function':

        void sg_destroy_buffer(sg_buffer buf)
        void sg_destroy_image(sg_image img)
        void sg_destroy_sampler(sg_sampler smp)
        void sg_destroy_shader(sg_shader shd)
        void sg_destroy_pipeline(sg_pipeline pip)
        void sg_destroy_attachments(sg_attachments atts)

    The 'destroy functions' can be called on resources in any state and generally
    do the right thing (for instance if the resource is in ALLOC state, the destroy
    function will be equivalent to the 'dealloc function' and skip the 'uninit part').

    And finally to close the circle, the 'fail functions' can be called to manually
    put a resource in ALLOC state into the FAILED state:

        sg_fail_buffer(sg_buffer buf)
        sg_fail_image(sg_image img)
        sg_fail_sampler(sg_sampler smp)
        sg_fail_shader(sg_shader shd)
        sg_fail_pipeline(sg_pipeline pip)
        sg_fail_attachments(sg_attachments atts)

    This is recommended if anything went wrong outside of sokol-gfx during asynchronous
    resource setup (for instance a file loading operation failed). In this case,
    the 'fail function' should be called instead of the 'init function'.

    Calling a 'fail function' on a resource that's not in ALLOC state is a no-op,
    but will generate a warning log message.

    NOTE: that two-step resource creation usually only makes sense for buffers
    and images, but not for samplers, shaders, pipelines or attachments. Most notably, trying
    to create a pipeline object with a shader that's not in VALID state will
    trigger a validation layer error, or if the validation layer is disabled,
    result in a pipeline object in FAILED state. Same when trying to create
    an attachments object with invalid image objects.


    WEBGPU CAVEATS
    ==============
    For a general overview and design notes of the WebGPU backend see:

        https://floooh.github.io/2023/10/16/sokol-webgpu.html

    In general, don't expect an automatic speedup when switching from the WebGL2
    backend to the WebGPU backend. Some WebGPU functions currently actually
    have a higher CPU overhead than similar WebGL2 functions, leading to the
    paradoxical situation that some WebGPU code may be slower than similar WebGL2
    code.

    - when writing WGSL shader code by hand, a specific bind-slot convention
      must be used:

      All uniform block structs must use `@group(0)` and bindings in the
      range 0..127:

        @group(0) @binding(0..7)

      All textures, samplers and storage buffers must use `@group(1)` and
      bindings must be in the range 0..127:

        @group(1) @binding(0..127)

      Note that the number of texture, sampler and storage buffer bindings
      is still limited despite the large bind range:

        - up to 16 textures and sampler across all shader stages
        - up to 8 storage buffers across all shader stages

      If you use sokol-shdc to generate WGSL shader code, you don't need to worry
      about the above binding conventions since sokol-shdc.

    - The sokol-gfx WebGPU backend uses the sg_desc.uniform_buffer_size item
      to allocate a single per-frame uniform buffer which must be big enough
      to hold all data written by sg_apply_uniforms() during a single frame,
      including a worst-case 256-byte alignment (e.g. each sg_apply_uniform
      call will cost at least 256 bytes of uniform buffer size). The default size
      is 4 MB, which is enough for 16384 sg_apply_uniform() calls per
      frame (assuming the uniform data 'payload' is less than 256 bytes
      per call). These rules are the same as for the Metal backend, so if
      you are already using the Metal backend you'll be fine.

    - sg_apply_bindings(): the sokol-gfx WebGPU backend implements a bindgroup
      cache to prevent excessive creation and destruction of BindGroup objects
      when calling sg_apply_bindings(). The number of slots in the bindgroups
      cache is defined in sg_desc.wgpu_bindgroups_cache_size when calling
      sg_setup. The cache size must be a power-of-2 number, with the default being
      1024. The bindgroups cache behaviour can be observed by calling the new
      function sg_query_frame_stats(), where the following struct items are
      of interest:

        .wgpu.num_bindgroup_cache_hits
        .wgpu.num_bindgroup_cache_misses
        .wgpu.num_bindgroup_cache_collisions
        .wgpu_num_bindgroup_cache_invalidates
        .wgpu.num_bindgroup_cache_vs_hash_key_mismatch

      The value to pay attention to is `.wgpu.num_bindgroup_cache_collisions`,
      if this number is consistently higher than a few percent of the
      .wgpu.num_set_bindgroup value, it might be a good idea to bump the
      bindgroups cache size to the next power-of-2.

    - sg_apply_viewport(): WebGPU currently has a unique restriction that viewport
      rectangles must be contained entirely within the framebuffer. As a shitty
      workaround sokol_gfx.h will clip incoming viewport rectangles against
      the framebuffer, but this will distort the clipspace-to-screenspace mapping.
      There's no proper way to handle this inside sokol_gfx.h, this must be fixed
      in a future WebGPU update.

    - The sokol shader compiler generally adds `diagnostic(off, derivative_uniformity);`
      into the WGSL output. Currently only the Chrome WebGPU implementation seems
      to recognize this.

    - The vertex format SG_VERTEXFORMAT_UINT10_N2 is currently not supported because
      WebGPU lacks a matching vertex format (this is currently being worked on though,
      as soon as the vertex format shows up in webgpu.h, sokol_gfx.h will add support.

    - Likewise, the following sokol-gfx vertex formats are not supported in WebGPU:
      R16, R16SN, RG16, RG16SN, RGBA16, RGBA16SN and all PVRTC compressed format.
      Unlike unsupported vertex formats, unsupported pixel formats can be queried
      in cross-backend code via sg_query_pixel_format() though.

    - The Emscripten WebGPU shim currently doesn't support the Closure minification
      post-link-step (e.g. currently the emcc argument '--closure 1' or '--closure 2'
      will generate broken Javascript code.

    - sokol-gfx requires the WebGPU device feature `depth32float-stencil8` to be enabled
      (this should be widely supported)

    - sokol-gfx expects that the WebGPU device feature `float32-filterable` to *not* be
      enabled (since this would exclude all iOS devices)


    LICENSE
    =======
    zlib/libpng license

    Copyright (c) 2018 Andre Weissflog

    This software is provided 'as-is', without any express or implied warranty.
    In no event will the authors be held liable for any damages arising from the
    use of this software.

    Permission is granted to anyone to use this software for any purpose,
    including commercial applications, and to alter it and redistribute it
    freely, subject to the following restrictions:

        1. The origin of this software must not be misrepresented; you must not
        claim that you wrote the original software. If you use this software in a
        product, an acknowledgment in the product documentation would be
        appreciated but is not required.

        2. Altered source versions must be plainly marked as such, and must not
        be misrepresented as being the original software.

        3. This notice may not be removed or altered from any source
        distribution.

*/

import "core:c"

_ :: c

SOKOL_DEBUG :: #config(SOKOL_DEBUG, ODIN_DEBUG)

DEBUG :: #config(SOKOL_GFX_DEBUG, SOKOL_DEBUG)
USE_GL :: #config(SOKOL_USE_GL, false)
USE_DLL :: #config(SOKOL_DLL, false)

when ODIN_OS == .Windows {
    when USE_DLL {
        when USE_GL {
            when DEBUG { foreign import sokol_gfx_clib { "../sokol_dll_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_gfx_clib { "../sokol_dll_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_gfx_clib { "../sokol_dll_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_gfx_clib { "../sokol_dll_windows_x64_d3d11_release.lib" } }
        }
    } else {
        when USE_GL {
            when DEBUG { foreign import sokol_gfx_clib { "sokol_gfx_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_gfx_clib { "sokol_gfx_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_gfx_clib { "sokol_gfx_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_gfx_clib { "sokol_gfx_windows_x64_d3d11_release.lib" } }
        }
    }
} else when ODIN_OS == .Darwin {
    when USE_DLL {
             when  USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_gfx_clib { "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_gfx_clib { "../dylib/sokol_dylib_macos_arm64_gl_release.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_gfx_clib { "../dylib/sokol_dylib_macos_x64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_gfx_clib { "../dylib/sokol_dylib_macos_x64_gl_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_gfx_clib { "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_gfx_clib { "../dylib/sokol_dylib_macos_arm64_metal_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_gfx_clib { "../dylib/sokol_dylib_macos_x64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_gfx_clib { "../dylib/sokol_dylib_macos_x64_metal_release.dylib" } }
    } else {
        when USE_GL {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_gfx_clib { "sokol_gfx_macos_arm64_gl_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
                else       { foreign import sokol_gfx_clib { "sokol_gfx_macos_arm64_gl_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
            } else {
                when DEBUG { foreign import sokol_gfx_clib { "sokol_gfx_macos_x64_gl_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
                else       { foreign import sokol_gfx_clib { "sokol_gfx_macos_x64_gl_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
            }
        } else {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_gfx_clib { "sokol_gfx_macos_arm64_metal_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
                else       { foreign import sokol_gfx_clib { "sokol_gfx_macos_arm64_metal_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
            } else {
                when DEBUG { foreign import sokol_gfx_clib { "sokol_gfx_macos_x64_metal_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
                else       { foreign import sokol_gfx_clib { "sokol_gfx_macos_x64_metal_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
            }
        }
    }
} else when ODIN_OS == .Linux {
    when USE_DLL {
        when DEBUG { foreign import sokol_gfx_clib { "sokol_gfx_linux_x64_gl_debug.so", "system:GL", "system:dl", "system:pthread" } }
        else       { foreign import sokol_gfx_clib { "sokol_gfx_linux_x64_gl_release.so", "system:GL", "system:dl", "system:pthread" } }
    } else {
        when DEBUG { foreign import sokol_gfx_clib { "sokol_gfx_linux_x64_gl_debug.a", "system:GL", "system:dl", "system:pthread" } }
        else       { foreign import sokol_gfx_clib { "sokol_gfx_linux_x64_gl_release.a", "system:GL", "system:dl", "system:pthread" } }
    }
} else when ODIN_ARCH == .wasm32 || ODIN_ARCH == .wasm64p32 {
    // Feed sokol_gfx_wasm_gl_debug.a or sokol_gfx_wasm_gl_release.a into emscripten compiler.
    foreign import sokol_gfx_clib { "env.o" }
} else {
    #panic("This OS is currently not supported")
}

@(default_calling_convention="c", link_prefix="sg_")
foreign sokol_gfx_clib {
    // setup and misc functions
    setup :: proc(#by_ptr desc: Desc)  ---
    shutdown :: proc()  ---
    isvalid :: proc() -> bool ---
    reset_state_cache :: proc()  ---
    push_debug_group :: proc(name: cstring)  ---
    pop_debug_group :: proc()  ---
    add_commit_listener :: proc(listener: Commit_Listener) -> bool ---
    remove_commit_listener :: proc(listener: Commit_Listener) -> bool ---
    // resource creation, destruction and updating
    make_buffer :: proc(#by_ptr desc: Buffer_Desc) -> Buffer ---
    make_image :: proc(#by_ptr desc: Image_Desc) -> Image ---
    make_sampler :: proc(#by_ptr desc: Sampler_Desc) -> Sampler ---
    make_shader :: proc(#by_ptr desc: Shader_Desc) -> Shader ---
    make_pipeline :: proc(#by_ptr desc: Pipeline_Desc) -> Pipeline ---
    make_attachments :: proc(#by_ptr desc: Attachments_Desc) -> Attachments ---
    destroy_buffer :: proc(buf: Buffer)  ---
    destroy_image :: proc(img: Image)  ---
    destroy_sampler :: proc(smp: Sampler)  ---
    destroy_shader :: proc(shd: Shader)  ---
    destroy_pipeline :: proc(pip: Pipeline)  ---
    destroy_attachments :: proc(atts: Attachments)  ---
    update_buffer :: proc(buf: Buffer, #by_ptr data: Range)  ---
    update_image :: proc(img: Image, #by_ptr data: Image_Data)  ---
    append_buffer :: proc(buf: Buffer, #by_ptr data: Range) -> c.int ---
    query_buffer_overflow :: proc(buf: Buffer) -> bool ---
    query_buffer_will_overflow :: proc(buf: Buffer, size: c.size_t) -> bool ---
    // rendering functions
    begin_pass :: proc(#by_ptr pass: Pass)  ---
    apply_viewport :: proc(#any_int x: c.int, #any_int y: c.int, #any_int width: c.int, #any_int height: c.int, origin_top_left: bool)  ---
    apply_viewportf :: proc(x: f32, y: f32, width: f32, height: f32, origin_top_left: bool)  ---
    apply_scissor_rect :: proc(#any_int x: c.int, #any_int y: c.int, #any_int width: c.int, #any_int height: c.int, origin_top_left: bool)  ---
    apply_scissor_rectf :: proc(x: f32, y: f32, width: f32, height: f32, origin_top_left: bool)  ---
    apply_pipeline :: proc(pip: Pipeline)  ---
    apply_bindings :: proc(#by_ptr bindings: Bindings)  ---
    apply_uniforms :: proc(#any_int ub_slot: c.int, #by_ptr data: Range)  ---
    draw :: proc(#any_int base_element: c.int, #any_int num_elements: c.int, #any_int num_instances: c.int)  ---
    end_pass :: proc()  ---
    commit :: proc()  ---
    // getting information
    query_desc :: proc() -> Desc ---
    query_backend :: proc() -> Backend ---
    query_features :: proc() -> Features ---
    query_limits :: proc() -> Limits ---
    query_pixelformat :: proc(fmt: Pixel_Format) -> Pixelformat_Info ---
    query_row_pitch :: proc(fmt: Pixel_Format, #any_int width: c.int, #any_int row_align_bytes: c.int) -> c.int ---
    query_surface_pitch :: proc(fmt: Pixel_Format, #any_int width: c.int, #any_int height: c.int, #any_int row_align_bytes: c.int) -> c.int ---
    // get current state of a resource (INITIAL, ALLOC, VALID, FAILED, INVALID)
    query_buffer_state :: proc(buf: Buffer) -> Resource_State ---
    query_image_state :: proc(img: Image) -> Resource_State ---
    query_sampler_state :: proc(smp: Sampler) -> Resource_State ---
    query_shader_state :: proc(shd: Shader) -> Resource_State ---
    query_pipeline_state :: proc(pip: Pipeline) -> Resource_State ---
    query_attachments_state :: proc(atts: Attachments) -> Resource_State ---
    // get runtime information about a resource
    query_buffer_info :: proc(buf: Buffer) -> Buffer_Info ---
    query_image_info :: proc(img: Image) -> Image_Info ---
    query_sampler_info :: proc(smp: Sampler) -> Sampler_Info ---
    query_shader_info :: proc(shd: Shader) -> Shader_Info ---
    query_pipeline_info :: proc(pip: Pipeline) -> Pipeline_Info ---
    query_attachments_info :: proc(atts: Attachments) -> Attachments_Info ---
    // get desc structs matching a specific resource (NOTE that not all creation attributes may be provided)
    query_buffer_desc :: proc(buf: Buffer) -> Buffer_Desc ---
    query_image_desc :: proc(img: Image) -> Image_Desc ---
    query_sampler_desc :: proc(smp: Sampler) -> Sampler_Desc ---
    query_shader_desc :: proc(shd: Shader) -> Shader_Desc ---
    query_pipeline_desc :: proc(pip: Pipeline) -> Pipeline_Desc ---
    query_attachments_desc :: proc(atts: Attachments) -> Attachments_Desc ---
    // get resource creation desc struct with their default values replaced
    query_buffer_defaults :: proc(#by_ptr desc: Buffer_Desc) -> Buffer_Desc ---
    query_image_defaults :: proc(#by_ptr desc: Image_Desc) -> Image_Desc ---
    query_sampler_defaults :: proc(#by_ptr desc: Sampler_Desc) -> Sampler_Desc ---
    query_shader_defaults :: proc(#by_ptr desc: Shader_Desc) -> Shader_Desc ---
    query_pipeline_defaults :: proc(#by_ptr desc: Pipeline_Desc) -> Pipeline_Desc ---
    query_attachments_defaults :: proc(#by_ptr desc: Attachments_Desc) -> Attachments_Desc ---
    // assorted query functions
    query_buffer_size :: proc(buf: Buffer) -> c.size_t ---
    query_buffer_type :: proc(buf: Buffer) -> Buffer_Type ---
    query_buffer_usage :: proc(buf: Buffer) -> Usage ---
    query_image_type :: proc(img: Image) -> Image_Type ---
    query_image_width :: proc(img: Image) -> c.int ---
    query_image_height :: proc(img: Image) -> c.int ---
    query_image_num_slices :: proc(img: Image) -> c.int ---
    query_image_num_mipmaps :: proc(img: Image) -> c.int ---
    query_image_pixelformat :: proc(img: Image) -> Pixel_Format ---
    query_image_usage :: proc(img: Image) -> Usage ---
    query_image_sample_count :: proc(img: Image) -> c.int ---
    // separate resource allocation and initialization (for async setup)
    alloc_buffer :: proc() -> Buffer ---
    alloc_image :: proc() -> Image ---
    alloc_sampler :: proc() -> Sampler ---
    alloc_shader :: proc() -> Shader ---
    alloc_pipeline :: proc() -> Pipeline ---
    alloc_attachments :: proc() -> Attachments ---
    dealloc_buffer :: proc(buf: Buffer)  ---
    dealloc_image :: proc(img: Image)  ---
    dealloc_sampler :: proc(smp: Sampler)  ---
    dealloc_shader :: proc(shd: Shader)  ---
    dealloc_pipeline :: proc(pip: Pipeline)  ---
    dealloc_attachments :: proc(attachments: Attachments)  ---
    init_buffer :: proc(buf: Buffer, #by_ptr desc: Buffer_Desc)  ---
    init_image :: proc(img: Image, #by_ptr desc: Image_Desc)  ---
    init_sampler :: proc(smg: Sampler, #by_ptr desc: Sampler_Desc)  ---
    init_shader :: proc(shd: Shader, #by_ptr desc: Shader_Desc)  ---
    init_pipeline :: proc(pip: Pipeline, #by_ptr desc: Pipeline_Desc)  ---
    init_attachments :: proc(attachments: Attachments, #by_ptr desc: Attachments_Desc)  ---
    uninit_buffer :: proc(buf: Buffer)  ---
    uninit_image :: proc(img: Image)  ---
    uninit_sampler :: proc(smp: Sampler)  ---
    uninit_shader :: proc(shd: Shader)  ---
    uninit_pipeline :: proc(pip: Pipeline)  ---
    uninit_attachments :: proc(atts: Attachments)  ---
    fail_buffer :: proc(buf: Buffer)  ---
    fail_image :: proc(img: Image)  ---
    fail_sampler :: proc(smp: Sampler)  ---
    fail_shader :: proc(shd: Shader)  ---
    fail_pipeline :: proc(pip: Pipeline)  ---
    fail_attachments :: proc(atts: Attachments)  ---
    // frame stats
    enable_frame_stats :: proc()  ---
    disable_frame_stats :: proc()  ---
    frame_stats_enabled :: proc() -> bool ---
    query_frame_stats :: proc() -> Frame_Stats ---
    // D3D11: return ID3D11Device
    d3d11_device :: proc() -> rawptr ---
    // D3D11: return ID3D11DeviceContext
    d3d11_device_context :: proc() -> rawptr ---
    // D3D11: get internal buffer resource objects
    d3d11_query_buffer_info :: proc(buf: Buffer) -> D3d11_Buffer_Info ---
    // D3D11: get internal image resource objects
    d3d11_query_image_info :: proc(img: Image) -> D3d11_Image_Info ---
    // D3D11: get internal sampler resource objects
    d3d11_query_sampler_info :: proc(smp: Sampler) -> D3d11_Sampler_Info ---
    // D3D11: get internal shader resource objects
    d3d11_query_shader_info :: proc(shd: Shader) -> D3d11_Shader_Info ---
    // D3D11: get internal pipeline resource objects
    d3d11_query_pipeline_info :: proc(pip: Pipeline) -> D3d11_Pipeline_Info ---
    // D3D11: get internal pass resource objects
    d3d11_query_attachments_info :: proc(atts: Attachments) -> D3d11_Attachments_Info ---
    // Metal: return __bridge-casted MTLDevice
    mtl_device :: proc() -> rawptr ---
    // Metal: return __bridge-casted MTLRenderCommandEncoder in current pass (or zero if outside pass)
    mtl_render_command_encoder :: proc() -> rawptr ---
    // Metal: get internal __bridge-casted buffer resource objects
    mtl_query_buffer_info :: proc(buf: Buffer) -> Mtl_Buffer_Info ---
    // Metal: get internal __bridge-casted image resource objects
    mtl_query_image_info :: proc(img: Image) -> Mtl_Image_Info ---
    // Metal: get internal __bridge-casted sampler resource objects
    mtl_query_sampler_info :: proc(smp: Sampler) -> Mtl_Sampler_Info ---
    // Metal: get internal __bridge-casted shader resource objects
    mtl_query_shader_info :: proc(shd: Shader) -> Mtl_Shader_Info ---
    // Metal: get internal __bridge-casted pipeline resource objects
    mtl_query_pipeline_info :: proc(pip: Pipeline) -> Mtl_Pipeline_Info ---
    // WebGPU: return WGPUDevice object
    wgpu_device :: proc() -> rawptr ---
    // WebGPU: return WGPUQueue object
    wgpu_queue :: proc() -> rawptr ---
    // WebGPU: return this frame's WGPUCommandEncoder
    wgpu_command_encoder :: proc() -> rawptr ---
    // WebGPU: return WGPURenderPassEncoder of current pass
    wgpu_render_pass_encoder :: proc() -> rawptr ---
    // WebGPU: get internal buffer resource objects
    wgpu_query_buffer_info :: proc(buf: Buffer) -> Wgpu_Buffer_Info ---
    // WebGPU: get internal image resource objects
    wgpu_query_image_info :: proc(img: Image) -> Wgpu_Image_Info ---
    // WebGPU: get internal sampler resource objects
    wgpu_query_sampler_info :: proc(smp: Sampler) -> Wgpu_Sampler_Info ---
    // WebGPU: get internal shader resource objects
    wgpu_query_shader_info :: proc(shd: Shader) -> Wgpu_Shader_Info ---
    // WebGPU: get internal pipeline resource objects
    wgpu_query_pipeline_info :: proc(pip: Pipeline) -> Wgpu_Pipeline_Info ---
    // WebGPU: get internal pass resource objects
    wgpu_query_attachments_info :: proc(atts: Attachments) -> Wgpu_Attachments_Info ---
    // GL: get internal buffer resource objects
    gl_query_buffer_info :: proc(buf: Buffer) -> Gl_Buffer_Info ---
    // GL: get internal image resource objects
    gl_query_image_info :: proc(img: Image) -> Gl_Image_Info ---
    // GL: get internal sampler resource objects
    gl_query_sampler_info :: proc(smp: Sampler) -> Gl_Sampler_Info ---
    // GL: get internal shader resource objects
    gl_query_shader_info :: proc(shd: Shader) -> Gl_Shader_Info ---
    // GL: get internal pass resource objects
    gl_query_attachments_info :: proc(atts: Attachments) -> Gl_Attachments_Info ---
}

/*
    Resource id typedefs:

    sg_buffer:      vertex- and index-buffers
    sg_image:       images used as textures and render-pass attachments
    sg_sampler      sampler objects describing how a texture is sampled in a shader
    sg_shader:      vertex- and fragment-shaders and shader interface information
    sg_pipeline:    associated shader and vertex-layouts, and render states
    sg_attachments: a baked collection of render pass attachment images

    Instead of pointers, resource creation functions return a 32-bit
    handle which uniquely identifies the resource object.

    The 32-bit resource id is split into a 16-bit pool index in the lower bits,
    and a 16-bit 'generation counter' in the upper bits. The index allows fast
    pool lookups, and combined with the generation-counter it allows to detect
    'dangling accesses' (trying to use an object which no longer exists, and
    its pool slot has been reused for a new object)

    The resource ids are wrapped into a strongly-typed struct so that
    trying to pass an incompatible resource id is a compile error.
*/
Buffer :: struct {
    id : u32,
}

Image :: struct {
    id : u32,
}

Sampler :: struct {
    id : u32,
}

Shader :: struct {
    id : u32,
}

Pipeline :: struct {
    id : u32,
}

Attachments :: struct {
    id : u32,
}

/*
    sg_range is a pointer-size-pair struct used to pass memory blobs into
    sokol-gfx. When initialized from a value type (array or struct), you can
    use the SG_RANGE() macro to build an sg_range struct. For functions which
    take either a sg_range pointer, or a (C++) sg_range reference, use the
    SG_RANGE_REF macro as a solution which compiles both in C and C++.
*/
Range :: struct {
    ptr : rawptr,
    size : c.size_t,
}

// various compile-time constants in the public API
INVALID_ID :: 0
NUM_INFLIGHT_FRAMES :: 2
MAX_COLOR_ATTACHMENTS :: 4
MAX_UNIFORMBLOCK_MEMBERS :: 16
MAX_VERTEX_ATTRIBUTES :: 16
MAX_MIPMAPS :: 16
MAX_TEXTUREARRAY_LAYERS :: 128
MAX_UNIFORMBLOCK_BINDSLOTS :: 8
MAX_VERTEXBUFFER_BINDSLOTS :: 8
MAX_IMAGE_BINDSLOTS :: 16
MAX_SAMPLER_BINDSLOTS :: 16
MAX_STORAGEBUFFER_BINDSLOTS :: 8
MAX_IMAGE_SAMPLER_PAIRS :: 16

/*
    sg_color

    An RGBA color value.
*/
Color :: struct {
    r : f32,
    g : f32,
    b : f32,
    a : f32,
}

/*
    sg_backend

    The active 3D-API backend, use the function sg_query_backend()
    to get the currently active backend.
*/
Backend :: enum i32 {
    GLCORE,
    GLES3,
    D3D11,
    METAL_IOS,
    METAL_MACOS,
    METAL_SIMULATOR,
    WGPU,
    DUMMY,
}

/*
    sg_pixel_format

    sokol_gfx.h basically uses the same pixel formats as WebGPU, since these
    are supported on most newer GPUs.

    A pixelformat name consist of three parts:

        - components (R, RG, RGB or RGBA)
        - bit width per component (8, 16 or 32)
        - component data type:
            - unsigned normalized (no postfix)
            - signed normalized (SN postfix)
            - unsigned integer (UI postfix)
            - signed integer (SI postfix)
            - float (F postfix)

    Not all pixel formats can be used for everything, call sg_query_pixelformat()
    to inspect the capabilities of a given pixelformat. The function returns
    an sg_pixelformat_info struct with the following members:

        - sample: the pixelformat can be sampled as texture at least with
                  nearest filtering
        - filter: the pixelformat can be sampled as texture with linear
                  filtering
        - render: the pixelformat can be used as render-pass attachment
        - blend:  blending is supported when used as render-pass attachment
        - msaa:   multisample-antialiasing is supported when used
                  as render-pass attachment
        - depth:  the pixelformat can be used for depth-stencil attachments
        - compressed: this is a block-compressed format
        - bytes_per_pixel: the numbers of bytes in a pixel (0 for compressed formats)

    The default pixel format for texture images is SG_PIXELFORMAT_RGBA8.

    The default pixel format for render target images is platform-dependent
    and taken from the sg_environment struct passed into sg_setup(). Typically
    the default formats are:

        - for the Metal, D3D11 and WebGPU backends: SG_PIXELFORMAT_BGRA8
        - for GL backends: SG_PIXELFORMAT_RGBA8
*/
Pixel_Format :: enum i32 {
    DEFAULT,
    NONE,
    R8,
    R8SN,
    R8UI,
    R8SI,
    R16,
    R16SN,
    R16UI,
    R16SI,
    R16F,
    RG8,
    RG8SN,
    RG8UI,
    RG8SI,
    R32UI,
    R32SI,
    R32F,
    RG16,
    RG16SN,
    RG16UI,
    RG16SI,
    RG16F,
    RGBA8,
    SRGB8A8,
    RGBA8SN,
    RGBA8UI,
    RGBA8SI,
    BGRA8,
    RGB10A2,
    RG11B10F,
    RGB9E5,
    RG32UI,
    RG32SI,
    RG32F,
    RGBA16,
    RGBA16SN,
    RGBA16UI,
    RGBA16SI,
    RGBA16F,
    RGBA32UI,
    RGBA32SI,
    RGBA32F,
    DEPTH,
    DEPTH_STENCIL,
    BC1_RGBA,
    BC2_RGBA,
    BC3_RGBA,
    BC3_SRGBA,
    BC4_R,
    BC4_RSN,
    BC5_RG,
    BC5_RGSN,
    BC6H_RGBF,
    BC6H_RGBUF,
    BC7_RGBA,
    BC7_SRGBA,
    PVRTC_RGB_2BPP,
    PVRTC_RGB_4BPP,
    PVRTC_RGBA_2BPP,
    PVRTC_RGBA_4BPP,
    ETC2_RGB8,
    ETC2_SRGB8,
    ETC2_RGB8A1,
    ETC2_RGBA8,
    ETC2_SRGB8A8,
    EAC_R11,
    EAC_R11SN,
    EAC_RG11,
    EAC_RG11SN,
    ASTC_4x4_RGBA,
    ASTC_4x4_SRGBA,
}

// Runtime information about a pixel format, returned by sg_query_pixelformat().
Pixelformat_Info :: struct {
    sample : bool,
    filter : bool,
    render : bool,
    blend : bool,
    msaa : bool,
    depth : bool,
    compressed : bool,
    bytes_per_pixel : c.int,
}

// Runtime information about available optional features, returned by sg_query_features()
Features :: struct {
    origin_top_left : bool,
    image_clamp_to_border : bool,
    mrt_independent_blend_state : bool,
    mrt_independent_write_mask : bool,
    storage_buffer : bool,
    msaa_image_bindings : bool,
}

// Runtime information about resource limits, returned by sg_query_limit()
Limits :: struct {
    max_image_size_2d : c.int,
    max_image_size_cube : c.int,
    max_image_size_3d : c.int,
    max_image_size_array : c.int,
    max_image_array_layers : c.int,
    max_vertex_attrs : c.int,
    gl_max_vertex_uniform_components : c.int,
    gl_max_combined_texture_image_units : c.int,
}

/*
    sg_resource_state

    The current state of a resource in its resource pool.
    Resources start in the INITIAL state, which means the
    pool slot is unoccupied and can be allocated. When a resource is
    created, first an id is allocated, and the resource pool slot
    is set to state ALLOC. After allocation, the resource is
    initialized, which may result in the VALID or FAILED state. The
    reason why allocation and initialization are separate is because
    some resource types (e.g. buffers and images) might be asynchronously
    initialized by the user application. If a resource which is not
    in the VALID state is attempted to be used for rendering, rendering
    operations will silently be dropped.

    The special INVALID state is returned in sg_query_xxx_state() if no
    resource object exists for the provided resource id.
*/
Resource_State :: enum i32 {
    INITIAL,
    ALLOC,
    VALID,
    FAILED,
    INVALID,
}

/*
    sg_usage

    A resource usage hint describing the update strategy of
    buffers and images. This is used in the sg_buffer_desc.usage
    and sg_image_desc.usage members when creating buffers
    and images:

    SG_USAGE_IMMUTABLE:     the resource will never be updated with
                            new data, instead the content of the
                            resource must be provided on creation
    SG_USAGE_DYNAMIC:       the resource will be updated infrequently
                            with new data (this could range from "once
                            after creation", to "quite often but not
                            every frame")
    SG_USAGE_STREAM:        the resource will be updated each frame
                            with new content

    The rendering backends use this hint to prevent that the
    CPU needs to wait for the GPU when attempting to update
    a resource that might be currently accessed by the GPU.

    Resource content is updated with the functions sg_update_buffer() or
    sg_append_buffer() for buffer objects, and sg_update_image() for image
    objects. For the sg_update_*() functions, only one update is allowed per
    frame and resource object, while sg_append_buffer() can be called
    multiple times per frame on the same buffer. The application must update
    all data required for rendering (this means that the update data can be
    smaller than the resource size, if only a part of the overall resource
    size is used for rendering, you only need to make sure that the data that
    *is* used is valid).

    The default usage is SG_USAGE_IMMUTABLE.
*/
Usage :: enum i32 {
    DEFAULT,
    IMMUTABLE,
    DYNAMIC,
    STREAM,
}

/*
    sg_buffer_type

    Indicates whether a buffer will be bound as vertex-,
    index- or storage-buffer.

    Used in the sg_buffer_desc.type member when creating a buffer.

    The default value is SG_BUFFERTYPE_VERTEXBUFFER.
*/
Buffer_Type :: enum i32 {
    DEFAULT,
    VERTEXBUFFER,
    INDEXBUFFER,
    STORAGEBUFFER,
}

/*
    sg_index_type

    Indicates whether indexed rendering (fetching vertex-indices from an
    index buffer) is used, and if yes, the index data type (16- or 32-bits).

    This is used in the sg_pipeline_desc.index_type member when creating a
    pipeline object.

    The default index type is SG_INDEXTYPE_NONE.
*/
Index_Type :: enum i32 {
    DEFAULT,
    NONE,
    UINT16,
    UINT32,
}

/*
    sg_image_type

    Indicates the basic type of an image object (2D-texture, cubemap,
    3D-texture or 2D-array-texture). Used in the sg_image_desc.type member when
    creating an image, and in sg_shader_image_desc to describe a sampled texture
    in the shader (both must match and will be checked in the validation layer
    when calling sg_apply_bindings).

    The default image type when creating an image is SG_IMAGETYPE_2D.
*/
Image_Type :: enum i32 {
    DEFAULT,
    _2D,
    CUBE,
    _3D,
    ARRAY,
}

/*
    sg_image_sample_type

    The basic data type of a texture sample as expected by a shader.
    Must be provided in sg_shader_image and used by the validation
    layer in sg_apply_bindings() to check if the provided image object
    is compatible with what the shader expects. Apart from the sokol-gfx
    validation layer, WebGPU is the only backend API which actually requires
    matching texture and sampler type to be provided upfront for validation
    (other 3D APIs treat texture/sampler type mismatches as undefined behaviour).

    NOTE that the following texture pixel formats require the use
    of SG_IMAGESAMPLETYPE_UNFILTERABLE_FLOAT, combined with a sampler
    of type SG_SAMPLERTYPE_NONFILTERING:

    - SG_PIXELFORMAT_R32F
    - SG_PIXELFORMAT_RG32F
    - SG_PIXELFORMAT_RGBA32F

    (when using sokol-shdc, also check out the meta tags `@image_sample_type`
    and `@sampler_type`)
*/
Image_Sample_Type :: enum i32 {
    DEFAULT,
    FLOAT,
    DEPTH,
    SINT,
    UINT,
    UNFILTERABLE_FLOAT,
}

/*
    sg_sampler_type

    The basic type of a texture sampler (sampling vs comparison) as
    defined in a shader. Must be provided in sg_shader_sampler_desc.

    sg_image_sample_type and sg_sampler_type for a texture/sampler
    pair must be compatible with each other, specifically only
    the following pairs are allowed:

    - SG_IMAGESAMPLETYPE_FLOAT => (SG_SAMPLERTYPE_FILTERING or SG_SAMPLERTYPE_NONFILTERING)
    - SG_IMAGESAMPLETYPE_UNFILTERABLE_FLOAT => SG_SAMPLERTYPE_NONFILTERING
    - SG_IMAGESAMPLETYPE_SINT => SG_SAMPLERTYPE_NONFILTERING
    - SG_IMAGESAMPLETYPE_UINT => SG_SAMPLERTYPE_NONFILTERING
    - SG_IMAGESAMPLETYPE_DEPTH => SG_SAMPLERTYPE_COMPARISON
*/
Sampler_Type :: enum i32 {
    DEFAULT,
    FILTERING,
    NONFILTERING,
    COMPARISON,
}

/*
    sg_cube_face

    The cubemap faces. Use these as indices in the sg_image_desc.content
    array.
*/
Cube_Face :: enum i32 {
    POS_X,
    NEG_X,
    POS_Y,
    NEG_Y,
    POS_Z,
    NEG_Z,
}

/*
    sg_primitive_type

    This is the common subset of 3D primitive types supported across all 3D
    APIs. This is used in the sg_pipeline_desc.primitive_type member when
    creating a pipeline object.

    The default primitive type is SG_PRIMITIVETYPE_TRIANGLES.
*/
Primitive_Type :: enum i32 {
    DEFAULT,
    POINTS,
    LINES,
    LINE_STRIP,
    TRIANGLES,
    TRIANGLE_STRIP,
}

/*
    sg_filter

    The filtering mode when sampling a texture image. This is
    used in the sg_sampler_desc.min_filter, sg_sampler_desc.mag_filter
    and sg_sampler_desc.mipmap_filter members when creating a sampler object.

    For the default is SG_FILTER_NEAREST.
*/
Filter :: enum i32 {
    DEFAULT,
    NEAREST,
    LINEAR,
}

/*
    sg_wrap

    The texture coordinates wrapping mode when sampling a texture
    image. This is used in the sg_image_desc.wrap_u, .wrap_v
    and .wrap_w members when creating an image.

    The default wrap mode is SG_WRAP_REPEAT.

    NOTE: SG_WRAP_CLAMP_TO_BORDER is not supported on all backends
    and platforms. To check for support, call sg_query_features()
    and check the "clamp_to_border" boolean in the returned
    sg_features struct.

    Platforms which don't support SG_WRAP_CLAMP_TO_BORDER will silently fall back
    to SG_WRAP_CLAMP_TO_EDGE without a validation error.
*/
Wrap :: enum i32 {
    DEFAULT,
    REPEAT,
    CLAMP_TO_EDGE,
    CLAMP_TO_BORDER,
    MIRRORED_REPEAT,
}

/*
    sg_border_color

    The border color to use when sampling a texture, and the UV wrap
    mode is SG_WRAP_CLAMP_TO_BORDER.

    The default border color is SG_BORDERCOLOR_OPAQUE_BLACK
*/
Border_Color :: enum i32 {
    DEFAULT,
    TRANSPARENT_BLACK,
    OPAQUE_BLACK,
    OPAQUE_WHITE,
}

/*
    sg_vertex_format

    The data type of a vertex component. This is used to describe
    the layout of vertex data when creating a pipeline object.
*/
Vertex_Format :: enum i32 {
    INVALID,
    FLOAT,
    FLOAT2,
    FLOAT3,
    FLOAT4,
    BYTE4,
    BYTE4N,
    UBYTE4,
    UBYTE4N,
    SHORT2,
    SHORT2N,
    USHORT2N,
    SHORT4,
    SHORT4N,
    USHORT4N,
    UINT10_N2,
    HALF2,
    HALF4,
}

/*
    sg_vertex_step

    Defines whether the input pointer of a vertex input stream is advanced
    'per vertex' or 'per instance'. The default step-func is
    SG_VERTEXSTEP_PER_VERTEX. SG_VERTEXSTEP_PER_INSTANCE is used with
    instanced-rendering.

    The vertex-step is part of the vertex-layout definition
    when creating pipeline objects.
*/
Vertex_Step :: enum i32 {
    DEFAULT,
    PER_VERTEX,
    PER_INSTANCE,
}

/*
    sg_uniform_type

    The data type of a uniform block member. This is used to
    describe the internal layout of uniform blocks when creating
    a shader object. This is only required for the GL backend, all
    other backends will ignore the interior layout of uniform blocks.
*/
Uniform_Type :: enum i32 {
    INVALID,
    FLOAT,
    FLOAT2,
    FLOAT3,
    FLOAT4,
    INT,
    INT2,
    INT3,
    INT4,
    MAT4,
}

/*
    sg_uniform_layout

    A hint for the interior memory layout of uniform blocks. This is
    only relevant for the GL backend where the internal layout
    of uniform blocks must be known to sokol-gfx. For all other backends the
    internal memory layout of uniform blocks doesn't matter, sokol-gfx
    will just pass uniform data as a single memory blob to the
    3D backend.

    SG_UNIFORMLAYOUT_NATIVE (default)
        Native layout means that a 'backend-native' memory layout
        is used. For the GL backend this means that uniforms
        are packed tightly in memory (e.g. there are no padding
        bytes).

    SG_UNIFORMLAYOUT_STD140
        The memory layout is a subset of std140. Arrays are only
        allowed for the FLOAT4, INT4 and MAT4. Alignment is as
        is as follows:

            FLOAT, INT:         4 byte alignment
            FLOAT2, INT2:       8 byte alignment
            FLOAT3, INT3:       16 byte alignment(!)
            FLOAT4, INT4:       16 byte alignment
            MAT4:               16 byte alignment
            FLOAT4[], INT4[]:   16 byte alignment

        The overall size of the uniform block must be a multiple
        of 16.

    For more information search for 'UNIFORM DATA LAYOUT' in the documentation block
    at the start of the header.
*/
Uniform_Layout :: enum i32 {
    DEFAULT,
    NATIVE,
    STD140,
}

/*
    sg_cull_mode

    The face-culling mode, this is used in the
    sg_pipeline_desc.cull_mode member when creating a
    pipeline object.

    The default cull mode is SG_CULLMODE_NONE
*/
Cull_Mode :: enum i32 {
    DEFAULT,
    NONE,
    FRONT,
    BACK,
}

/*
    sg_face_winding

    The vertex-winding rule that determines a front-facing primitive. This
    is used in the member sg_pipeline_desc.face_winding
    when creating a pipeline object.

    The default winding is SG_FACEWINDING_CW (clockwise)
*/
Face_Winding :: enum i32 {
    DEFAULT,
    CCW,
    CW,
}

/*
    sg_compare_func

    The compare-function for configuring depth- and stencil-ref tests
    in pipeline objects, and for texture samplers which perform a comparison
    instead of regular sampling operation.

    Used in the following structs:

    sg_pipeline_desc
        .depth
            .compare
        .stencil
            .front.compare
            .back.compar

    sg_sampler_desc
        .compare

    The default compare func for depth- and stencil-tests is
    SG_COMPAREFUNC_ALWAYS.

    The default compare func for samplers is SG_COMPAREFUNC_NEVER.
*/
Compare_Func :: enum i32 {
    DEFAULT,
    NEVER,
    LESS,
    EQUAL,
    LESS_EQUAL,
    GREATER,
    NOT_EQUAL,
    GREATER_EQUAL,
    ALWAYS,
}

/*
    sg_stencil_op

    The operation performed on a currently stored stencil-value when a
    comparison test passes or fails. This is used when creating a pipeline
    object in the following sg_pipeline_desc struct items:

    sg_pipeline_desc
        .stencil
            .front
                .fail_op
                .depth_fail_op
                .pass_op
            .back
                .fail_op
                .depth_fail_op
                .pass_op

    The default value is SG_STENCILOP_KEEP.
*/
Stencil_Op :: enum i32 {
    DEFAULT,
    KEEP,
    ZERO,
    REPLACE,
    INCR_CLAMP,
    DECR_CLAMP,
    INVERT,
    INCR_WRAP,
    DECR_WRAP,
}

/*
    sg_blend_factor

    The source and destination factors in blending operations.
    This is used in the following members when creating a pipeline object:

    sg_pipeline_desc
        .colors[i]
            .blend
                .src_factor_rgb
                .dst_factor_rgb
                .src_factor_alpha
                .dst_factor_alpha

    The default value is SG_BLENDFACTOR_ONE for source
    factors, and SG_BLENDFACTOR_ZERO for destination factors.
*/
Blend_Factor :: enum i32 {
    DEFAULT,
    ZERO,
    ONE,
    SRC_COLOR,
    ONE_MINUS_SRC_COLOR,
    SRC_ALPHA,
    ONE_MINUS_SRC_ALPHA,
    DST_COLOR,
    ONE_MINUS_DST_COLOR,
    DST_ALPHA,
    ONE_MINUS_DST_ALPHA,
    SRC_ALPHA_SATURATED,
    BLEND_COLOR,
    ONE_MINUS_BLEND_COLOR,
    BLEND_ALPHA,
    ONE_MINUS_BLEND_ALPHA,
}

/*
    sg_blend_op

    Describes how the source and destination values are combined in the
    fragment blending operation. It is used in the following struct items
    when creating a pipeline object:

    sg_pipeline_desc
        .colors[i]
            .blend
                .op_rgb
                .op_alpha

    The default value is SG_BLENDOP_ADD.
*/
Blend_Op :: enum i32 {
    DEFAULT,
    ADD,
    SUBTRACT,
    REVERSE_SUBTRACT,
}

/*
    sg_color_mask

    Selects the active color channels when writing a fragment color to the
    framebuffer. This is used in the members
    sg_pipeline_desc.colors[i].write_mask when creating a pipeline object.

    The default colormask is SG_COLORMASK_RGBA (write all colors channels)

    NOTE: since the color mask value 0 is reserved for the default value
    (SG_COLORMASK_RGBA), use SG_COLORMASK_NONE if all color channels
    should be disabled.
*/
Color_Mask :: enum i32 {
    DEFAULT = 0,
    NONE = 16,
    R = 1,
    G = 2,
    RG = 3,
    B = 4,
    RB = 5,
    GB = 6,
    RGB = 7,
    A = 8,
    RA = 9,
    GA = 10,
    RGA = 11,
    BA = 12,
    RBA = 13,
    GBA = 14,
    RGBA = 15,
}

/*
    sg_load_action

    Defines the load action that should be performed at the start of a render pass:

    SG_LOADACTION_CLEAR:        clear the render target
    SG_LOADACTION_LOAD:         load the previous content of the render target
    SG_LOADACTION_DONTCARE:     leave the render target in an undefined state

    This is used in the sg_pass_action structure.

    The default load action for all pass attachments is SG_LOADACTION_CLEAR,
    with the values rgba = { 0.5f, 0.5f, 0.5f, 1.0f }, depth=1.0f and stencil=0.

    If you want to override the default behaviour, it is important to not
    only set the clear color, but the 'action' field as well (as long as this
    is _SG_LOADACTION_DEFAULT, the value fields will be ignored).
*/
Load_Action :: enum i32 {
    DEFAULT,
    CLEAR,
    LOAD,
    DONTCARE,
}

/*
    sg_store_action

    Defines the store action that should be performed at the end of a render pass:

    SG_STOREACTION_STORE:       store the rendered content to the color attachment image
    SG_STOREACTION_DONTCARE:    allows the GPU to discard the rendered content
*/
Store_Action :: enum i32 {
    DEFAULT,
    STORE,
    DONTCARE,
}

/*
    sg_pass_action

    The sg_pass_action struct defines the actions to be performed
    at the start and end of a render pass.

    - at the start of the pass: whether the render attachments should be cleared,
      loaded with their previous content, or start in an undefined state
    - for clear operations: the clear value (color, depth, or stencil values)
    - at the end of the pass: whether the rendering result should be
      stored back into the render attachment or discarded
*/
Color_Attachment_Action :: struct {
    load_action : Load_Action,
    store_action : Store_Action,
    clear_value : Color,
}

Depth_Attachment_Action :: struct {
    load_action : Load_Action,
    store_action : Store_Action,
    clear_value : f32,
}

Stencil_Attachment_Action :: struct {
    load_action : Load_Action,
    store_action : Store_Action,
    clear_value : u8,
}

Pass_Action :: struct {
    colors : [4]Color_Attachment_Action,
    depth : Depth_Attachment_Action,
    stencil : Stencil_Attachment_Action,
}

/*
    sg_swapchain

    Used in sg_begin_pass() to provide details about an external swapchain
    (pixel formats, sample count and backend-API specific render surface objects).

    The following information must be provided:

    - the width and height of the swapchain surfaces in number of pixels,
    - the pixel format of the render- and optional msaa-resolve-surface
    - the pixel format of the optional depth- or depth-stencil-surface
    - the MSAA sample count for the render and depth-stencil surface

    If the pixel formats and MSAA sample counts are left zero-initialized,
    their defaults are taken from the sg_environment struct provided in the
    sg_setup() call.

    The width and height *must* be > 0.

    Additionally the following backend API specific objects must be passed in
    as 'type erased' void pointers:

    GL:
        - on all GL backends, a GL framebuffer object must be provided. This
          can be zero for the default framebuffer.

    D3D11:
        - an ID3D11RenderTargetView for the rendering surface, without
          MSAA rendering this surface will also be displayed
        - an optional ID3D11DepthStencilView for the depth- or depth/stencil
          buffer surface
        - when MSAA rendering is used, another ID3D11RenderTargetView
          which serves as MSAA resolve target and will be displayed

    WebGPU (same as D3D11, except different types)
        - a WGPUTextureView for the rendering surface, without
          MSAA rendering this surface will also be displayed
        - an optional WGPUTextureView for the depth- or depth/stencil
          buffer surface
        - when MSAA rendering is used, another WGPUTextureView
          which serves as MSAA resolve target and will be displayed

    Metal (NOTE that the roles of provided surfaces is slightly different
    than on D3D11 or WebGPU in case of MSAA vs non-MSAA rendering):

        - A current CAMetalDrawable (NOT an MTLDrawable!) which will be presented.
          This will either be rendered to directly (if no MSAA is used), or serve
          as MSAA-resolve target.
        - an optional MTLTexture for the depth- or depth-stencil buffer
        - an optional multisampled MTLTexture which serves as intermediate
          rendering surface which will then be resolved into the
          CAMetalDrawable.

    NOTE that for Metal you must use an ObjC __bridge cast to
    properly tunnel the ObjC object id through a C void*, e.g.:

        swapchain.metal.current_drawable = (__bridge const void*) [mtkView currentDrawable];

    On all other backends you shouldn't need to mess with the reference count.

    It's a good practice to write a helper function which returns an initialized
    sg_swapchain structs, which can then be plugged directly into
    sg_pass.swapchain. Look at the function sglue_swapchain() in the sokol_glue.h
    as an example.
*/
Metal_Swapchain :: struct {
    current_drawable : rawptr,
    depth_stencil_texture : rawptr,
    msaa_color_texture : rawptr,
}

D3d11_Swapchain :: struct {
    render_view : rawptr,
    resolve_view : rawptr,
    depth_stencil_view : rawptr,
}

Wgpu_Swapchain :: struct {
    render_view : rawptr,
    resolve_view : rawptr,
    depth_stencil_view : rawptr,
}

Gl_Swapchain :: struct {
    framebuffer : u32,
}

Swapchain :: struct {
    width : c.int,
    height : c.int,
    sample_count : c.int,
    color_format : Pixel_Format,
    depth_format : Pixel_Format,
    metal : Metal_Swapchain,
    d3d11 : D3d11_Swapchain,
    wgpu : Wgpu_Swapchain,
    gl : Gl_Swapchain,
}

/*
    sg_pass

    The sg_pass structure is passed as argument into the sg_begin_pass()
    function.

    For an offscreen rendering pass, an sg_pass_action struct and sg_attachments
    object must be provided, and for swapchain passes, an sg_pass_action and
    an sg_swapchain struct. It is an error to provide both an sg_attachments
    handle and an initialized sg_swapchain struct in the same sg_begin_pass().

    An sg_begin_pass() call for an offscreen pass would look like this (where
    `attachments` is an sg_attachments handle):

        sg_begin_pass(&(sg_pass){
            .action = { ... },
            .attachments = attachments,
        });

    ...and a swapchain render pass would look like this (using the sokol_glue.h
    helper function sglue_swapchain() which gets the swapchain properties from
    sokol_app.h):

        sg_begin_pass(&(sg_pass){
            .action = { ... },
            .swapchain = sglue_swapchain(),
        });

    You can also omit the .action object to get default pass action behaviour
    (clear to color=grey, depth=1 and stencil=0).
*/
Pass :: struct {
    _ : u32,
    action : Pass_Action,
    attachments : Attachments,
    swapchain : Swapchain,
    label : cstring,
    _ : u32,
}

/*
    sg_bindings

    The sg_bindings structure defines the buffers, images and
    samplers resource bindings for the next draw call.

    To update the resource bindings, call sg_apply_bindings() with
    a pointer to a populated sg_bindings struct. Note that
    sg_apply_bindings() must be called after sg_apply_pipeline()
    and that bindings are not preserved across sg_apply_pipeline()
    calls, even when the new pipeline uses the same 'bindings layout'.

    A resource binding struct contains:

    - 1..N vertex buffers
    - 0..N vertex buffer offsets
    - 0..1 index buffers
    - 0..1 index buffer offsets
    - 0..N images
    - 0..N samplers
    - 0..N storage buffers

    Where 'N' is defined in the following constants:

    - SG_MAX_VERTEXBUFFER_BINDSLOTS
    - SG_MAX_IMAGE_BINDLOTS
    - SG_MAX_SAMPLER_BINDSLOTS
    - SG_MAX_STORAGEBUFFER_BINDGLOTS

    When using sokol-shdc for shader authoring, the `layout(binding=N)`
    annotation in the shader code directly maps to the slot index for that
    resource type in the bindings struct, for instance the following vertex-
    and fragment-shader interface for sokol-shdc:

        @vs vs
        layout(binding=0) uniform vs_params { ... };
        layout(binding=0) readonly buffer ssbo { ... };
        layout(binding=0) uniform texture2D vs_tex;
        layout(binding=0) uniform sampler vs_smp;
        ...
        @end

        @fs fs
        layout(binding=1) uniform fs_params { ... };
        layout(binding=1) uniform texture2D fs_tex;
        layout(binding=1) uniform sampler fs_smp;
        ...
        @end

    ...would map to the following sg_bindings struct:

        const sg_bindings bnd = {
            .vertex_buffers[0] = ...,
            .images[0] = vs_tex,
            .images[1] = fs_tex,
            .samplers[0] = vs_smp,
            .samplers[1] = fs_smp,
            .storage_buffers[0] = ssbo,
        };

    ...alternatively you can use code-generated slot indices:

        const sg_bindings bnd = {
            .vertex_buffers[0] = ...,
            .images[IMG_vs_tex] = vs_tex,
            .images[IMG_fs_tex] = fs_tex,
            .samplers[SMP_vs_smp] = vs_smp,
            .samplers[SMP_fs_smp] = fs_smp,
            .storage_buffers[SBUF_ssbo] = ssbo,
        };

    Resource bindslots for a specific shader/pipeline may have gaps, and an
    sg_bindings struct may have populated bind slots which are not used by a
    specific shader. This allows to use the same sg_bindings struct across
    different shader variants.

    When not using sokol-shdc, the bindslot indices in the sg_bindings
    struct need to match the per-resource reflection info slot indices
    in the sg_shader_desc struct (for details about that see the
    sg_shader_desc struct documentation).

    The optional buffer offsets can be used to put different unrelated
    chunks of vertex- and/or index-data into the same buffer objects.
*/
Bindings :: struct {
    _ : u32,
    vertex_buffers : [8]Buffer,
    vertex_buffer_offsets : [8]c.int,
    index_buffer : Buffer,
    index_buffer_offset : c.int,
    images : [16]Image,
    samplers : [16]Sampler,
    storage_buffers : [8]Buffer,
    _ : u32,
}

/*
    sg_buffer_desc

    Creation parameters for sg_buffer objects, used in the
    sg_make_buffer() call.

    The default configuration is:

    .size:      0       (*must* be >0 for buffers without data)
    .type:      SG_BUFFERTYPE_VERTEXBUFFER
    .usage:     SG_USAGE_IMMUTABLE
    .data.ptr   0       (*must* be valid for immutable buffers)
    .data.size  0       (*must* be > 0 for immutable buffers)
    .label      0       (optional string label)

    For immutable buffers which are initialized with initial data,
    keep the .size item zero-initialized, and set the size together with the
    pointer to the initial data in the .data item.

    For mutable buffers without initial data, keep the .data item
    zero-initialized, and set the buffer size in the .size item instead.

    You can also set both size values, but currently both size values must
    be identical (this may change in the future when the dynamic resource
    management may become more flexible).

    ADVANCED TOPIC: Injecting native 3D-API buffers:

    The following struct members allow to inject your own GL, Metal
    or D3D11 buffers into sokol_gfx:

    .gl_buffers[SG_NUM_INFLIGHT_FRAMES]
    .mtl_buffers[SG_NUM_INFLIGHT_FRAMES]
    .d3d11_buffer

    You must still provide all other struct items except the .data item, and
    these must match the creation parameters of the native buffers you
    provide. For SG_USAGE_IMMUTABLE, only provide a single native 3D-API
    buffer, otherwise you need to provide SG_NUM_INFLIGHT_FRAMES buffers
    (only for GL and Metal, not D3D11). Providing multiple buffers for GL and
    Metal is necessary because sokol_gfx will rotate through them when
    calling sg_update_buffer() to prevent lock-stalls.

    Note that it is expected that immutable injected buffer have already been
    initialized with content, and the .content member must be 0!

    Also you need to call sg_reset_state_cache() after calling native 3D-API
    functions, and before calling any sokol_gfx function.
*/
Buffer_Desc :: struct {
    _ : u32,
    size : c.size_t,
    type : Buffer_Type,
    usage : Usage,
    data : Range,
    label : cstring,
    gl_buffers : [2]u32,
    mtl_buffers : [2]rawptr,
    d3d11_buffer : rawptr,
    wgpu_buffer : rawptr,
    _ : u32,
}

/*
    sg_image_data

    Defines the content of an image through a 2D array of sg_range structs.
    The first array dimension is the cubemap face, and the second array
    dimension the mipmap level.
*/
Image_Data :: struct {
    subimage : [6][16]Range,
}

/*
    sg_image_desc

    Creation parameters for sg_image objects, used in the sg_make_image() call.

    The default configuration is:

    .type:              SG_IMAGETYPE_2D
    .render_target:     false
    .width              0 (must be set to >0)
    .height             0 (must be set to >0)
    .num_slices         1 (3D textures: depth; array textures: number of layers)
    .num_mipmaps:       1
    .usage:             SG_USAGE_IMMUTABLE
    .pixel_format:      SG_PIXELFORMAT_RGBA8 for textures, or sg_desc.environment.defaults.color_format for render targets
    .sample_count:      1 for textures, or sg_desc.environment.defaults.sample_count for render targets
    .data               an sg_image_data struct to define the initial content
    .label              0 (optional string label for trace hooks)

    Q: Why is the default sample_count for render targets identical with the
    "default sample count" from sg_desc.environment.defaults.sample_count?

    A: So that it matches the default sample count in pipeline objects. Even
    though it is a bit strange/confusing that offscreen render targets by default
    get the same sample count as 'default swapchains', but it's better that
    an offscreen render target created with default parameters matches
    a pipeline object created with default parameters.

    NOTE:

    Images with usage SG_USAGE_IMMUTABLE must be fully initialized by
    providing a valid .data member which points to initialization data.

    ADVANCED TOPIC: Injecting native 3D-API textures:

    The following struct members allow to inject your own GL, Metal or D3D11
    textures into sokol_gfx:

    .gl_textures[SG_NUM_INFLIGHT_FRAMES]
    .mtl_textures[SG_NUM_INFLIGHT_FRAMES]
    .d3d11_texture
    .d3d11_shader_resource_view
    .wgpu_texture
    .wgpu_texture_view

    For GL, you can also specify the texture target or leave it empty to use
    the default texture target for the image type (GL_TEXTURE_2D for
    SG_IMAGETYPE_2D etc)

    For D3D11 and WebGPU, either only provide a texture, or both a texture and
    shader-resource-view / texture-view object. If you want to use access the
    injected texture in a shader you *must* provide a shader-resource-view.

    The same rules apply as for injecting native buffers (see sg_buffer_desc
    documentation for more details).
*/
Image_Desc :: struct {
    _ : u32,
    type : Image_Type,
    render_target : bool,
    width : c.int,
    height : c.int,
    num_slices : c.int,
    num_mipmaps : c.int,
    usage : Usage,
    pixel_format : Pixel_Format,
    sample_count : c.int,
    data : Image_Data,
    label : cstring,
    gl_textures : [2]u32,
    gl_texture_target : u32,
    mtl_textures : [2]rawptr,
    d3d11_texture : rawptr,
    d3d11_shader_resource_view : rawptr,
    wgpu_texture : rawptr,
    wgpu_texture_view : rawptr,
    _ : u32,
}

/*
    sg_sampler_desc

    Creation parameters for sg_sampler objects, used in the sg_make_sampler() call

    .min_filter:        SG_FILTER_NEAREST
    .mag_filter:        SG_FILTER_NEAREST
    .mipmap_filter      SG_FILTER_NEAREST
    .wrap_u:            SG_WRAP_REPEAT
    .wrap_v:            SG_WRAP_REPEAT
    .wrap_w:            SG_WRAP_REPEAT (only SG_IMAGETYPE_3D)
    .min_lod            0.0f
    .max_lod            FLT_MAX
    .border_color       SG_BORDERCOLOR_OPAQUE_BLACK
    .compare            SG_COMPAREFUNC_NEVER
    .max_anisotropy     1 (must be 1..16)
*/
Sampler_Desc :: struct {
    _ : u32,
    min_filter : Filter,
    mag_filter : Filter,
    mipmap_filter : Filter,
    wrap_u : Wrap,
    wrap_v : Wrap,
    wrap_w : Wrap,
    min_lod : f32,
    max_lod : f32,
    border_color : Border_Color,
    compare : Compare_Func,
    max_anisotropy : u32,
    label : cstring,
    gl_sampler : u32,
    mtl_sampler : rawptr,
    d3d11_sampler : rawptr,
    wgpu_sampler : rawptr,
    _ : u32,
}

/*
    sg_shader_desc

    Used as parameter of sg_make_shader() to create a shader object which
    communicates shader source or bytecode and shader interface
    reflection information to sokol-gfx.

    If you use sokol-shdc you can ignore the following information since
    the sg_shader_desc struct will be code generated.

    Otherwise you need to provide the following information to the
    sg_make_shader() call:

    - a vertex- and fragment-shader function:
        - the shader source or bytecode
        - an optional entry point name
        - for D3D11: an optional compile target when source code is provided
          (the defaults are "vs_4_0" and "ps_4_0")

    - vertex attributes required by some backends:
        - for the GL backend: optional vertex attribute names
          used for name lookup
        - for the D3D11 backend: semantic names and indices

    - reflection information for each uniform block used by the shader:
        - the shader stage the uniform block appears in (SG_SHADERSTAGE_*)
        - the size in bytes of the uniform block
        - backend-specific bindslots:
            - HLSL: the constant buffer register `register(b0..7)`
            - MSL: the buffer attribute `[[buffer(0..7)]]`
            - WGSL: the binding in `@group(0) @binding(0..15)`
        - GLSL only: a description of the uniform block interior
            - the memory layout standard (SG_UNIFORMLAYOUT_*)
            - for each member in the uniform block:
                - the member type (SG_UNIFORM_*)
                - if the member is an array, the array count
                - the member name

    - reflection information for each texture used by the shader:
        - the shader stage the texture appears in (SG_SHADERSTAGE_*)
        - the image type (SG_IMAGETYPE_*)
        - the image-sample type (SG_IMAGESAMPLETYPE_*)
        - whether the texture is multisampled
        - backend specific bindslots:
            - HLSL: the texture register `register(t0..23)`
            - MSL: the texture attribute `[[texture(0..15)]]`
            - WGSL: the binding in `@group(1) @binding(0..127)`

    - reflection information for each sampler used by the shader:
        - the shader stage the sampler appears in (SG_SHADERSTAGE_*)
        - the sampler type (SG_SAMPLERTYPE_*)
        - backend specific bindslots:
            - HLSL: the sampler register `register(s0..15)`
            - MSL: the sampler attribute `[[sampler(0..15)]]`
            - WGSL: the binding in `@group(0) @binding(0..127)`

    - reflection information for each storage buffer used by the shader:
        - the shader stage the storage buffer appears in (SG_SHADERSTAGE_*)
        - whether the storage buffer is readonly (currently this must
          always be true)
        - backend specific bindslots:
            - HLSL: the texture(sic) register `register(t0..23)`
            - MSL: the buffer attribute `[[buffer(8..15)]]`
            - WGSL: the binding in `@group(1) @binding(0..127)`
            - GL: the binding in `layout(binding=0..7)`

    - reflection information for each combined image-sampler object
      used by the shader:
        - the shader stage (SG_SHADERSTAGE_*)
        - the texture's array index in the sg_shader_desc.images[] array
        - the sampler's array index in the sg_shader_desc.samplers[] array
        - GLSL only: the name of the combined image-sampler object

    The number and order of items in the sg_shader_desc.attrs[]
    array corresponds to the items in sg_pipeline_desc.layout.attrs.

        - sg_shader_desc.attrs[N] => sg_pipeline_desc.layout.attrs[N]

    NOTE that vertex attribute indices currently cannot have gaps.

    The items index in the sg_shader_desc.uniform_blocks[] array corresponds
    to the ub_slot arg in sg_apply_uniforms():

        - sg_shader_desc.uniform_blocks[N] => sg_apply_uniforms(N, ...)

    The items in the shader_desc images, samplers and storage_buffers
    arrays correspond to the same array items in the sg_bindings struct:

        - sg_shader_desc.images[N] => sg_bindings.images[N]
        - sg_shader_desc.samplers[N] => sg_bindings.samplers[N]
        - sg_shader_desc.storage_buffers[N] => sg_bindings.storage_buffers[N]

    For all GL backends, shader source-code must be provided. For D3D11 and Metal,
    either shader source-code or byte-code can be provided.

    NOTE that the uniform block, image, sampler and storage_buffer arrays
    can have gaps. This allows to use the same sg_bindings struct for
    different related shader variants.

    For D3D11, if source code is provided, the d3dcompiler_47.dll will be loaded
    on demand. If this fails, shader creation will fail. When compiling HLSL
    source code, you can provide an optional target string via
    sg_shader_stage_desc.d3d11_target, the default target is "vs_4_0" for the
    vertex shader stage and "ps_4_0" for the pixel shader stage.
*/
Shader_Stage :: enum i32 {
    NONE,
    VERTEX,
    FRAGMENT,
}

Shader_Function :: struct {
    source : cstring,
    bytecode : Range,
    entry : cstring,
    d3d11_target : cstring,
}

Shader_Vertex_Attr :: struct {
    glsl_name : cstring,
    hlsl_sem_name : cstring,
    hlsl_sem_index : u8,
}

Glsl_Shader_Uniform :: struct {
    type : Uniform_Type,
    array_count : u16,
    glsl_name : cstring,
}

Shader_Uniform_Block :: struct {
    stage : Shader_Stage,
    size : u32,
    hlsl_register_b_n : u8,
    msl_buffer_n : u8,
    wgsl_group0_binding_n : u8,
    layout : Uniform_Layout,
    glsl_uniforms : [16]Glsl_Shader_Uniform,
}

Shader_Image :: struct {
    stage : Shader_Stage,
    image_type : Image_Type,
    sample_type : Image_Sample_Type,
    multisampled : bool,
    hlsl_register_t_n : u8,
    msl_texture_n : u8,
    wgsl_group1_binding_n : u8,
}

Shader_Sampler :: struct {
    stage : Shader_Stage,
    sampler_type : Sampler_Type,
    hlsl_register_s_n : u8,
    msl_sampler_n : u8,
    wgsl_group1_binding_n : u8,
}

Shader_Storage_Buffer :: struct {
    stage : Shader_Stage,
    readonly : bool,
    hlsl_register_t_n : u8,
    msl_buffer_n : u8,
    wgsl_group1_binding_n : u8,
    glsl_binding_n : u8,
}

Shader_Image_Sampler_Pair :: struct {
    stage : Shader_Stage,
    image_slot : u8,
    sampler_slot : u8,
    glsl_name : cstring,
}

Shader_Desc :: struct {
    _ : u32,
    vertex_func : Shader_Function,
    fragment_func : Shader_Function,
    attrs : [16]Shader_Vertex_Attr,
    uniform_blocks : [8]Shader_Uniform_Block,
    storage_buffers : [8]Shader_Storage_Buffer,
    images : [16]Shader_Image,
    samplers : [16]Shader_Sampler,
    image_sampler_pairs : [16]Shader_Image_Sampler_Pair,
    label : cstring,
    _ : u32,
}

/*
    sg_pipeline_desc

    The sg_pipeline_desc struct defines all creation parameters for an
    sg_pipeline object, used as argument to the sg_make_pipeline() function:

    - the vertex layout for all input vertex buffers
    - a shader object
    - the 3D primitive type (points, lines, triangles, ...)
    - the index type (none, 16- or 32-bit)
    - all the fixed-function-pipeline state (depth-, stencil-, blend-state, etc...)

    If the vertex data has no gaps between vertex components, you can omit
    the .layout.buffers[].stride and layout.attrs[].offset items (leave them
    default-initialized to 0), sokol-gfx will then compute the offsets and
    strides from the vertex component formats (.layout.attrs[].format).
    Please note that ALL vertex attribute offsets must be 0 in order for the
    automatic offset computation to kick in.

    The default configuration is as follows:

    .shader:                0 (must be initialized with a valid sg_shader id!)
    .layout:
        .buffers[]:         vertex buffer layouts
            .stride:        0 (if no stride is given it will be computed)
            .step_func      SG_VERTEXSTEP_PER_VERTEX
            .step_rate      1
        .attrs[]:           vertex attribute declarations
            .buffer_index   0 the vertex buffer bind slot
            .offset         0 (offsets can be omitted if the vertex layout has no gaps)
            .format         SG_VERTEXFORMAT_INVALID (must be initialized!)
    .depth:
        .pixel_format:      sg_desc.context.depth_format
        .compare:           SG_COMPAREFUNC_ALWAYS
        .write_enabled:     false
        .bias:              0.0f
        .bias_slope_scale:  0.0f
        .bias_clamp:        0.0f
    .stencil:
        .enabled:           false
        .front/back:
            .compare:       SG_COMPAREFUNC_ALWAYS
            .fail_op:       SG_STENCILOP_KEEP
            .depth_fail_op: SG_STENCILOP_KEEP
            .pass_op:       SG_STENCILOP_KEEP
        .read_mask:         0
        .write_mask:        0
        .ref:               0
    .color_count            1
    .colors[0..color_count]
        .pixel_format       sg_desc.context.color_format
        .write_mask:        SG_COLORMASK_RGBA
        .blend:
            .enabled:           false
            .src_factor_rgb:    SG_BLENDFACTOR_ONE
            .dst_factor_rgb:    SG_BLENDFACTOR_ZERO
            .op_rgb:            SG_BLENDOP_ADD
            .src_factor_alpha:  SG_BLENDFACTOR_ONE
            .dst_factor_alpha:  SG_BLENDFACTOR_ZERO
            .op_alpha:          SG_BLENDOP_ADD
    .primitive_type:            SG_PRIMITIVETYPE_TRIANGLES
    .index_type:                SG_INDEXTYPE_NONE
    .cull_mode:                 SG_CULLMODE_NONE
    .face_winding:              SG_FACEWINDING_CW
    .sample_count:              sg_desc.context.sample_count
    .blend_color:               (sg_color) { 0.0f, 0.0f, 0.0f, 0.0f }
    .alpha_to_coverage_enabled: false
    .label  0       (optional string label for trace hooks)
*/
Vertex_Buffer_Layout_State :: struct {
    stride : c.int,
    step_func : Vertex_Step,
    step_rate : c.int,
}

Vertex_Attr_State :: struct {
    buffer_index : c.int,
    offset : c.int,
    format : Vertex_Format,
}

Vertex_Layout_State :: struct {
    buffers : [8]Vertex_Buffer_Layout_State,
    attrs : [16]Vertex_Attr_State,
}

Stencil_Face_State :: struct {
    compare : Compare_Func,
    fail_op : Stencil_Op,
    depth_fail_op : Stencil_Op,
    pass_op : Stencil_Op,
}

Stencil_State :: struct {
    enabled : bool,
    front : Stencil_Face_State,
    back : Stencil_Face_State,
    read_mask : u8,
    write_mask : u8,
    ref : u8,
}

Depth_State :: struct {
    pixel_format : Pixel_Format,
    compare : Compare_Func,
    write_enabled : bool,
    bias : f32,
    bias_slope_scale : f32,
    bias_clamp : f32,
}

Blend_State :: struct {
    enabled : bool,
    src_factor_rgb : Blend_Factor,
    dst_factor_rgb : Blend_Factor,
    op_rgb : Blend_Op,
    src_factor_alpha : Blend_Factor,
    dst_factor_alpha : Blend_Factor,
    op_alpha : Blend_Op,
}

Color_Target_State :: struct {
    pixel_format : Pixel_Format,
    write_mask : Color_Mask,
    blend : Blend_State,
}

Pipeline_Desc :: struct {
    _ : u32,
    shader : Shader,
    layout : Vertex_Layout_State,
    depth : Depth_State,
    stencil : Stencil_State,
    color_count : c.int,
    colors : [4]Color_Target_State,
    primitive_type : Primitive_Type,
    index_type : Index_Type,
    cull_mode : Cull_Mode,
    face_winding : Face_Winding,
    sample_count : c.int,
    blend_color : Color,
    alpha_to_coverage_enabled : bool,
    label : cstring,
    _ : u32,
}

/*
    sg_attachments_desc

    Creation parameters for an sg_attachments object, used as argument to the
    sg_make_attachments() function.

    An attachments object bundles 0..4 color attachments, 0..4 msaa-resolve
    attachments, and none or one depth-stencil attachmente for use
    in a render pass. At least one color attachment or one depth-stencil
    attachment must be provided (no color attachment and a depth-stencil
    attachment is useful for a depth-only render pass).

    Each attachment definition consists of an image object, and two additional indices
    describing which subimage the pass will render into: one mipmap index, and if the image
    is a cubemap, array-texture or 3D-texture, the face-index, array-layer or
    depth-slice.

    All attachments must have the same width and height.

    All color attachments and the depth-stencil attachment must have the
    same sample count.

    If a resolve attachment is set, an MSAA-resolve operation from the
    associated color attachment image into the resolve attachment image will take
    place in the sg_end_pass() function. In this case, the color attachment
    must have a (sample_count>1), and the resolve attachment a
    (sample_count==1). The resolve attachment also must have the same pixel
    format as the color attachment.

    NOTE that MSAA depth-stencil attachments cannot be msaa-resolved!
*/
Attachment_Desc :: struct {
    image : Image,
    mip_level : c.int,
    slice : c.int,
}

Attachments_Desc :: struct {
    _ : u32,
    colors : [4]Attachment_Desc,
    resolves : [4]Attachment_Desc,
    depth_stencil : Attachment_Desc,
    label : cstring,
    _ : u32,
}

/*
    sg_buffer_info
    sg_image_info
    sg_sampler_info
    sg_shader_info
    sg_pipeline_info
    sg_attachments_info

    These structs contain various internal resource attributes which
    might be useful for debug-inspection. Please don't rely on the
    actual content of those structs too much, as they are quite closely
    tied to sokol_gfx.h internals and may change more frequently than
    the other public API elements.

    The *_info structs are used as the return values of the following functions:

    sg_query_buffer_info()
    sg_query_image_info()
    sg_query_sampler_info()
    sg_query_shader_info()
    sg_query_pipeline_info()
    sg_query_pass_info()
*/
Slot_Info :: struct {
    state : Resource_State,
    res_id : u32,
}

Buffer_Info :: struct {
    slot : Slot_Info,
    update_frame_index : u32,
    append_frame_index : u32,
    append_pos : c.int,
    append_overflow : bool,
    num_slots : c.int,
    active_slot : c.int,
}

Image_Info :: struct {
    slot : Slot_Info,
    upd_frame_index : u32,
    num_slots : c.int,
    active_slot : c.int,
}

Sampler_Info :: struct {
    slot : Slot_Info,
}

Shader_Info :: struct {
    slot : Slot_Info,
}

Pipeline_Info :: struct {
    slot : Slot_Info,
}

Attachments_Info :: struct {
    slot : Slot_Info,
}

/*
    sg_frame_stats

    Allows to track generic and backend-specific stats about a
    render frame. Obtained by calling sg_query_frame_stats(). The returned
    struct contains information about the *previous* frame.
*/
Frame_Stats_Gl :: struct {
    num_bind_buffer : u32,
    num_active_texture : u32,
    num_bind_texture : u32,
    num_bind_sampler : u32,
    num_use_program : u32,
    num_render_state : u32,
    num_vertex_attrib_pointer : u32,
    num_vertex_attrib_divisor : u32,
    num_enable_vertex_attrib_array : u32,
    num_disable_vertex_attrib_array : u32,
    num_uniform : u32,
}

Frame_Stats_D3d11_Pass :: struct {
    num_om_set_render_targets : u32,
    num_clear_render_target_view : u32,
    num_clear_depth_stencil_view : u32,
    num_resolve_subresource : u32,
}

Frame_Stats_D3d11_Pipeline :: struct {
    num_rs_set_state : u32,
    num_om_set_depth_stencil_state : u32,
    num_om_set_blend_state : u32,
    num_ia_set_primitive_topology : u32,
    num_ia_set_input_layout : u32,
    num_vs_set_shader : u32,
    num_vs_set_constant_buffers : u32,
    num_ps_set_shader : u32,
    num_ps_set_constant_buffers : u32,
}

Frame_Stats_D3d11_Bindings :: struct {
    num_ia_set_vertex_buffers : u32,
    num_ia_set_index_buffer : u32,
    num_vs_set_shader_resources : u32,
    num_ps_set_shader_resources : u32,
    num_vs_set_samplers : u32,
    num_ps_set_samplers : u32,
}

Frame_Stats_D3d11_Uniforms :: struct {
    num_update_subresource : u32,
}

Frame_Stats_D3d11_Draw :: struct {
    num_draw_indexed_instanced : u32,
    num_draw_indexed : u32,
    num_draw_instanced : u32,
    num_draw : u32,
}

Frame_Stats_D3d11 :: struct {
    pass : Frame_Stats_D3d11_Pass,
    pipeline : Frame_Stats_D3d11_Pipeline,
    bindings : Frame_Stats_D3d11_Bindings,
    uniforms : Frame_Stats_D3d11_Uniforms,
    draw : Frame_Stats_D3d11_Draw,
    num_map : u32,
    num_unmap : u32,
}

Frame_Stats_Metal_Idpool :: struct {
    num_added : u32,
    num_released : u32,
    num_garbage_collected : u32,
}

Frame_Stats_Metal_Pipeline :: struct {
    num_set_blend_color : u32,
    num_set_cull_mode : u32,
    num_set_front_facing_winding : u32,
    num_set_stencil_reference_value : u32,
    num_set_depth_bias : u32,
    num_set_render_pipeline_state : u32,
    num_set_depth_stencil_state : u32,
}

Frame_Stats_Metal_Bindings :: struct {
    num_set_vertex_buffer : u32,
    num_set_vertex_texture : u32,
    num_set_vertex_sampler_state : u32,
    num_set_fragment_buffer : u32,
    num_set_fragment_texture : u32,
    num_set_fragment_sampler_state : u32,
}

Frame_Stats_Metal_Uniforms :: struct {
    num_set_vertex_buffer_offset : u32,
    num_set_fragment_buffer_offset : u32,
}

Frame_Stats_Metal :: struct {
    idpool : Frame_Stats_Metal_Idpool,
    pipeline : Frame_Stats_Metal_Pipeline,
    bindings : Frame_Stats_Metal_Bindings,
    uniforms : Frame_Stats_Metal_Uniforms,
}

Frame_Stats_Wgpu_Uniforms :: struct {
    num_set_bindgroup : u32,
    size_write_buffer : u32,
}

Frame_Stats_Wgpu_Bindings :: struct {
    num_set_vertex_buffer : u32,
    num_skip_redundant_vertex_buffer : u32,
    num_set_index_buffer : u32,
    num_skip_redundant_index_buffer : u32,
    num_create_bindgroup : u32,
    num_discard_bindgroup : u32,
    num_set_bindgroup : u32,
    num_skip_redundant_bindgroup : u32,
    num_bindgroup_cache_hits : u32,
    num_bindgroup_cache_misses : u32,
    num_bindgroup_cache_collisions : u32,
    num_bindgroup_cache_invalidates : u32,
    num_bindgroup_cache_hash_vs_key_mismatch : u32,
}

Frame_Stats_Wgpu :: struct {
    uniforms : Frame_Stats_Wgpu_Uniforms,
    bindings : Frame_Stats_Wgpu_Bindings,
}

Frame_Stats :: struct {
    frame_index : u32,
    num_passes : u32,
    num_apply_viewport : u32,
    num_apply_scissor_rect : u32,
    num_apply_pipeline : u32,
    num_apply_bindings : u32,
    num_apply_uniforms : u32,
    num_draw : u32,
    num_update_buffer : u32,
    num_append_buffer : u32,
    num_update_image : u32,
    size_apply_uniforms : u32,
    size_update_buffer : u32,
    size_append_buffer : u32,
    size_update_image : u32,
    gl : Frame_Stats_Gl,
    d3d11 : Frame_Stats_D3d11,
    metal : Frame_Stats_Metal,
    wgpu : Frame_Stats_Wgpu,
}

Log_Item :: enum i32 {
    OK,
    MALLOC_FAILED,
    GL_TEXTURE_FORMAT_NOT_SUPPORTED,
    GL_3D_TEXTURES_NOT_SUPPORTED,
    GL_ARRAY_TEXTURES_NOT_SUPPORTED,
    GL_STORAGEBUFFER_GLSL_BINDING_OUT_OF_RANGE,
    GL_SHADER_COMPILATION_FAILED,
    GL_SHADER_LINKING_FAILED,
    GL_VERTEX_ATTRIBUTE_NOT_FOUND_IN_SHADER,
    GL_UNIFORMBLOCK_NAME_NOT_FOUND_IN_SHADER,
    GL_IMAGE_SAMPLER_NAME_NOT_FOUND_IN_SHADER,
    GL_FRAMEBUFFER_STATUS_UNDEFINED,
    GL_FRAMEBUFFER_STATUS_INCOMPLETE_ATTACHMENT,
    GL_FRAMEBUFFER_STATUS_INCOMPLETE_MISSING_ATTACHMENT,
    GL_FRAMEBUFFER_STATUS_UNSUPPORTED,
    GL_FRAMEBUFFER_STATUS_INCOMPLETE_MULTISAMPLE,
    GL_FRAMEBUFFER_STATUS_UNKNOWN,
    D3D11_CREATE_BUFFER_FAILED,
    D3D11_CREATE_BUFFER_SRV_FAILED,
    D3D11_CREATE_DEPTH_TEXTURE_UNSUPPORTED_PIXEL_FORMAT,
    D3D11_CREATE_DEPTH_TEXTURE_FAILED,
    D3D11_CREATE_2D_TEXTURE_UNSUPPORTED_PIXEL_FORMAT,
    D3D11_CREATE_2D_TEXTURE_FAILED,
    D3D11_CREATE_2D_SRV_FAILED,
    D3D11_CREATE_3D_TEXTURE_UNSUPPORTED_PIXEL_FORMAT,
    D3D11_CREATE_3D_TEXTURE_FAILED,
    D3D11_CREATE_3D_SRV_FAILED,
    D3D11_CREATE_MSAA_TEXTURE_FAILED,
    D3D11_CREATE_SAMPLER_STATE_FAILED,
    D3D11_UNIFORMBLOCK_HLSL_REGISTER_B_OUT_OF_RANGE,
    D3D11_STORAGEBUFFER_HLSL_REGISTER_T_OUT_OF_RANGE,
    D3D11_IMAGE_HLSL_REGISTER_T_OUT_OF_RANGE,
    D3D11_SAMPLER_HLSL_REGISTER_S_OUT_OF_RANGE,
    D3D11_LOAD_D3DCOMPILER_47_DLL_FAILED,
    D3D11_SHADER_COMPILATION_FAILED,
    D3D11_SHADER_COMPILATION_OUTPUT,
    D3D11_CREATE_CONSTANT_BUFFER_FAILED,
    D3D11_CREATE_INPUT_LAYOUT_FAILED,
    D3D11_CREATE_RASTERIZER_STATE_FAILED,
    D3D11_CREATE_DEPTH_STENCIL_STATE_FAILED,
    D3D11_CREATE_BLEND_STATE_FAILED,
    D3D11_CREATE_RTV_FAILED,
    D3D11_CREATE_DSV_FAILED,
    D3D11_MAP_FOR_UPDATE_BUFFER_FAILED,
    D3D11_MAP_FOR_APPEND_BUFFER_FAILED,
    D3D11_MAP_FOR_UPDATE_IMAGE_FAILED,
    METAL_CREATE_BUFFER_FAILED,
    METAL_TEXTURE_FORMAT_NOT_SUPPORTED,
    METAL_CREATE_TEXTURE_FAILED,
    METAL_CREATE_SAMPLER_FAILED,
    METAL_SHADER_COMPILATION_FAILED,
    METAL_SHADER_CREATION_FAILED,
    METAL_SHADER_COMPILATION_OUTPUT,
    METAL_SHADER_ENTRY_NOT_FOUND,
    METAL_UNIFORMBLOCK_MSL_BUFFER_SLOT_OUT_OF_RANGE,
    METAL_STORAGEBUFFER_MSL_BUFFER_SLOT_OUT_OF_RANGE,
    METAL_IMAGE_MSL_TEXTURE_SLOT_OUT_OF_RANGE,
    METAL_SAMPLER_MSL_SAMPLER_SLOT_OUT_OF_RANGE,
    METAL_CREATE_RPS_FAILED,
    METAL_CREATE_RPS_OUTPUT,
    METAL_CREATE_DSS_FAILED,
    WGPU_BINDGROUPS_POOL_EXHAUSTED,
    WGPU_BINDGROUPSCACHE_SIZE_GREATER_ONE,
    WGPU_BINDGROUPSCACHE_SIZE_POW2,
    WGPU_CREATEBINDGROUP_FAILED,
    WGPU_CREATE_BUFFER_FAILED,
    WGPU_CREATE_TEXTURE_FAILED,
    WGPU_CREATE_TEXTURE_VIEW_FAILED,
    WGPU_CREATE_SAMPLER_FAILED,
    WGPU_CREATE_SHADER_MODULE_FAILED,
    WGPU_SHADER_CREATE_BINDGROUP_LAYOUT_FAILED,
    WGPU_UNIFORMBLOCK_WGSL_GROUP0_BINDING_OUT_OF_RANGE,
    WGPU_STORAGEBUFFER_WGSL_GROUP1_BINDING_OUT_OF_RANGE,
    WGPU_IMAGE_WGSL_GROUP1_BINDING_OUT_OF_RANGE,
    WGPU_SAMPLER_WGSL_GROUP1_BINDING_OUT_OF_RANGE,
    WGPU_CREATE_PIPELINE_LAYOUT_FAILED,
    WGPU_CREATE_RENDER_PIPELINE_FAILED,
    WGPU_ATTACHMENTS_CREATE_TEXTURE_VIEW_FAILED,
    DRAW_REQUIRED_BINDINGS_OR_UNIFORMS_MISSING,
    IDENTICAL_COMMIT_LISTENER,
    COMMIT_LISTENER_ARRAY_FULL,
    TRACE_HOOKS_NOT_ENABLED,
    DEALLOC_BUFFER_INVALID_STATE,
    DEALLOC_IMAGE_INVALID_STATE,
    DEALLOC_SAMPLER_INVALID_STATE,
    DEALLOC_SHADER_INVALID_STATE,
    DEALLOC_PIPELINE_INVALID_STATE,
    DEALLOC_ATTACHMENTS_INVALID_STATE,
    INIT_BUFFER_INVALID_STATE,
    INIT_IMAGE_INVALID_STATE,
    INIT_SAMPLER_INVALID_STATE,
    INIT_SHADER_INVALID_STATE,
    INIT_PIPELINE_INVALID_STATE,
    INIT_ATTACHMENTS_INVALID_STATE,
    UNINIT_BUFFER_INVALID_STATE,
    UNINIT_IMAGE_INVALID_STATE,
    UNINIT_SAMPLER_INVALID_STATE,
    UNINIT_SHADER_INVALID_STATE,
    UNINIT_PIPELINE_INVALID_STATE,
    UNINIT_ATTACHMENTS_INVALID_STATE,
    FAIL_BUFFER_INVALID_STATE,
    FAIL_IMAGE_INVALID_STATE,
    FAIL_SAMPLER_INVALID_STATE,
    FAIL_SHADER_INVALID_STATE,
    FAIL_PIPELINE_INVALID_STATE,
    FAIL_ATTACHMENTS_INVALID_STATE,
    BUFFER_POOL_EXHAUSTED,
    IMAGE_POOL_EXHAUSTED,
    SAMPLER_POOL_EXHAUSTED,
    SHADER_POOL_EXHAUSTED,
    PIPELINE_POOL_EXHAUSTED,
    PASS_POOL_EXHAUSTED,
    BEGINPASS_ATTACHMENT_INVALID,
    DRAW_WITHOUT_BINDINGS,
    VALIDATE_BUFFERDESC_CANARY,
    VALIDATE_BUFFERDESC_SIZE,
    VALIDATE_BUFFERDESC_DATA,
    VALIDATE_BUFFERDESC_DATA_SIZE,
    VALIDATE_BUFFERDESC_NO_DATA,
    VALIDATE_BUFFERDESC_STORAGEBUFFER_SUPPORTED,
    VALIDATE_BUFFERDESC_STORAGEBUFFER_SIZE_MULTIPLE_4,
    VALIDATE_IMAGEDATA_NODATA,
    VALIDATE_IMAGEDATA_DATA_SIZE,
    VALIDATE_IMAGEDESC_CANARY,
    VALIDATE_IMAGEDESC_WIDTH,
    VALIDATE_IMAGEDESC_HEIGHT,
    VALIDATE_IMAGEDESC_RT_PIXELFORMAT,
    VALIDATE_IMAGEDESC_NONRT_PIXELFORMAT,
    VALIDATE_IMAGEDESC_MSAA_BUT_NO_RT,
    VALIDATE_IMAGEDESC_NO_MSAA_RT_SUPPORT,
    VALIDATE_IMAGEDESC_MSAA_NUM_MIPMAPS,
    VALIDATE_IMAGEDESC_MSAA_3D_IMAGE,
    VALIDATE_IMAGEDESC_MSAA_CUBE_IMAGE,
    VALIDATE_IMAGEDESC_DEPTH_3D_IMAGE,
    VALIDATE_IMAGEDESC_RT_IMMUTABLE,
    VALIDATE_IMAGEDESC_RT_NO_DATA,
    VALIDATE_IMAGEDESC_INJECTED_NO_DATA,
    VALIDATE_IMAGEDESC_DYNAMIC_NO_DATA,
    VALIDATE_IMAGEDESC_COMPRESSED_IMMUTABLE,
    VALIDATE_SAMPLERDESC_CANARY,
    VALIDATE_SAMPLERDESC_ANISTROPIC_REQUIRES_LINEAR_FILTERING,
    VALIDATE_SHADERDESC_CANARY,
    VALIDATE_SHADERDESC_SOURCE,
    VALIDATE_SHADERDESC_BYTECODE,
    VALIDATE_SHADERDESC_SOURCE_OR_BYTECODE,
    VALIDATE_SHADERDESC_NO_BYTECODE_SIZE,
    VALIDATE_SHADERDESC_UNIFORMBLOCK_NO_CONT_MEMBERS,
    VALIDATE_SHADERDESC_UNIFORMBLOCK_SIZE_IS_ZERO,
    VALIDATE_SHADERDESC_UNIFORMBLOCK_METAL_BUFFER_SLOT_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_UNIFORMBLOCK_METAL_BUFFER_SLOT_COLLISION,
    VALIDATE_SHADERDESC_UNIFORMBLOCK_HLSL_REGISTER_B_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_UNIFORMBLOCK_HLSL_REGISTER_B_COLLISION,
    VALIDATE_SHADERDESC_UNIFORMBLOCK_WGSL_GROUP0_BINDING_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_UNIFORMBLOCK_WGSL_GROUP0_BINDING_COLLISION,
    VALIDATE_SHADERDESC_UNIFORMBLOCK_NO_MEMBERS,
    VALIDATE_SHADERDESC_UNIFORMBLOCK_UNIFORM_GLSL_NAME,
    VALIDATE_SHADERDESC_UNIFORMBLOCK_SIZE_MISMATCH,
    VALIDATE_SHADERDESC_UNIFORMBLOCK_ARRAY_COUNT,
    VALIDATE_SHADERDESC_UNIFORMBLOCK_STD140_ARRAY_TYPE,
    VALIDATE_SHADERDESC_STORAGEBUFFER_METAL_BUFFER_SLOT_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_STORAGEBUFFER_METAL_BUFFER_SLOT_COLLISION,
    VALIDATE_SHADERDESC_STORAGEBUFFER_HLSL_REGISTER_T_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_STORAGEBUFFER_HLSL_REGISTER_T_COLLISION,
    VALIDATE_SHADERDESC_STORAGEBUFFER_GLSL_BINDING_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_STORAGEBUFFER_GLSL_BINDING_COLLISION,
    VALIDATE_SHADERDESC_STORAGEBUFFER_WGSL_GROUP1_BINDING_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_STORAGEBUFFER_WGSL_GROUP1_BINDING_COLLISION,
    VALIDATE_SHADERDESC_STORAGEBUFFER_READONLY,
    VALIDATE_SHADERDESC_IMAGE_METAL_TEXTURE_SLOT_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_IMAGE_METAL_TEXTURE_SLOT_COLLISION,
    VALIDATE_SHADERDESC_IMAGE_HLSL_REGISTER_T_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_IMAGE_HLSL_REGISTER_T_COLLISION,
    VALIDATE_SHADERDESC_IMAGE_WGSL_GROUP1_BINDING_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_IMAGE_WGSL_GROUP1_BINDING_COLLISION,
    VALIDATE_SHADERDESC_SAMPLER_METAL_SAMPLER_SLOT_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_SAMPLER_METAL_SAMPLER_SLOT_COLLISION,
    VALIDATE_SHADERDESC_SAMPLER_HLSL_REGISTER_S_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_SAMPLER_HLSL_REGISTER_S_COLLISION,
    VALIDATE_SHADERDESC_SAMPLER_WGSL_GROUP1_BINDING_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_SAMPLER_WGSL_GROUP1_BINDING_COLLISION,
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_IMAGE_SLOT_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_SAMPLER_SLOT_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_IMAGE_STAGE_MISMATCH,
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_SAMPLER_STAGE_MISMATCH,
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_GLSL_NAME,
    VALIDATE_SHADERDESC_NONFILTERING_SAMPLER_REQUIRED,
    VALIDATE_SHADERDESC_COMPARISON_SAMPLER_REQUIRED,
    VALIDATE_SHADERDESC_IMAGE_NOT_REFERENCED_BY_IMAGE_SAMPLER_PAIRS,
    VALIDATE_SHADERDESC_SAMPLER_NOT_REFERENCED_BY_IMAGE_SAMPLER_PAIRS,
    VALIDATE_SHADERDESC_ATTR_STRING_TOO_LONG,
    VALIDATE_PIPELINEDESC_CANARY,
    VALIDATE_PIPELINEDESC_SHADER,
    VALIDATE_PIPELINEDESC_NO_CONT_ATTRS,
    VALIDATE_PIPELINEDESC_LAYOUT_STRIDE4,
    VALIDATE_PIPELINEDESC_ATTR_SEMANTICS,
    VALIDATE_ATTACHMENTSDESC_CANARY,
    VALIDATE_ATTACHMENTSDESC_NO_ATTACHMENTS,
    VALIDATE_ATTACHMENTSDESC_NO_CONT_COLOR_ATTS,
    VALIDATE_ATTACHMENTSDESC_IMAGE,
    VALIDATE_ATTACHMENTSDESC_MIPLEVEL,
    VALIDATE_ATTACHMENTSDESC_FACE,
    VALIDATE_ATTACHMENTSDESC_LAYER,
    VALIDATE_ATTACHMENTSDESC_SLICE,
    VALIDATE_ATTACHMENTSDESC_IMAGE_NO_RT,
    VALIDATE_ATTACHMENTSDESC_COLOR_INV_PIXELFORMAT,
    VALIDATE_ATTACHMENTSDESC_DEPTH_INV_PIXELFORMAT,
    VALIDATE_ATTACHMENTSDESC_IMAGE_SIZES,
    VALIDATE_ATTACHMENTSDESC_IMAGE_SAMPLE_COUNTS,
    VALIDATE_ATTACHMENTSDESC_RESOLVE_COLOR_IMAGE_MSAA,
    VALIDATE_ATTACHMENTSDESC_RESOLVE_IMAGE,
    VALIDATE_ATTACHMENTSDESC_RESOLVE_SAMPLE_COUNT,
    VALIDATE_ATTACHMENTSDESC_RESOLVE_MIPLEVEL,
    VALIDATE_ATTACHMENTSDESC_RESOLVE_FACE,
    VALIDATE_ATTACHMENTSDESC_RESOLVE_LAYER,
    VALIDATE_ATTACHMENTSDESC_RESOLVE_SLICE,
    VALIDATE_ATTACHMENTSDESC_RESOLVE_IMAGE_NO_RT,
    VALIDATE_ATTACHMENTSDESC_RESOLVE_IMAGE_SIZES,
    VALIDATE_ATTACHMENTSDESC_RESOLVE_IMAGE_FORMAT,
    VALIDATE_ATTACHMENTSDESC_DEPTH_IMAGE,
    VALIDATE_ATTACHMENTSDESC_DEPTH_MIPLEVEL,
    VALIDATE_ATTACHMENTSDESC_DEPTH_FACE,
    VALIDATE_ATTACHMENTSDESC_DEPTH_LAYER,
    VALIDATE_ATTACHMENTSDESC_DEPTH_SLICE,
    VALIDATE_ATTACHMENTSDESC_DEPTH_IMAGE_NO_RT,
    VALIDATE_ATTACHMENTSDESC_DEPTH_IMAGE_SIZES,
    VALIDATE_ATTACHMENTSDESC_DEPTH_IMAGE_SAMPLE_COUNT,
    VALIDATE_BEGINPASS_CANARY,
    VALIDATE_BEGINPASS_ATTACHMENTS_EXISTS,
    VALIDATE_BEGINPASS_ATTACHMENTS_VALID,
    VALIDATE_BEGINPASS_COLOR_ATTACHMENT_IMAGE,
    VALIDATE_BEGINPASS_RESOLVE_ATTACHMENT_IMAGE,
    VALIDATE_BEGINPASS_DEPTHSTENCIL_ATTACHMENT_IMAGE,
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_WIDTH,
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_WIDTH_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_HEIGHT,
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_HEIGHT_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_SAMPLECOUNT,
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_SAMPLECOUNT_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_COLORFORMAT,
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_COLORFORMAT_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_DEPTHFORMAT_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_CURRENTDRAWABLE,
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_CURRENTDRAWABLE_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_DEPTHSTENCILTEXTURE,
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_DEPTHSTENCILTEXTURE_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_MSAACOLORTEXTURE,
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_MSAACOLORTEXTURE_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_RENDERVIEW,
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_RENDERVIEW_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_RESOLVEVIEW,
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_RESOLVEVIEW_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_DEPTHSTENCILVIEW,
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_DEPTHSTENCILVIEW_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_RENDERVIEW,
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_RENDERVIEW_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_RESOLVEVIEW,
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_RESOLVEVIEW_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_DEPTHSTENCILVIEW,
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_DEPTHSTENCILVIEW_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_GL_EXPECT_FRAMEBUFFER_NOTSET,
    VALIDATE_APIP_PIPELINE_VALID_ID,
    VALIDATE_APIP_PIPELINE_EXISTS,
    VALIDATE_APIP_PIPELINE_VALID,
    VALIDATE_APIP_SHADER_EXISTS,
    VALIDATE_APIP_SHADER_VALID,
    VALIDATE_APIP_CURPASS_ATTACHMENTS_EXISTS,
    VALIDATE_APIP_CURPASS_ATTACHMENTS_VALID,
    VALIDATE_APIP_ATT_COUNT,
    VALIDATE_APIP_COLOR_FORMAT,
    VALIDATE_APIP_DEPTH_FORMAT,
    VALIDATE_APIP_SAMPLE_COUNT,
    VALIDATE_ABND_PIPELINE,
    VALIDATE_ABND_PIPELINE_EXISTS,
    VALIDATE_ABND_PIPELINE_VALID,
    VALIDATE_ABND_EXPECTED_VB,
    VALIDATE_ABND_VB_EXISTS,
    VALIDATE_ABND_VB_TYPE,
    VALIDATE_ABND_VB_OVERFLOW,
    VALIDATE_ABND_NO_IB,
    VALIDATE_ABND_IB,
    VALIDATE_ABND_IB_EXISTS,
    VALIDATE_ABND_IB_TYPE,
    VALIDATE_ABND_IB_OVERFLOW,
    VALIDATE_ABND_EXPECTED_IMAGE_BINDING,
    VALIDATE_ABND_IMG_EXISTS,
    VALIDATE_ABND_IMAGE_TYPE_MISMATCH,
    VALIDATE_ABND_EXPECTED_MULTISAMPLED_IMAGE,
    VALIDATE_ABND_IMAGE_MSAA,
    VALIDATE_ABND_EXPECTED_FILTERABLE_IMAGE,
    VALIDATE_ABND_EXPECTED_DEPTH_IMAGE,
    VALIDATE_ABND_EXPECTED_SAMPLER_BINDING,
    VALIDATE_ABND_UNEXPECTED_SAMPLER_COMPARE_NEVER,
    VALIDATE_ABND_EXPECTED_SAMPLER_COMPARE_NEVER,
    VALIDATE_ABND_EXPECTED_NONFILTERING_SAMPLER,
    VALIDATE_ABND_SMP_EXISTS,
    VALIDATE_ABND_EXPECTED_STORAGEBUFFER_BINDING,
    VALIDATE_ABND_STORAGEBUFFER_EXISTS,
    VALIDATE_ABND_STORAGEBUFFER_BINDING_BUFFERTYPE,
    VALIDATE_AUB_NO_PIPELINE,
    VALIDATE_AUB_NO_UNIFORMBLOCK_AT_SLOT,
    VALIDATE_AUB_SIZE,
    VALIDATE_UPDATEBUF_USAGE,
    VALIDATE_UPDATEBUF_SIZE,
    VALIDATE_UPDATEBUF_ONCE,
    VALIDATE_UPDATEBUF_APPEND,
    VALIDATE_APPENDBUF_USAGE,
    VALIDATE_APPENDBUF_SIZE,
    VALIDATE_APPENDBUF_UPDATE,
    VALIDATE_UPDIMG_USAGE,
    VALIDATE_UPDIMG_ONCE,
    VALIDATION_FAILED,
}

/*
    sg_desc

    The sg_desc struct contains configuration values for sokol_gfx,
    it is used as parameter to the sg_setup() call.

    The default configuration is:

    .buffer_pool_size       128
    .image_pool_size        128
    .sampler_pool_size      64
    .shader_pool_size       32
    .pipeline_pool_size     64
    .pass_pool_size         16
    .uniform_buffer_size    4 MB (4*1024*1024)
    .max_commit_listeners   1024
    .disable_validation     false
    .mtl_force_managed_storage_mode false
    .wgpu_disable_bindgroups_cache  false
    .wgpu_bindgroups_cache_size     1024

    .allocator.alloc_fn     0 (in this case, malloc() will be called)
    .allocator.free_fn      0 (in this case, free() will be called)
    .allocator.user_data    0

    .environment.defaults.color_format: default value depends on selected backend:
        all GL backends:    SG_PIXELFORMAT_RGBA8
        Metal and D3D11:    SG_PIXELFORMAT_BGRA8
        WebGPU:             *no default* (must be queried from WebGPU swapchain object)
    .environment.defaults.depth_format: SG_PIXELFORMAT_DEPTH_STENCIL
    .environment.defaults.sample_count: 1

    Metal specific:
        (NOTE: All Objective-C object references are transferred through
        a bridged cast (__bridge const void*) to sokol_gfx, which will use an
        unretained bridged cast (__bridge id<xxx>) to retrieve the Objective-C
        references back. Since the bridge cast is unretained, the caller
        must hold a strong reference to the Objective-C object until sg_setup()
        returns.

        .mtl_force_managed_storage_mode
            when enabled, Metal buffers and texture resources are created in managed storage
            mode, otherwise sokol-gfx will decide whether to create buffers and
            textures in managed or shared storage mode (this is mainly a debugging option)
        .mtl_use_command_buffer_with_retained_references
            when true, the sokol-gfx Metal backend will use Metal command buffers which
            bump the reference count of resource objects as long as they are inflight,
            this is slower than the default command-buffer-with-unretained-references
            method, this may be a workaround when confronted with lifetime validation
            errors from the Metal validation layer until a proper fix has been implemented
        .environment.metal.device
            a pointer to the MTLDevice object

    D3D11 specific:
        .environment.d3d11.device
            a pointer to the ID3D11Device object, this must have been created
            before sg_setup() is called
        .environment.d3d11.device_context
            a pointer to the ID3D11DeviceContext object
        .d3d11_shader_debugging
            set this to true to compile shaders which are provided as HLSL source
            code with debug information and without optimization, this allows
            shader debugging in tools like RenderDoc, to output source code
            instead of byte code from sokol-shdc, omit the `--binary` cmdline
            option

    WebGPU specific:
        .wgpu_disable_bindgroups_cache
            When this is true, the WebGPU backend will create and immediately
            release a BindGroup object in the sg_apply_bindings() call, only
            use this for debugging purposes.
        .wgpu_bindgroups_cache_size
            The size of the bindgroups cache for re-using BindGroup objects
            between sg_apply_bindings() calls. The smaller the cache size,
            the more likely are cache slot collisions which will cause
            a BindGroups object to be destroyed and a new one created.
            Use the information returned by sg_query_stats() to check
            if this is a frequent occurrence, and increase the cache size as
            needed (the default is 1024).
            NOTE: wgpu_bindgroups_cache_size must be a power-of-2 number!
        .environment.wgpu.device
            a WGPUDevice handle

    When using sokol_gfx.h and sokol_app.h together, consider using the
    helper function sglue_environment() in the sokol_glue.h header to
    initialize the sg_desc.environment nested struct. sglue_environment() returns
    a completely initialized sg_environment struct with information
    provided by sokol_app.h.
*/
Environment_Defaults :: struct {
    color_format : Pixel_Format,
    depth_format : Pixel_Format,
    sample_count : c.int,
}

Metal_Environment :: struct {
    device : rawptr,
}

D3d11_Environment :: struct {
    device : rawptr,
    device_context : rawptr,
}

Wgpu_Environment :: struct {
    device : rawptr,
}

Environment :: struct {
    defaults : Environment_Defaults,
    metal : Metal_Environment,
    d3d11 : D3d11_Environment,
    wgpu : Wgpu_Environment,
}

/*
    sg_commit_listener

    Used with function sg_add_commit_listener() to add a callback
    which will be called in sg_commit(). This is useful for libraries
    building on top of sokol-gfx to be notified about when a frame
    ends (instead of having to guess, or add a manual 'new-frame'
    function.
*/
Commit_Listener :: struct {
    func : proc "c" (a0: rawptr),
    user_data : rawptr,
}

/*
    sg_allocator

    Used in sg_desc to provide custom memory-alloc and -free functions
    to sokol_gfx.h. If memory management should be overridden, both the
    alloc_fn and free_fn function must be provided (e.g. it's not valid to
    override one function but not the other).
*/
Allocator :: struct {
    alloc_fn : proc "c" (a0: c.size_t, a1: rawptr) -> rawptr,
    free_fn : proc "c" (a0: rawptr, a1: rawptr),
    user_data : rawptr,
}

/*
    sg_logger

    Used in sg_desc to provide a logging function. Please be aware
    that without logging function, sokol-gfx will be completely
    silent, e.g. it will not report errors, warnings and
    validation layer messages. For maximum error verbosity,
    compile in debug mode (e.g. NDEBUG *not* defined) and provide a
    compatible logger function in the sg_setup() call
    (for instance the standard logging function from sokol_log.h).
*/
Logger :: struct {
    func : proc "c" (a0: cstring, a1: u32, a2: u32, a3: cstring, a4: u32, a5: cstring, a6: rawptr),
    user_data : rawptr,
}

Desc :: struct {
    _ : u32,
    buffer_pool_size : c.int,
    image_pool_size : c.int,
    sampler_pool_size : c.int,
    shader_pool_size : c.int,
    pipeline_pool_size : c.int,
    attachments_pool_size : c.int,
    uniform_buffer_size : c.int,
    max_commit_listeners : c.int,
    disable_validation : bool,
    d3d11_shader_debugging : bool,
    mtl_force_managed_storage_mode : bool,
    mtl_use_command_buffer_with_retained_references : bool,
    wgpu_disable_bindgroups_cache : bool,
    wgpu_bindgroups_cache_size : c.int,
    allocator : Allocator,
    logger : Logger,
    environment : Environment,
    _ : u32,
}

/*
    Backend-specific structs and functions, these may come in handy for mixing
      sokol-gfx rendering with 'native backend' rendering functions.

      This group of functions will be expanded as needed.
*/
D3d11_Buffer_Info :: struct {
    buf : rawptr,
}

D3d11_Image_Info :: struct {
    tex2d : rawptr,
    tex3d : rawptr,
    res : rawptr,
    srv : rawptr,
}

D3d11_Sampler_Info :: struct {
    smp : rawptr,
}

D3d11_Shader_Info :: struct {
    cbufs : [8]rawptr,
    vs : rawptr,
    fs : rawptr,
}

D3d11_Pipeline_Info :: struct {
    il : rawptr,
    rs : rawptr,
    dss : rawptr,
    bs : rawptr,
}

D3d11_Attachments_Info :: struct {
    color_rtv : [4]rawptr,
    resolve_rtv : [4]rawptr,
    dsv : rawptr,
}

Mtl_Buffer_Info :: struct {
    buf : [2]rawptr,
    active_slot : c.int,
}

Mtl_Image_Info :: struct {
    tex : [2]rawptr,
    active_slot : c.int,
}

Mtl_Sampler_Info :: struct {
    smp : rawptr,
}

Mtl_Shader_Info :: struct {
    vertex_lib : rawptr,
    fragment_lib : rawptr,
    vertex_func : rawptr,
    fragment_func : rawptr,
}

Mtl_Pipeline_Info :: struct {
    rps : rawptr,
    dss : rawptr,
}

Wgpu_Buffer_Info :: struct {
    buf : rawptr,
}

Wgpu_Image_Info :: struct {
    tex : rawptr,
    view : rawptr,
}

Wgpu_Sampler_Info :: struct {
    smp : rawptr,
}

Wgpu_Shader_Info :: struct {
    vs_mod : rawptr,
    fs_mod : rawptr,
    bgl : rawptr,
}

Wgpu_Pipeline_Info :: struct {
    pip : rawptr,
}

Wgpu_Attachments_Info :: struct {
    color_view : [4]rawptr,
    resolve_view : [4]rawptr,
    ds_view : rawptr,
}

Gl_Buffer_Info :: struct {
    buf : [2]u32,
    active_slot : c.int,
}

Gl_Image_Info :: struct {
    tex : [2]u32,
    tex_target : u32,
    msaa_render_buffer : u32,
    active_slot : c.int,
}

Gl_Sampler_Info :: struct {
    smp : u32,
}

Gl_Shader_Info :: struct {
    prog : u32,
}

Gl_Attachments_Info :: struct {
    framebuffer : u32,
    msaa_resolve_framebuffer : [4]u32,
}

