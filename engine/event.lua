Event = {
	registered = {},
}

EVENT_CODE = {
	NONE = nil,
	WINDOW_RESIZE = 1,
	WINDOW_FOCUS = 2,
	WINDOW_UNFOCUS = 3,
	WINDOW_ICONIFIED = 4,
	WINDOW_MOVE = 5,
	KEY_PRESS = 6,
	KEY_RELEASE = 7,
	MOUSE_PRESS = 8,
	MOUSE_RELEASE = 9,
	MOUSE_MOVE = 10,
	MOUSE_SCROLL = 11,
	MOUSE_LEAVE = 12,
	MOUSE_ENTER = 13,
	APP_QUIT = 14,
	MAX_CODE = 15,
}

function Event:register(code, listener, callback)
	if self.registered[code] == nil then
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

function love.mousemoved(x, y, dx, dy, istouch)
	Input:process_mouse_move(x, y, dx, dy)
end

function love.resize(w, h)
	Window:process_resize(w, h)
end

return true
