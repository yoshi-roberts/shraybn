local window = require "engine.window"
local input = require "engine.input"

---@class engine.event
local event = {}
event.registered = {}

---@enum event.code
event.code = {
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

---@enum event.category
-- Each category contains two events that are the start and end of a range of events.
event.category = {
	NONE = nil,
	WINDOW = { event.code.WINDOW_RESIZE, event.code.WINDOW_MOVE },
	KEYBOARD = { event.code.KEY_PRESS, event.code.TEXT_INPUT },
	MOUSE = { event.code.MOUSE_PRESS, event.code.MOUSE_ENTER },
	INPUT = { event.code.KEY_PRESS, event.code.MOUSE_ENTER },
}

-- Return true if the event has been handled.
-- Return false to pass the event on to other callbacks.
---@alias event_callback fun(code: event.code, data: table): boolean

---@param code event.code: The event code.
---@param callback event_callback: The callback to register.
function event.register(code, callback)
	if not event.registered[code] then
		event.registered[code] = {}
	end

	table.insert(event.registered[code], callback)
end

---@param code event.code: The event to fire.
---@param data any: Data to pass to registered callbacks.
---@return boolean
function event.fire(code, data)
	if not event.registered[code] then
		return false
	end

	for _, callback in pairs(event.registered[code]) do
		---@cast callback event_callback
		if callback(code, data) then
			-- Event handled.
			return true
		end
	end

	-- Event not handled.
	return false
end

---@param category event.category: The category code.
---@param callback event_callback: The callback to register.
function event.register_category(category, callback)
	for _, code in pairs(event.code) do
		if code >= category[1] and code <= category[2] then
			event.register(code, callback)
		end
	end
end

-- Capture LOVE events and fire off engine events. --

function love.keypressed(key, scancode, isrepeat)
	local data = {
		key = key,
		scancode = scancode,
		isrepeat = isrepeat,
	}

	if input.process_key(data, true) then
		event.fire(event.code.KEY_PRESS, data)
	end
end

function love.keyreleased(key, scancode)
	local data = {
		key = key,
		scancode = scancode,
	}

	if input.process_key(data, false) then
		event.fire(event.code.KEY_RELEASE, data)
	end
end

function love.textinput(t)
	event.fire(event.code.TEXT_INPUT, t)
end

function love.mousepressed(x, y, button, istouch, presses)
	local data = {
		x = x,
		y = y,
		button = button,
		istouch = istouch,
		presses = presses,
	}

	if input.process_button(data, true) then
		event.fire(event.code.MOUSE_PRESS, data)
	end
end

function love.mousereleased(x, y, button, istouch, presses)
	local data = {
		x = x,
		y = y,
		button = button,
		istouch = istouch,
		presses = presses,
	}

	if input.process_button(data, false) then
		event.fire(event.code.MOUSE_RELEASE, data)
	end
end

function love.mousemoved(x, y, dx, dy, istouch)
	local data = {
		x = x,
		y = y,
		dx = dx,
		dy = dy,
		istouch = istouch,
	}

	input.process_mouse_move(data)
	event.fire(event.code.MOUSE_MOVE, data)
end

function love.wheelmoved(x, y)
	local data = { x, y }

	input.process_mouse_wheel(data)
	event.fire(event.code.MOUSE_WHEEL, data)
end

function love.resize(w, h)
	if window.process_resize(w, h) then
		event.fire(event.code.WINDOW_RESIZE, { width = w, height = h })
	end
end

return event
