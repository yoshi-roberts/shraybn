local function nuklear_event(code, sender, listener, data)
	local handled = false

	if code == EVENT_CODE.KEY_PRESS then
		handled = Nuklear:keypressed(data.key, data.scancode, data.isrepeat)
	elseif code == EVENT_CODE.KEY_RELEASE then
		handled = Nuklear:keyreleased(data.key, data.scancode)
	elseif code == EVENT_CODE.MOUSE_PRESS then
		handled = Nuklear:mousepressed(data.x, data.y, data.button, data.istouch, data.presses)
	elseif code == EVENT_CODE.MOUSE_RELEASE then
		handled = Nuklear:mousereleased(data.x, data.y, data.button, data.istouch, data.presses)
	elseif code == EVENT_CODE.MOUSE_MOVE then
		handled = Nuklear:mousemoved(data.x, data.y, data.dx, data.dy, data.istouch)
	elseif code == EVENT_CODE.TEXT_INPUT then
		handled = Nuklear:textinput(data.text)
	elseif code == EVENT_CODE.MOUSE_WHEEL then
		handled = Nuklear:wheelmoved(data.x, data.y)
	end

	return handled
end

local function nuklear_attach()
	Event:register_category(EVENT_CATEGORY.INPUT, nil, nuklear_event)
end

local function nuklear_detach() end

local function nuklear_update(dt)
	Nuklear:frameBegin()

	if Nuklear:windowBegin("Menubar", 0, 0, Window.width, 22) then
		Nuklear:menubarBegin()
		Nuklear:layoutRow("static", 12, 36, 2)

		if Nuklear:menuBegin("File", nil, 56, (12 * 6), "left") then
			Nuklear:layoutRow("dynamic", 12, 1)
			Nuklear:menuItem("New", nil, "left")
			Nuklear:menuItem("Open", nil, "left")
			Nuklear:menuItem("Save", nil, "left")
			Nuklear:menuItem("Quit", nil, "left")
			Nuklear:menuEnd()
		end

		if Nuklear:menuBegin("Game", nil, 56, (12 * 4), "left") then
			Nuklear:layoutRow("dynamic", 12, 1)
			Nuklear:menuItem("Run", nil, "left")
			Nuklear:menuItem("Build", nil, "left")
			Nuklear:menuEnd()
		end

		Nuklear:menubarEnd()
		Nuklear:windowEnd()
	end

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
