local event = {}

event.code = {
	EVENT_NONE = 0,
	EVENT_WINDOW_RESIZE = 1,
	EVENT_WINDOW_FOCUS = 2,
	EVENT_WINDOW_UNFOCUS = 3,
	EVENT_WINDOW_ICONIFIED = 4,
	EVENT_WINDOW_MOVE = 5,
	EVENT_KEY_PRESS = 6,
	EVENT_KEY_RELEASE = 7,
	EVENT_MOUSE_PRESS = 8,
	EVENT_MOUSE_RELEASE = 9,
	EVENT_MOUSE_MOVE = 10,
	EVENT_MOUSE_SCROLL = 11,
	EVENT_MOUSE_LEAVE = 12,
	EVENT_MOUSE_ENTER = 13,
	EVENT_APP_QUIT = 14,
	EVENT_MAX_CODE = 15,
}

local event_registered = function()
	return {
		listener = nil,
		callback = nil,
	}
end

event.registered = {}

event.register = function(code, listener, callback)
	if event.registered[code] == nil then
		table.insert(event.registered, code, {})
	end

	for i = 1, #event.registered[code], 1 do
		if event.registered[code][i].listener == listener then
			-- TODO: Warn.
			return false
		end
	end

	local e = event_registered()
	e.listener = listener
	e.callback = callback
	table.insert(event.registered[code], e)

	return true
end

event.fire = function(code, sender, data)
	if event.registered[code] == nil then
		return false
	end

	for i = 1, #event.registered[code], 1 do
		local e = event.registered[code][i]
		if e.callback(code, sender, e.listener, data) then
			-- Event has been handled.
			-- Do not send to other listeners.
			return true
		end
	end

	-- Not found.
	return false
end

function love.keypressed(key)
	Input:process_key(key, true)
end

function love.keyreleased(key)
	Input:process_key(key, false)
end

---@diagnostic disable-next-line: duplicate-set-field
function love.mousepressed(x, y, button)
	Input:process_button(button, true)
end

function love.mousereleased(x, y, button)
	Input:process_button(button, false)
end

return event
