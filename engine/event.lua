---@class Event
Event = {
	registered = {},
}

---@enum event_code
EVENT_CODE = {
	NONE = nil,
	WINDOW_RESIZE = 1,
	WINDOW_FOCUS = 2,
	WINDOW_UNFOCUS = 3,
	WINDOW_ICONIFIED = 4,
	WINDOW_MOVE = 5,
	KEY_PRESS = 6,
	KEY_RELEASE = 7,
	TEXT_INPUT = 8,
	MOUSE_PRESS = 9,
	MOUSE_RELEASE = 10,
	MOUSE_MOVE = 11,
	MOUSE_WHEEL = 12,
	MOUSE_LEAVE = 13,
	MOUSE_ENTER = 14,
	APP_QUIT = 15,
	MAX_CODE = 16,
}

---@enum event_category
EVENT_CATEGORY = {
	NONE = nil,
	WINDOW = { EVENT_CODE.WINDOW_RESIZE, EVENT_CODE.WINDOW_MOVE },
	KEYBOARD = { EVENT_CODE.KEY_PRESS, EVENT_CODE.TEXT_INPUT },
	MOUSE = { EVENT_CODE.MOUSE_PRESS, EVENT_CODE.MOUSE_ENTER },
	INPUT = { EVENT_CODE.KEY_PRESS, EVENT_CODE.MOUSE_ENTER },
}

---@alias event_callback fun(code: event_code, sender: any, listener: any, data: table): boolean

---@param code event_code
---@param listener any
---@param callback event_callback
---@return boolean
function Event:register(code, listener, callback)
	if self.registered[code] == nil then
		---@cast code integer
		table.insert(self.registered, code, {})
	end

	if listener ~= nil then
		for i = 1, #self.registered[code], 1 do
			if self.registered[code][i].listener == listener then
				-- TODO: Warn.
				return false
			end
		end
	end

	table.insert(self.registered[code], #self.registered[code] + 1, {
		listener = listener,
		callback = callback,
	})

	return true
end

---@param code event_code
---@param sender any
---@param data table
---@return boolean
function Event:fire(code, sender, data)
	if self.registered[code] == nil then
		return false
	end

	for i = 1, #self.registered[code], 1 do
		local e = self.registered[code][i]
		if e.callback(code, sender, e.listener, data) then
			-- Event has been handled.
			-- Do not send to other listeners.
			return true
		end
	end

	-- Not found.
	return false
end

---@param category event_category
---@param listener any
---@param callback event_callback
function Event:register_category(category, listener, callback)
	for _, code in pairs(EVENT_CODE) do
		if code >= category[1] and code <= category[2] then
			Event:register(code, listener, callback)
		end
	end
end

function love.keypressed(key, scancode, isrepeat)
	Input:process_key({
		key = key,
		scancode = scancode,
		isrepeat = isrepeat,
	}, true)
end

function love.keyreleased(key, scancode)
	Input:process_key({
		key = key,
		scancode = scancode,
	}, false)
end

function love.textinput(t)
	Event:fire(EVENT_CODE.TEXT_INPUT, nil, t)
end

---@diagnostic disable-next-line: duplicate-set-field
function love.mousepressed(x, y, button, istouch, presses)
	Input:process_button({
		x = x,
		y = y,
		button = button,
		istouch = istouch,
		presses = presses,
	}, true)
end

function love.mousereleased(x, y, button, istouch, presses)
	Input:process_button({
		x = x,
		y = y,
		button = button,
		istouch = istouch,
		presses = presses,
	}, false)
end

function love.mousemoved(x, y, dx, dy, istouch)
	Input:process_mouse_move({
		x = x,
		y = y,
		dx = dx,
		dy = dy,
		istouch = istouch,
	})
end

function love.wheelmoved(x, y)
	Input:process_mouse_wheel({
		x = x,
		y = y,
	})
end

function love.resize(w, h)
	Window:process_resize(w, h)
end

return true
