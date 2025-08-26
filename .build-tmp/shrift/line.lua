---@class shrift.line_data
local line_data = {}

---@class shrift.LineData
---@field num integer
---@field id integer
---@field type string
---@field str string
---@field data table
local line = {}

---@param num integer
---@param id integer
---@param type string
---@param content string
---@return shrift.LineData
function line_data.new(num, id, type, content)
	return {
		num = num,
		id = id,
		type = type,
		str = content,
		data = {},
	}
end

return line_data
