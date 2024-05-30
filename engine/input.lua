local input = {

	keyboard_current = {},
	keyboard_previous = {},
}

function input:update()
	for k, v in pairs(self.keyboard_current) do
		self.keyboard_previous[k] = v
	end
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

return input
