local function nuklear_event(code, sender, listener, data)
	local handled = false

	if code == EVENT_CODE.MOUSE_MOVE then
		handled = Nuklear:mousemoved(data.x, data.y, data.dx, data.dy, data.istouch)
	elseif code == EVENT_CODE.MOUSE_PRESS then
		handled = Nuklear:mousepressed(data.x, data.y, data.button, data.istouch, data.presses)
	elseif code == EVENT_CODE.MOUSE_RELEASE then
		handled = Nuklear:mousereleased(data.x, data.y, data.button, data.istouch, data.presses)
	elseif code == EVENT_CODE.MOUSE_WHEEL then
		handled = Nuklear:wheelmoved(data.x, data.y, data.dx, data.dy, data.istouch)
	elseif code == EVENT_CODE.KEY_PRESS then
		handled = Nuklear:keypressed(data.key, data.scancode, data.isrepeat)
	elseif code == EVENT_CODE.KEY_RELEASE then
		handled = Nuklear:keyreleased(data.key, data.scancode)
	elseif code == EVENT_CODE.TEXT_INPUT then
		handled = Nuklear:textinput(data)
	end

	return handled
end

local function nuklear_attach()
	Event:register_category(EVENT_CATEGORY.INPUT, nil, nuklear_event)
end

local function nuklear_detach() end

local function nuklear_update(dt)
	Nuklear:frameBegin()
	if Nuklear:windowBegin("Debug Info", 12, 12, 200, 128, "border", "title", "minimizable") then
		Nuklear:layoutRow("dynamic", 16, 1)

		Nuklear:label("FPS: " .. love.timer.getFPS())
		Nuklear:label("Window Size: " .. Window.width .. "x" .. Window.height)

		local mouse_pos = Input:get_mouse_position()
		Nuklear:label("Mous Position: (" .. mouse_pos.x .. ", " .. mouse_pos.y .. ")")
	end

	Nuklear:windowEnd()
	Nuklear:frameEnd()
end

local function nuklear_draw()
	Nuklear:draw()
end

Engine:new_layer("nuklear_layer", {
	attach = nuklear_attach,
	detach = nuklear_detach,
	update = nuklear_update,
	draw = nuklear_draw,
	event = nuklear_event,
})
