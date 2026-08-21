package main

import sapp "../../sokol/app"
import sg "../../sokol/gfx"
import sgl "../../sokol/gl"
import sglue "../../sokol/glue"
import "core:fmt"
import "core:runtime"
import mu "vendor:microui"

state := struct {
	pip:             sgl.Pipeline,
	mu_ctx:          mu.Context,
	log_buf:         [1 << 16]byte,
	log_buf_len:     int,
	log_buf_updated: bool,
	bg:              mu.Color,
	atlas_img:       sg.Image,
	atlas_smp:       sg.Sampler,
} {
	bg = {90, 95, 100, 255},
}

r_init :: proc() {
	pixels := make([][4]u8, mu.DEFAULT_ATLAS_WIDTH * mu.DEFAULT_ATLAS_HEIGHT)
	for alpha, i in mu.default_atlas_alpha {
		pixels[i].rgb = 0xff
		pixels[i].a = alpha
	}

	state.atlas_img = sg.make_image(
		sg.Image_Desc {
			width = mu.DEFAULT_ATLAS_WIDTH,
			height = mu.DEFAULT_ATLAS_HEIGHT,
			data =  {
				subimage =  {
					0 =  {
						0 =  {
							ptr = raw_data(pixels),
							size = mu.DEFAULT_ATLAS_WIDTH * mu.DEFAULT_ATLAS_HEIGHT * 4,
						},
					},
				},
			},
		},
	)

	state.atlas_smp = sg.make_sampler(
		sg.Sampler_Desc{min_filter = .NEAREST, mag_filter = .NEAREST},
	)


	state.pip = sgl.make_pipeline(
		sg.Pipeline_Desc {
			colors =  {
				0 =  {
					blend =  {
						enabled = true,
						src_factor_rgb = .SRC_ALPHA,
						dst_factor_rgb = .ONE_MINUS_SRC_ALPHA,
					},
				},
			},
		},
	)

	free(raw_data(pixels))
}

init :: proc "c" () {
	context = runtime.default_context()

	sg.setup(sg.Desc{environment = sglue.environment()})
	sgl.setup({})

	r_init()

	ctx := &state.mu_ctx
	mu.init(ctx)

	ctx.text_width = mu.default_atlas_text_width
	ctx.text_height = mu.default_atlas_text_height
}

r_begin :: proc(disp_width, disp_height: i32) {
	sgl.defaults()
	sgl.push_pipeline()
	sgl.load_pipeline(state.pip)
	sgl.enable_texture()
	sgl.texture(state.atlas_img, state.atlas_smp)
	sgl.matrix_mode_projection()
	sgl.push_matrix()
	sgl.ortho(0.0, f32(disp_width), f32(disp_height), 0.0, -1.0, +1.0)
	sgl.begin_quads()
}

r_push_quad :: proc(dst: mu.Rect, src: mu.Rect, color: mu.Color) {
	u0 := f32(src.x) / f32(mu.DEFAULT_ATLAS_WIDTH)
	v0 := f32(src.y) / f32(mu.DEFAULT_ATLAS_HEIGHT)
	u1 := f32(src.x + src.w) / f32(mu.DEFAULT_ATLAS_WIDTH)
	v1 := f32(src.y + src.h) / f32(mu.DEFAULT_ATLAS_HEIGHT)

	x0 := f32(dst.x)
	y0 := f32(dst.y)
	x1 := f32(dst.x + dst.w)
	y1 := f32(dst.y + dst.h)

	sgl.c4b(color.r, color.g, color.b, color.a)
	sgl.v2f_t2f(x0, y0, u0, v0)
	sgl.v2f_t2f(x1, y0, u1, v0)
	sgl.v2f_t2f(x1, y1, u1, v1)
	sgl.v2f_t2f(x0, y1, u0, v1)
}

r_draw_text :: proc(text: string, pos: mu.Vec2, color: mu.Color) {
	dst := mu.Rect{pos.x, pos.y, 0, 0}
	for ch in text {
		src := mu.default_atlas[mu.DEFAULT_ATLAS_FONT + int(ch)]
		dst.w = src.w
		dst.h = src.h
		r_push_quad(dst, src, color)
		dst.x += dst.w
	}
}

