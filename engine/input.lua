require("engine.util")
local vector = require("libs.vector")

Input = {

	keyboard_current = {},
	keyboard_previous = {},

	mouse_current = {
		position = vector(0, 0),
		buttons = {},
	},
	mouse_previous = {
		position = vector(0, 0),
		buttons = {},
	},
}

MOUSE_BUTTON = {
	LEFT = 1,
	MIDDLE = 2,
	RIGHT = 3,
}

function Input:update()
	self.keyboard_previous = table.copy(self.keyboard_current)
	-- Mouse
	self.mouse_previous.buttons = table.copy(self.mouse_current.buttons)
	self.mouse_previous.position:replace(self.mouse_current.position)
end

function Input:process_key(key, pressed)
	if self.keyboard_current[key] ~= pressed then
		self.keyboard_current[key] = pressed

		if pressed then
			Event:fire(EVENT_CODE.KEY_PRESS, nil, key)
		else
			Event:fire(EVENT_CODE.KEY_RELEASE, nil, key)
		end
	end
end

function Input:process_button(button, pressed)
	if self.mouse_current.buttons[button] ~= pressed then
		Input.mouse_current.buttons[button] = pressed

		if pressed then
			Event:fire(EVENT_CODE.MOUSE_PRESS, nil, button)
		else
			Event:fire(EVENT_CODE.MOUSE_RELEASE, nil, button)
		end
	end
end

function Input:process_mouse_move(x, y, dx, dy)
	if self.mouse_current.position.x ~= x or self.mouse_current.position.y ~= y then
		self.mouse_current.position:set(x, y)
		Event:fire(EVENT_CODE.MOUSE_MOVE, nil, { x, y, dx, dy })
	end
end

function Input:key_down(key)
	return Input.keyboard_current[key] == true
end

function Input:key_up(key)
	return Input.keyboard_current[key] == false
end

function Input:key_was_down(key)
	return Input.keyboard_previous[key] == true
end

function Input:key_was_up(key)
	return Input.keyboard_previous[key] == false
end

function Input:key_pressed(key)
	if Input:key_down(key) and not Input:key_was_down(key) then
		return true
	end

	return false
end

function Input:key_released(key)
	if Input:key_up(key) and not Input:key_was_up(key) then
		return true
	end

	return false
end

function Input:button_down(button)
	return Input.mouse_current.buttons[button] == true
end

function Input:button_up(button)
	return Input.mouse_current.buttons[button] == false
end

function Input:button_was_down(button)
	return Input.mouse_previous.buttons[button] == true
end

function Input:button_was_up(button)
	return Input.mouse_previous.buttons[button] == false
end

function Input:button_pressed(button)
	if Input:button_down(button) and not Input:button_was_down(button) then
		return true
	end

	return false
end

function Input:button_released(button)
	if Input:button_up(button) and not Input:button_was_up(button) then
		return true
	end

	return false
end

return true
