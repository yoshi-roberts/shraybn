---@class shrift.line_data
local line_data = {}

---@class ShriftLineData
---@field num integer
---@field str string
---@field data table
local line = {}

---@param num integer
---@return ShriftLineData
function line_data.new(num, str)
	return {
		num = num,
		str = str,
		data = {},
	}
end

return line_data
