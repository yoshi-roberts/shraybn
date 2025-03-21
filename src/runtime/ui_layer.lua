local window = require("engine.window")
local input = require("engine.input")
local imgui = require("engine.imgui")
local engine = require("engine")

local window_flags =
	imgui.love.WindowFlags("NoMove", "NoCollapse", "AlwaysAutoResize", "NoScrollbar")
local show_debug = false

local function ui_attach()
	imgui.engine.init(false, false)
end

local function ui_detach()
	imgui.engine.shutdown()
end

local function ui_update(dt)
	if input.key_pressed("`") then
		show_debug = not show_debug
	end

	if show_debug then
		imgui.engine.update(dt)
	end
end

local function ui_draw()
	if not show_debug then
		return
	end

	imgui.SetNextWindowPos(imgui.ImVec2_Float(12, 12))

	imgui.Begin("Debug Info", nil, window_flags)

	imgui.Text("Scene: " .. engine.active_scene.name)
	imgui.Separator()

	imgui.Text("FPS: " .. love.timer.getFPS())
	imgui.Text("Window Size: " .. window.width .. "x" .. window.height)

	local mpos = input.get_mouse_position()
	imgui.Text("Mouse Position: (" .. mpos.x .. ", " .. mpos.y .. ")")

	imgui.End()

	imgui.engine.draw()
end

return {
	attach = ui_attach,
	detach = ui_detach,
	update = ui_update,
	draw_gui = ui_draw,
}
