local function ui_event(code, sender, listener, data)
	return ImguiEvent(code, data)
end

local function ui_attach()
	Imgui.love.Init()
	Event:register_category(EVENT_CATEGORY.INPUT, nil, ui_event)
end

local function ui_detach()
	Imgui.love.Shutdown()
end

local function ui_update(dt)
	Imgui.love.Update(dt)
	Imgui.NewFrame()
end

local function ui_draw()
	local window_flags = Imgui.love.WindowFlags("NoMove", "NoResize")

	Imgui.SetNextWindowPos(Imgui.ImVec2_Float(12, 12))
	Imgui.SetNextWindowSize(Imgui.ImVec2_Float(128 * 2, 128))

	Imgui.Begin("Debug Info", nil, window_flags)

	Imgui.Text("FPS: " .. love.timer.getFPS())
	Imgui.Text("Window Size: " .. Window.width .. "x" .. Window.height)

	local mpos = Input:get_mouse_position()
	Imgui.Text("Mouse Position: (" .. mpos.x .. ", " .. mpos.y .. ")")

	Imgui.End()

	Imgui.Render()
	Imgui.love.RenderDrawLists()
end

Layer("nuklear_layer", {
	attach = ui_attach,
	detach = ui_detach,
	update = ui_update,
	draw = ui_draw,
	event = ui_event,
})
