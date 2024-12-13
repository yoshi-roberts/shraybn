---@class shrift.util
local util = {}

---@param line string
---@return string
function util.strip_trailing_whitespace(line)
	local stripped = line:match("^%s*(.-)%s*$")
	return stripped
end

---@param input string
---@param delimiter string
---@return string[]?
function util.split_str(input, delimiter)
	local pos = string.find(input, delimiter, 1, true)

	if not pos then
		return nil
	end

	return {
		util.strip_trailing_whitespace(string.sub(input, 1, pos - 1)),
		util.strip_trailing_whitespace(string.sub(input, pos + 1)),
	}
end

return util
