local window = require("engine.window")
local input = require("engine.input")
local imgui = require("engine.imgui")

local window_flags = imgui.love.WindowFlags("NoMove", "NoResize")

local function ui_attach()
	imgui.love.Init()
end

local function ui_detach()
	imgui.love.Shutdown()
end

local function ui_update(dt)
	imgui.love.Update(dt)
	imgui.NewFrame()
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

	imgui.Render()
	imgui.love.RenderDrawLists()
end

return {
	attach = ui_attach,
	detach = ui_detach,
	update = ui_update,
	draw = ui_draw,
}
