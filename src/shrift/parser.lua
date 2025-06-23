local Class = require("libs.class") --[[@as Class]]
local utils = require("shrift.utils") --[[@as shrift.utils]]
local line_data = require("shrift.line") --[[@as shrift.line_data]]
local inspect = require("libs.inspect")

---@class shrift.Parser : Class
local Parser = Class:extend()

---@enum ShriftLineType
LINE_TYPE = {
	["ASSIGN"] = "%$",
	["LABEL"] = "%[",
	["CHOICE"] = "%*",
	["DIALOGUE"] = "^[%a{]",
	["ILLEGAL"] = "ILLEGAL",
}

---@param input string
function Parser:init(input)
	self.input = input
	self.lines = {}
	self.line_count = 0
	self.label_ids = {}
	self.errors = {}

	self:split_lines()
	self:parse_lines()

	for _, err in pairs(self.errors) do
		io.write(err)
	end
end

---@param path string
function Parser:parse_file(path)
	-- Parse file.
end

function Parser:inspect()
	print("label_ids = " .. inspect(self.label_ids))
	print("lines = " .. inspect(self.lines))
end

local err_template = [[

shrift: error at line %d
	-> '%s'
%s
]]

function Parser:error(line, message)
	local err = string.format(err_template, line.num, line.str, message)
	table.insert(self.errors, err)
end

function Parser:split_lines()
	local i = 1
	local id = 1

	for str in self.input:gmatch("([^\n]*)\n?") do
		local stripped = utils.strip_trailing_whitespace(str)
		stripped = stripped:match("^(.-)#") or stripped
		stripped = utils.strip_trailing_whitespace(stripped)

		-- Check line is not a comment or empty.
		if stripped:sub(1, 1) ~= "#" and stripped ~= "" then
			local type = self:get_line_type(stripped)
			local line = line_data.new(i, id, type, stripped)

			if type == "ILLEGAL" then
				self:error(line, "Invalid line type")
			end

			-- table.insert(self.lines, line)
			self.lines[id] = line
			id = id + 1
			self.line_count = self.line_count + 1
		end

		i = i + 1
	end
end

---@param line string
---@return string
function Parser:get_line_type(line)
	local first = string.sub(line, 1, 1)

	for type, prefix in pairs(LINE_TYPE) do
		if first:match(prefix) then
			return type
		end
	end

	return "ILLEGAL"
end

function Parser:parse_lines()
	for _, line in pairs(self.lines) do
		---@cast line shrift.LineData
		local data = nil

		if line.type == "DIALOGUE" then
			data = self:parse_dialogue(line)
		elseif line.type == "CHOICE" then
			data = self:parse_choice(line)
		elseif line.type == "LABEL" then
			data = self:parse_label(line)
		elseif line.type == "ASSIGN" then
			data = self:parse_assign(line)
		end

		---@cast data table
		line.data = data
	end
end

---@param line shrift.LineData
---@return table
function Parser:parse_label(line)
	local label_name = string.match(line.str, "%[(.-)%]")

	if not label_name then
		self:error(line, "Labels must be enclosed in brackets")
	end

	-- TODO: Check if label name already exists.

	self.label_ids[label_name] = line.id
	return { name = label_name }
end

---@param line string
---@return string
function Parser:parse_condition(line)
	local condition = string.match(line, "^%{(.-)%}")

	if condition then
		condition = utils.strip_trailing_whitespace(condition)
	end

	return condition
end

---@param line shrift.LineData
---@return table
function Parser:parse_dialogue(line)
	local condition = nil

	if line.str:sub(1, 1) == "{" then
		condition = self:parse_condition(line.str)
		if not condition then
			self:error(line, "Conditions must be enclosed in braces")
		end
	end

	local line_content = line.str
	if condition then
		line_content = line.str:match("}(.+)")
	end

	local parts = utils.split_str(line_content, ":")

	if not parts then
		self:error(line, "Dialogue must contain a character name and text seperated by a ':'")
		return {}
	end

	return {
		character = parts[1],
		text = parts[2],
		condition = condition,
		result = nil,
	}
end

---@param line shrift.LineData
---@return table
function Parser:parse_choice(line)
	local line_content = line.str:sub(2, #line.str)
	line_content = utils.strip_trailing_whitespace(line_content)

	local condition = nil

	if line_content:sub(1, 1) == "{" then
		condition = self:parse_condition(line_content)
		if not condition then
			self:error(line, "Conditions must be enclosed in braces")
		end
	end

	if condition then
		line_content = line.str:match("}(.+)")
	end

	local parts = utils.split_str(line_content, ":")

	local text = utils.strip_trailing_whitespace(line_content)
	local destination = nil

	if parts then
		text = utils.strip_trailing_whitespace(parts[1])
		destination = utils.strip_trailing_whitespace(parts[2])
	end

	local data = {
		text = text,
		destination = destination,
		condition = condition,
		result = nil,
	}

	return data
end

---@param line shrift.LineData
---@return table
function Parser:parse_assign(line)
	local line_content = line.str:sub(2, #line.str)
	line_content = utils.strip_trailing_whitespace(line_content)

	local parts = utils.split_str(line_content, "=")

	if not parts then
		self:error(line, "Variables must be given a name and a value seperated by '='")
		return {}
	end

	if parts[1] == "" then
		self:error(line, "Variables must be given a name")
		return {}
	end

	if parts[2] == "" then
		self:error(line, "Variables must be given a value")
		return {}
	end

	if parts[1]:match("[^%a_]") then
		self:error(line, "Variables names may only contain letters and underscores.")
		return {}
	end

	local data = {
		name = parts[1],
		value = parts[2],
	}

	return data
end

return Parser
