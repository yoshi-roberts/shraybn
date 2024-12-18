require("engine.util")

---@class engine.input
local input = {

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

---@enum input.mouse_button
input.mouse_button = {
	LEFT = 1,
	RIGHT = 2,
	MIDDLE = 3,
}

function input.update()
	for key, pressed in pairs(input.keyboard_current) do
		input.keyboard_previous[key] = pressed
	end

	-- Mouse.
	for button, pressed in pairs(input.mouse_current.buttons) do
		input.mouse_previous.buttons[button] = pressed
	end

	input.mouse_previous.position.x = input.mouse_current.position.x
	input.mouse_previous.position.y = input.mouse_current.position.y
	input.mouse_previous.wheel.x = input.mouse_current.wheel.x
	input.mouse_previous.wheel.y = input.mouse_current.wheel.y
end

---@param data table
---@param pressed boolean
---@return boolean
function input.process_key(data, pressed)
	if input.keyboard_current[data.key] ~= pressed then
		input.keyboard_current[data.key] = pressed

		return true
	end

	return false
end

---@param data table
---@param pressed boolean
---@return boolean
function input.process_button(data, pressed)
	if input.mouse_current.buttons[data.button] ~= pressed then
		input.mouse_current.buttons[data.button] = pressed

		return true
	end

	return false
end

---@param data table
function input.process_mouse_wheel(data)
	input.mouse_current.wheel.x = data.x
	input.mouse_current.wheel.y = data.y
end

---@param data table
function input.process_mouse_move(data)
	input.mouse_current.position.x = data.x
	input.mouse_current.position.y = data.y
end

---@param key string
---@return boolean
function input.key_down(key)
	return input.keyboard_current[key] == true
end

---@param key string
---@return boolean
function input.key_up(key)
	return input.keyboard_current[key] == false
end

---@param key string
---@return boolean
function input.key_was_down(key)
	return input.keyboard_previous[key] == true
end

---@param key string
---@return boolean
function input.key_was_up(key)
	return input.keyboard_previous[key] == false
end

---@param key string
---@return boolean
function input.key_pressed(key)
	if input.key_down(key) and not input.key_was_down(key) then
		return true
	end

	return false
end

---@param key string
---@return boolean
function input.key_released(key)
	if input.key_up(key) and not input.key_was_up(key) then
		return true
	end

	return false
end

---@param button input.mouse_button
---@return boolean
function input.button_down(button)
	return input.mouse_current.buttons[button] == true
end

---@param button input.mouse_button
---@return boolean
function input.button_up(button)
	return input.mouse_current.buttons[button] == false
end

---@param button input.mouse_button
---@return boolean
function input.button_was_down(button)
	return input.mouse_previous.buttons[button] == true
end

---@param button input.mouse_button
---@return boolean
function input.button_was_up(button)
	return input.mouse_previous.buttons[button] == false
end

---@param button input.mouse_button
---@return boolean
function input.button_pressed(button)
	if input.button_down(button) and not input.button_was_down(button) then
		return true
	end

	return false
end

---@param button input.mouse_button
---@return boolean
function input.button_released(button)
	if input.button_up(button) and not input.button_was_up(button) then
		return true
	end

	return false
end

---@return Vec2
function input.get_mouse_position()
	return input.mouse_current.position
end

---@return boolean
function input.mouse_moved()
	if input.mouse_current.position ~= input.mouse_previous.position then
		return true
	end

	return false
end

---@return boolean
function input.wheel_up()
	if input.mouse_current.wheel.y > input.mouse_previous.wheel.y then
		input.mouse_current.wheel.x = 0
		input.mouse_current.wheel.y = 0
		return true
	end

	return false
end

---@return boolean
function input.wheel_down()
	if input.mouse_current.wheel.y < input.mouse_previous.wheel.y then
		input.mouse_current.wheel.x = 0
		input.mouse_current.wheel.y = 0
		return true
	end

	return false
end

return input
