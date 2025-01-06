local window = require("engine.window")
local input = require("engine.input")
local imgui = require("engine.imgui")

local window_flags = imgui.love.WindowFlags("NoMove", "NoResize")

local function ui_attach()
	imgui.engine.init(false, false)
end

local function ui_detach()
	imgui.engine.shutdown()
end

local function ui_update(dt)
	imgui.engine.update(dt)
end

local function ui_draw()
	imgui.SetNextWindowPos(imgui.ImVec2_Float(12, 12))
	imgui.SetNextWindowSize(imgui.ImVec2_Float(128 * 2, 128))

	imgui.Begin("Debug Info", nil, window_flags)

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
	draw = ui_draw,
}
