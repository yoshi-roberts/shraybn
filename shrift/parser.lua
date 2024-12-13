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

	self:split_lines()
	self:parse_lines()

	for _, err in pairs(self.errors) do
		print(err)
	end
end

function Parser:error(line, message)
	local err = string.format("Shrift: Error at line %d\n%s", line.num, message)
	table.insert(self.errors, err)
end

function Parser:split_lines()
	local i = 1
	for str in self.input:gmatch("[^\r\n]+") do
		local stripped = util.strip_trailing_whitespace(str)
		local line = line_data.new(i, stripped)
		table.insert(self.lines, line)
		i = i + 1
	end
end

function Parser:parse_lines()
	for _, line in pairs(self.lines) do
		---@cast line ShriftLineData
		local type = self:get_line_type(line)
		local data = nil

		if type == "DIALOGUE" then
			data = self:parse_dialogue(line)
		elseif type == "LABEL" then
			data = self:parse_label(line)
		end

		---@cast data table
		line.data = data
	end
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
---@return table
function Parser:parse_dialogue(line)
	local parts = util.split_str(line.str, ":")

	if not parts then
		self:error(line, "Dialogue must contain a character name and text seperated by a ':'")
		return {}
	end

	return {
		character = parts[1],
		text = parts[2],
	}
end

---@param line ShriftLineData
function Parser:parse_label(line)
	local label_name = string.match(line.str, "^%[(.-)%]$")

	if not label_name then
		self:error(line, "Labels must be enclosed in brackets.")
	end

	return { name = label_name }
end

return Parser
