function table.copy(list)
	if type(list) ~= "table" then
		return list
	end
	local res = {}
	for k, v in pairs(list) do
		if type(v) ~= "table" then
			res[k] = v
		else
			res[k] = table.copy(v)
		end
	end
	return res
end
