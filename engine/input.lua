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

return input
