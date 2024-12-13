---@type Class
local Class = require("libs.class")

---@class ShriftParser : Class
local Parser = Class:extend()

---@enum ShriftLineType
LINE_TYPE = {
	["ASSIGN"] = "%$",
	["LABEL"] = "%[",
	["CHOICE"] = "%*",
	["DIALOGUE"] = "%w",
	["ILLEGAL"] = "ILLEGAL",
}

---@param input string
function Parser:init(input)
	self.input = input
	self.lines = {}
end

---@param line string
---@return string
local function strip_trailing_whitespace(line)
	local stripped = line:match("^%s*(.-)%s*$")
	return stripped
end

---@return string[]
function Parser:split_lines()
	local lines = {}

	for line in self.input:gmatch("[^\r\n]+") do
		table.insert(lines, strip_trailing_whitespace(line))
	end

	return lines
end

---@param line string
---@return string
function Parser:get_line_type(line)
	local first = line:sub(1, 1)

	for type, prefix in pairs(LINE_TYPE) do
		if first:match(prefix) then
			return type
		end
	end

	return "ILLEGAL"
end

return Parser
