function table.copy(t)
	local orig_type = type(t)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in pairs(t) do
			copy[orig_key] = orig_value
		end
	else -- number, string, boolean, etc
		copy = t
	end
	return copy
end
