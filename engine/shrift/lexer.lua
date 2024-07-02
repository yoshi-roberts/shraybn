local lexer = Object:extend()
local pprint = require("libs.pprint")

local function trim_whitespace(line)
	return line:gsub("^%s*(.-)%s*$", "%1")
end

local function error(num, message)
	Log.error("[SHRIFT] Error at line " .. num .. ". " .. message)
end

local prefix = {
	["%a"] = "text",
	["%$"] = "assign",
	["?"] = "evaluate",
	["#"] = "section",
	["*"] = "choice",
	["@"] = "command",
}

---@alias parse_fun fun(self: table, line: string, num: integer)
---@type {[string]: parse_fun}
local parse_function = {
	["text"] = function(self, line, num)
		local colon_pos = line:find(":")

		local data = {
			type = "text",
		}

		-- Dialogue.
		if colon_pos then
			local name = line:sub(1, colon_pos - 1)
			data.name = trim_whitespace(name)

			local contents = line:sub(colon_pos + 1, #line)
			contents = trim_whitespace(contents)

			if #contents <= 0 then
				error(num, "Missing dialogue text.")
			end

			data.contents = contents
		else -- Text.
			data.contents = trim_whitespace(line)
		end

		table.insert(self.section, data)
	end,
	["assign"] = function(self, line, num) end,
	["evaluate"] = function(self, line, num) end,

	["section"] = function(self, line, num)
		local title = line:sub(2, #line)
		title = trim_whitespace(title)

		if #title <= 0 then
			error(num, "Title name missing.")
		end

		print("Title: " .. title)
	end,

	["choice"] = function(self, line, num)
		local choice = line:sub(2, #line)
		choice = trim_whitespace(choice)

		if #choice <= 0 then
			error(num, "Choice text missing.")
		end

		print("Choice: " .. choice)
	end,
	["command"] = function(self, line, num) end,
	["whitespace"] = function(self, line, num) end,
}

local function get_type(char)
	for pattern, type in pairs(prefix) do
		if char:match(pattern) then
			return type
		end
	end
end

---@param path string
function lexer:new(path)
	local file = io.open(path, "r")

	if not file then
		return
	end

	local data = file:read("*a")
	self.input = data
	self.tree = {
		[1] = {},
	}
	self.section = self.tree[1]
end

function lexer:lex()
	local num = 1

	for line in self.input:gmatch("([^\n]*)\n?") do
		line = trim_whitespace(line)

		local first = line:sub(1, 1)
		local type

		if #line <= 0 then
			type = "whitespace"
		else
			type = get_type(first)
		end

		if not type then
			error(num, "Invalid line prefix.")
		end

		local fn = parse_function[type]
		fn(self, line, num)

		num = num + 1
	end

	pprint(self.tree)
end

return lexer
