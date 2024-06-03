local function imgui_event(code, sender, listener, data)
	local handled = false

	if code == EVENT_CODE.MOUSE_MOVE then
		Imgui.love.MouseMoved(data.x, data.y)
		handled = Imgui.love.GetWantCaptureMouse()
	elseif code == EVENT_CODE.MOUSE_PRESS then
		Imgui.love.MousePressed(data)
		handled = Imgui.love.GetWantCaptureMouse()
	elseif code == EVENT_CODE.MOUSE_RELEASE then
		Imgui.love.MouseReleased(data)
		handled = Imgui.love.GetWantCaptureMouse()
	elseif code == EVENT_CODE.MOUSE_WHEEL then
		Imgui.love.WheelMoved(data.x, data.y)
		handled = Imgui.love.GetWantCaptureMouse()
	elseif code == EVENT_CODE.KEY_PRESS then
		Imgui.love.KeyPressed(data)
		handled = Imgui.love.GetWantCaptureKeyboard()
	elseif code == EVENT_CODE.KEY_RELEASE then
		Imgui.love.KeyReleased(data)
		handled = Imgui.love.GetWantCaptureKeyboard()
	elseif code == EVENT_CODE.TEXT_INPUT then
		Imgui.love.TextInput(data)
		handled = Imgui.love.GetWantCaptureKeyboard()
	end

	return handled
end

local function imgui_attach()
	Imgui.love.Init()
	Event:register_category(EVENT_CATEGORY.INPUT, nil, imgui_event)
end

local function imgui_detach()
	Imgui.love.Shutdown()
end

local function imgui_update(dt)
	Imgui.love.Update(dt)
	Imgui.NewFrame()
end

local function imgui_draw()
	local mouse_pos = Input:get_mouse_position()

	local flags = Imgui.love.WindowFlags("NoMove", "NoResize", "AlwaysAutoResize")
	local pos = Imgui.ImVec2_Float(16, 16)
	local condition = Imgui.ImGuiCond_Always

	Imgui.SetNextWindowPos(pos, condition)

	Imgui.Begin("EDITOR", nil, flags)
	Imgui.Text("FPS: " .. love.timer.getFPS())
	Imgui.Text("Window Size: " .. Window.width .. "x" .. Window.height)
	Imgui.Text("Mouse Position: (" .. mouse_pos.x .. ", " .. mouse_pos.y .. ")")
	Imgui.End()

	-- code to render imgui
	Imgui.Render()
	Imgui.love.RenderDrawLists()
end

Engine:new_layer("imgui_layer", {
	attach = imgui_attach,
	detach = imgui_detach,
	update = imgui_update,
	draw = imgui_draw,
	event = imgui_event,
})
