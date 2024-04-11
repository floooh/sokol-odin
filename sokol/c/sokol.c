#if defined(IMPL)
#define SOKOL_IMPL
#endif

#define SOKOL_NO_ENTRY
#if defined(_WIN32)
#define SOKOL_WIN32_FORCE_MAIN
#endif
// FIXME: macOS Zig HACK without this, some C stdlib headers throw errors
#if defined(__APPLE__)
#include <TargetConditionals.h>
#endif

#include "sokol_audio.h"
#include "sokol_app.h"
#include "sokol_gfx.h"
#include "sokol_log.h"
#include "sokol_time.h"
#include "sokol_glue.h"

#include "sokol_gl.h"
#include "sokol_shape.h"
#include "sokol_debugtext.h"