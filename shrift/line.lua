---@class shrift.line_data
local line_data = {}

---@class shrift.LineData
---@field num integer
---@field type string
---@field str string
---@field data table
local line = {}

---@param num integer
---@param type string
---@param content string
---@return shrift.LineData
function line_data.new(num, type, content)
	return {
		num = num,
		type = type,
		str = content,
		data = {},
	}
end

return line_data
