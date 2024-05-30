require("engine.util")
local vector = require("libs.vector")

local input = {

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

BUTTONS = {
	BUTTON_LEFT = 1,
	BUTTON_MIDDLE = 2,
	BUTTON_RIGHT = 3,
}

function input:update()
	self.keyboard_previous = table.copy(self.keyboard_current)
	self.mouse_previous.buttons = table.copy(self.mouse_current.buttons)
end

function input:process_key(key, pressed)
	if self.keyboard_current[key] ~= pressed then
		self.keyboard_current[key] = pressed

		if pressed then
			Event.fire(Event.code.EVENT_KEY_PRESS, nil, key)
		else
			Event.fire(Event.code.EVENT_KEY_RELEASE, nil, key)
		end
	end
end

function input:process_button(button, pressed)
	-- if input.mouse_current.buttons[button] ~= pressed then
	input.mouse_current.buttons[button] = pressed

	if pressed then
		Event.fire(Event.code.EVENT_MOUSE_PRESS, nil, button)
	else
		Event.fire(Event.code.EVENT_MOUSE_RELEASE, nil, button)
	end
	-- end
end

function input:process_mouse_move(x, y, dx, dy)
	if self.mouse_current.position.x ~= x or self.mouse_current.position.y ~= y then
		self.mouse_current.position:set(x, y)
		Event.fire(Event.code.EVENT_MOUSE_MOVE, nil, { x, y, dx, dy })
	end
end

function input:key_down(key)
	return input.keyboard_current[key] == true
end

function input:key_up(key)
	return input.keyboard_current[key] == false
end

function input:key_was_down(key)
	return input.keyboard_previous[key] == true
end

function input:key_was_up(key)
	return input.keyboard_previous[key] == false
end

function input:key_pressed(key)
	if input:key_down(key) and not input:key_was_down(key) then
		return true
	end

	return false
end

function input:key_released(key)
	if input:key_up(key) and not input:key_was_up(key) then
		return true
	end

	return false
end

function input:button_down(button)
	return input.mouse_current.buttons[button] == true
end

function input:button_up(button)
	return input.mouse_current.buttons[button] == false
end

function input:button_was_down(button)
	return input.mouse_previous.buttons[button] == true
end

function input:button_was_up(button)
	return input.mouse_previous.buttons[button] == false
end

function input:button_pressed(button)
	if input:button_down(button) and not input:button_was_down(button) then
		return true
	end

	return false
end

function input:button_released(button)
	if input:button_up(button) and not input:button_was_up(button) then
		return true
	end

	return false
end

return input
