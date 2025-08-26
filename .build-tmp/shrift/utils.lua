---@class shrift.utils
local utils = {}

---@param str string
---@return string
function utils.strip_trailing_whitespace(str)
	local stripped = str:match("^%s*(.-)%s*$")
	return stripped
end

---@param input string
---@param delimiter string
---@return string[]?
function utils.split_str(input, delimiter)
	local pos = string.find(input, delimiter, 1, true)

	if not pos then
		return nil
	end

	return {
		utils.strip_trailing_whitespace(string.sub(input, 1, pos - 1)),
		utils.strip_trailing_whitespace(string.sub(input, pos + 1)),
	}
end

---@param str string
---@return string[]
function utils.split_by_whitespace(str)
	local result = {}
	for word in string.gmatch(str, "%S+") do
		table.insert(result, word)
	end
	return result
end

return utils