r_draw_rect :: proc(rect: mu.Rect, color: mu.Color) {
	r_push_quad(rect, mu.default_atlas[mu.DEFAULT_ATLAS_WHITE], color)
}

r_draw_icon :: proc(id: mu.Icon, rect: mu.Rect, color: mu.Color) {
	src := mu.default_atlas[id]
	x := rect.x + (rect.w - src.w) / 2
	y := rect.y + (rect.h - src.h) / 2
	r_push_quad(mu.Rect{x, y, src.w, src.h}, src, color)
}

r_set_clip_rect :: proc(rect: mu.Rect) {
	sgl.end()
	sgl.scissor_rect(rect.x, rect.y, rect.w, rect.h, true)
	sgl.begin_quads()
}

r_end :: proc() {
	sgl.end()
	sgl.pop_matrix()
	sgl.pop_pipeline()
}

r_draw :: proc() {
	sgl.draw()
}

frame :: proc "c" () {
	context = runtime.default_context()

	mu_ctx := &state.mu_ctx
	mu.begin(mu_ctx)
	all_windows(mu_ctx)
	mu.end(mu_ctx)

	r_begin(sapp.width(), sapp.height())
	command_backing: ^mu.Command
	for variant in mu.next_command_iterator(mu_ctx, &command_backing) {
		switch cmd in variant {
		case ^mu.Command_Text:
			r_draw_text(cmd.str, cmd.pos, cmd.color)
		case ^mu.Command_Rect:
			r_draw_rect(cmd.rect, cmd.color)
		case ^mu.Command_Icon:
			r_draw_icon(cmd.id, cmd.rect, cmd.color)
		case ^mu.Command_Clip:
			r_set_clip_rect(cmd.rect)
		case ^mu.Command_Jump:
			unreachable()
		}
	}
	r_end()

	sg.begin_pass(
		sg.Pass {
			action =  {
				colors =  {
					0 =  {
						load_action = .CLEAR,
						clear_value =  {
							f32(state.bg.r) / 255.0,
							f32(state.bg.g) / 255.0,
							f32(state.bg.b) / 255.0,
							1.0,
						},
					},
				},
			},
		swapchain = sglue.swapchain()
		},
	)

	r_draw()
	sg.end_pass()
	sg.commit()
}

key_map := map[sapp.Keycode]mu.Key {
	.LEFT_SHIFT    = .SHIFT,
	.RIGHT_SHIFT   = .SHIFT,
	.LEFT_CONTROL  = .CTRL,
	.RIGHT_CONTROL = .CTRL,
	.LEFT_ALT      = .ALT,
	.RIGHT_ALT     = .ALT,
	.ENTER         = .RETURN,
	.KP_ENTER      = .RETURN,
	.BACKSPACE     = .BACKSPACE,
}
event :: proc "c" (ev: ^sapp.Event) {

	context = runtime.default_context()
	mu_ctx := &state.mu_ctx
	#partial switch ev.type {
	case .MOUSE_DOWN:
		mu.input_mouse_down(mu_ctx, i32(ev.mouse_x), i32(ev.mouse_y), mu.Mouse(ev.mouse_button))
	case .MOUSE_UP:
		mu.input_mouse_up(mu_ctx, i32(ev.mouse_x), i32(ev.mouse_y), mu.Mouse(ev.mouse_button))
	case .MOUSE_MOVE:
		mu.input_mouse_move(mu_ctx, i32(ev.mouse_x), i32(ev.mouse_y))
	case .MOUSE_SCROLL:
		mu.input_scroll(mu_ctx, 0, i32(ev.scroll_y))
	case .KEY_DOWN:
		if ev.key_code in key_map {
			mu.input_key_down(mu_ctx, key_map[ev.key_code])
		}
	case .KEY_UP:
		if ev.key_code in key_map {
			mu.input_key_up(mu_ctx, key_map[ev.key_code])
		}
	case .CHAR:
		mu.input_text(mu_ctx, fmt.tprint(rune(ev.char_code)))
	}
}

cleanup :: proc "c" () {
	sgl.shutdown()
	sg.shutdown()
}

