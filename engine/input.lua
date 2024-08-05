require("engine.util")

Input = {

	keyboard_current = {},
	keyboard_previous = {},

	mouse_current = {
		position = Vec2(0, 0),
		wheel = Vec2(0, 0),
		buttons = {},
	},
	mouse_previous = {
		position = Vec2(0, 0),
		wheel = Vec2(0, 0),
		buttons = {},
	},
}

MOUSE_BUTTON = {
	LEFT = 1,
	RIGHT = 2,
	MIDDLE = 3,
}

function Input:update()
	for key, pressed in pairs(self.keyboard_current) do
		self.keyboard_previous[key] = pressed
	end

	-- Mouse.
	for button, pressed in pairs(self.mouse_current.buttons) do
		self.mouse_previous.buttons[button] = pressed
	end

	self.mouse_previous.position.x = self.mouse_current.position.x
	self.mouse_previous.position.y = self.mouse_current.position.y
	self.mouse_previous.wheel.x = self.mouse_current.wheel.x
	self.mouse_previous.wheel.y = self.mouse_current.wheel.y
end

function Input:process_key(data, pressed)
	if self.keyboard_current[data.key] ~= pressed then
		self.keyboard_current[data.key] = pressed

		if pressed then
			Event:fire(EVENT_CODE.KEY_PRESS, data)
		else
			Event:fire(EVENT_CODE.KEY_RELEASE, data)
		end
	end
end

function Input:process_button(data, pressed)
	if self.mouse_current.buttons[data.button] ~= pressed then
		Input.mouse_current.buttons[data.button] = pressed

		if pressed then
			Event:fire(EVENT_CODE.MOUSE_PRESS, data)
		else
			Event:fire(EVENT_CODE.MOUSE_RELEASE, data)
		end
	end
end

function Input:process_mouse_wheel(data)
	self.mouse_current.wheel.x = data.x
	self.mouse_current.wheel.y = data.y
	Event:fire(EVENT_CODE.MOUSE_WHEEL, data)
end

function Input:process_mouse_move(data)
	self.mouse_current.position.x = data.x
	self.mouse_current.position.y = data.y
	Event:fire(EVENT_CODE.MOUSE_MOVE, data)
end

function Input:key_down(key)
	return self.keyboard_current[key] == true
end

function Input:key_up(key)
	return self.keyboard_current[key] == false
end

function Input:key_was_down(key)
	return self.keyboard_previous[key] == true
end

function Input:key_was_up(key)
	return self.keyboard_previous[key] == false
end

function Input:key_pressed(key)
	if self:key_down(key) and not self:key_was_down(key) then
		return true
	end

	return false
end

function Input:key_released(key)
	if self:key_up(key) and not self:key_was_up(key) then
		return true
	end

	return false
end

function Input:button_down(button)
	return self.mouse_current.buttons[button] == true
end

function Input:button_up(button)
	return self.mouse_current.buttons[button] == false
end

function Input:button_was_down(button)
	return self.mouse_previous.buttons[button] == true
end

function Input:button_was_up(button)
	return self.mouse_previous.buttons[button] == false
end

function Input:button_pressed(button)
	if self:button_down(button) and not self:button_was_down(button) then
		return true
	end

	return false
end

function Input:button_released(button)
	if self:button_up(button) and not self:button_was_up(button) then
		return true
	end

	return false
end

function Input:get_mouse_position()
	return self.mouse_current.position
end

function Input:mouse_moved()
	if self.mouse_current.position ~= self.mouse_previous.position then
		return true
	end

	return false
end

function Input:wheel_up()
	if self.mouse_current.wheel.y > self.mouse_previous.wheel.y then
		self.mouse_current.wheel.x = 0
		self.mouse_current.wheel.y = 0
		return true
	end

	return false
end

function Input:wheel_down()
	if self.mouse_current.wheel.y < self.mouse_previous.wheel.y then
		self.mouse_current.wheel.x = 0
		self.mouse_current.wheel.y = 0
		return true
	end

	return false
end

return true
