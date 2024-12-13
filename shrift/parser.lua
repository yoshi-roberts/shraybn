local Class = require("libs.class") --[[@as Class]]
local util = require("shrift.util") --[[@as shrift.util]]
local line_data = require("shrift.line") --[[@as shrift.line_data]]

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
	self.errors = {}
end

function Parser:error(line, message)
	local err = string.format("Shrift: Error at line %d\n%s", line.num, message)
	table.insert(self.errors, err)
end

---@return ShriftLineData[]
function Parser:split_lines()
	local lines = {}

	local i = 1
	for str in self.input:gmatch("[^\r\n]+") do
		local stripped = util.strip_trailing_whitespace(str)
		local line = line_data.new(i, stripped)
		table.insert(lines, line)
		i = i + 1
	end

	return lines
end

---@param line ShriftLineData
---@return string
function Parser:get_line_type(line)
	local first = line.str:sub(1, 1)

	for type, prefix in pairs(LINE_TYPE) do
		if first:match(prefix) then
			return type
		end
	end

	return "ILLEGAL"
end

---@param line ShriftLineData
---@return string[]?
function Parser:parse_dialogue(line)
	local parts = util.split_str(line.str, ":")

	if not parts then
		self:error(line, "Dialogue must contain a character name and text seperated by a ':'")
	end

	return parts
end

---@param line ShriftLineData
function Parser:parse_label(line)
	local label_name = string.match(line.str, "^%[(.-)%]$")

	if not label_name then
		self:error(line, "Labels must be enclosed in brackets.")
	end
end

return Parser