main :: proc() {
	sapp.run(
		 {
			init_cb = init,
			frame_cb = frame,
			cleanup_cb = cleanup,
			event_cb = event,
			width = 800,
			height = 600,
			sample_count = 4,
			window_title = "sokol microui",
			icon = {sokol_default = true},
		},
	)
}

u8_slider :: proc(ctx: ^mu.Context, val: ^u8, lo, hi: u8) -> (res: mu.Result_Set) {
	mu.push_id(ctx, uintptr(val))

	@(static)
	tmp: mu.Real
	tmp = mu.Real(val^)
	res = mu.slider(ctx, &tmp, mu.Real(lo), mu.Real(hi), 0, "%.0f", {.ALIGN_CENTER})
	val^ = u8(tmp)
	mu.pop_id(ctx)
	return
}

write_log :: proc(str: string) {
	state.log_buf_len += copy(state.log_buf[state.log_buf_len:], str)
	state.log_buf_len += copy(state.log_buf[state.log_buf_len:], "\n")
	state.log_buf_updated = true
}

read_log :: proc() -> string {
	return string(state.log_buf[:state.log_buf_len])
}
reset_log :: proc() {
	state.log_buf_updated = true
	state.log_buf_len = 0
}


all_windows :: proc(ctx: ^mu.Context) {
	@(static)
	opts := mu.Options{.NO_CLOSE}

	if mu.window(ctx, "Demo Window", {40, 40, 300, 450}, opts) {
		if .ACTIVE in mu.header(ctx, "Window Info") {
			win := mu.get_current_container(ctx)
			mu.layout_row(ctx, {54, -1}, 0)
			mu.label(ctx, "Position:")
			mu.label(ctx, fmt.tprintf("%d, %d", win.rect.x, win.rect.y))
			mu.label(ctx, "Size:")
			mu.label(ctx, fmt.tprintf("%d, %d", win.rect.w, win.rect.h))
		}

		if .ACTIVE in mu.header(ctx, "Window Options") {
			mu.layout_row(ctx, {120, 120, 120}, 0)
			for opt in mu.Opt {
				state := opt in opts
				if .CHANGE in mu.checkbox(ctx, fmt.tprintf("%v", opt), &state) {
					if state {
						opts += {opt}
					} else {
						opts -= {opt}
					}
				}
			}
		}

		if .ACTIVE in mu.header(ctx, "Test Buttons", {.EXPANDED}) {
			mu.layout_row(ctx, {86, -110, -1})
			mu.label(ctx, "Test buttons 1:")
			if .SUBMIT in mu.button(ctx, "Button 1") {write_log("Pressed button 1")}
			if .SUBMIT in mu.button(ctx, "Button 2") {write_log("Pressed button 2")}
			mu.label(ctx, "Test buttons 2:")
			if .SUBMIT in mu.button(ctx, "Button 3") {write_log("Pressed button 3")}
			if .SUBMIT in mu.button(ctx, "Button 4") {write_log("Pressed button 4")}
		}

		if .ACTIVE in mu.header(ctx, "Tree and Text", {.EXPANDED}) {
			mu.layout_row(ctx, {140, -1})
			mu.layout_begin_column(ctx)
			if .ACTIVE in mu.treenode(ctx, "Test 1") {
				if .ACTIVE in mu.treenode(ctx, "Test 1a") {
					mu.label(ctx, "Hello")
					mu.label(ctx, "world")
				}
				if .ACTIVE in mu.treenode(ctx, "Test 1b") {
					if .SUBMIT in mu.button(ctx, "Button 1") {write_log("Pressed button 1")}
					if .SUBMIT in mu.button(ctx, "Button 2") {write_log("Pressed button 2")}
				}
			}
			if .ACTIVE in mu.treenode(ctx, "Test 2") {
				mu.layout_row(ctx, {53, 53})
				if .SUBMIT in mu.button(ctx, "Button 3") {write_log("Pressed button 3")}
				if .SUBMIT in mu.button(ctx, "Button 4") {write_log("Pressed button 4")}
				if .SUBMIT in mu.button(ctx, "Button 5") {write_log("Pressed button 5")}
				if .SUBMIT in mu.button(ctx, "Button 6") {write_log("Pressed button 6")}
			}
			if .ACTIVE in mu.treenode(ctx, "Test 3") {
				@(static)
				checks := [3]bool{true, false, true}
				mu.checkbox(ctx, "Checkbox 1", &checks[0])
				mu.checkbox(ctx, "Checkbox 2", &checks[1])
				mu.checkbox(ctx, "Checkbox 3", &checks[2])

			}
			mu.layout_end_column(ctx)

			mu.layout_begin_column(ctx)
			mu.layout_row(ctx, {-1})
			mu.text(
				ctx,
				"Lorem ipsum dolor sit amet, consectetur adipiscing " +
				"elit. Maecenas lacinia, sem eu lacinia molestie, mi risus faucibus " +
				"ipsum, eu varius magna felis a nulla.",
			)
			mu.layout_end_column(ctx)
		}

		if .ACTIVE in mu.header(ctx, "Background Colour", {.EXPANDED}) {
			mu.layout_row(ctx, {-78, -1}, 68)
			mu.layout_begin_column(ctx)
			{
				mu.layout_row(ctx, {46, -1}, 0)
				mu.label(ctx, "Red:");u8_slider(ctx, &state.bg.r, 0, 255)
				mu.label(ctx, "Green:");u8_slider(ctx, &state.bg.g, 0, 255)
				mu.label(ctx, "Blue:");u8_slider(ctx, &state.bg.b, 0, 255)
			}
			mu.layout_end_column(ctx)

			r := mu.layout_next(ctx)
			mu.draw_rect(ctx, r, state.bg)
			mu.draw_box(ctx, mu.expand_rect(r, 1), ctx.style.colors[.BORDER])
			mu.draw_control_text(
				ctx,
				fmt.tprintf("#%02x%02x%02x", state.bg.r, state.bg.g, state.bg.b),
				r,
				.TEXT,
				{.ALIGN_CENTER},
			)
		}
	}

	if mu.window(ctx, "Log Window", {350, 40, 300, 200}, opts) {
		mu.layout_row(ctx, {-1}, -28)
		mu.begin_panel(ctx, "Log")
		mu.layout_row(ctx, {-1}, -1)
		mu.text(ctx, read_log())
		if state.log_buf_updated {
			panel := mu.get_current_container(ctx)
			panel.scroll.y = panel.content_size.y
			state.log_buf_updated = false
		}
		mu.end_panel(ctx)

		@(static)
		buf: [128]byte
		@(static)
		buf_len: int
		submitted := false
		mu.layout_row(ctx, {-70, -1})
		if .SUBMIT in mu.textbox(ctx, buf[:], &buf_len) {
			mu.set_focus(ctx, ctx.last_id)
			submitted = true
		}
		if .SUBMIT in mu.button(ctx, "Submit") {
			submitted = true
		}
		if submitted {
			write_log(string(buf[:buf_len]))
			buf_len = 0
		}
	}

	if mu.window(ctx, "Style Window", {350, 250, 300, 240}) {
		@(static)
		colors := [mu.Color_Type]string {
			.TEXT         = "text",
			.BORDER       = "border",
			.WINDOW_BG    = "window bg",
			.TITLE_BG     = "title bg",
			.TITLE_TEXT   = "title text",
			.PANEL_BG     = "panel bg",
			.BUTTON       = "button",
			.BUTTON_HOVER = "button hover",
			.BUTTON_FOCUS = "button focus",
			.BASE         = "base",
			.BASE_HOVER   = "base hover",
			.BASE_FOCUS   = "base focus",
			.SCROLL_BASE  = "scroll base",
			.SCROLL_THUMB = "scroll thumb",
		}

		sw := i32(f32(mu.get_current_container(ctx).body.w) * 0.14)
		mu.layout_row(ctx, {80, sw, sw, sw, sw, -1})
		for label, col in colors {
			mu.label(ctx, label)
			u8_slider(ctx, &ctx.style.colors[col].r, 0, 255)
			u8_slider(ctx, &ctx.style.colors[col].g, 0, 255)
			u8_slider(ctx, &ctx.style.colors[col].b, 0, 255)
			u8_slider(ctx, &ctx.style.colors[col].a, 0, 255)
			mu.draw_rect(ctx, mu.layout_next(ctx), ctx.style.colors[col])
		}
	}

}
