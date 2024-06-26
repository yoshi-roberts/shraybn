Util = {}

---@param path string
---@return string
function Util.path_to_key(path)
	local parts = {}
	-- Seperate the path by the backslashes.
	for str in string.gmatch(path, "([^/]+)") do
		table.insert(parts, str)
	end

	-- Remove the first two parts.
	table.remove(parts, 1)
	table.remove(parts, 1)

	-- Concat the parts park into a string seperated by "." instead of "/"
	return table.concat(parts, ".")
end
