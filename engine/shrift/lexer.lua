local lexer = Object:extend()
local pprint = require("libs.pprint")

local env = {
	vars = {},
}

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
	[";"] = "end",
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

		if self.current_scope then
			data.scope = self.current_scope
		end
		table.insert(self.section, data)
	end,
	["assign"] = function(self, line, num)
		line = line:sub(2, #line)

		if #line <= 0 then
			error(num, "No variable name provided.")
		end

		local parts = {}
		for str in line:gmatch("([^ ]+)") do
			table.insert(parts, str)
		end

		print(parts[1])
		-- -- Make sure variable name is valid.
		-- if parts[1]:sub(1, 1):match("%d") then
		-- 	error(num, "Variable names can not start with a digit.")
		-- end

		if not parts[1]:match("^[_%a][_%w]*$") then
			error(num, "Variable names may only contain alphanumeric characters.")
		end
	end,

	["evaluate"] = function(self, line, num)
		local data = {
			type = "evaluate",
		}

		local expression = line:sub(2, #line)
		expression = trim_whitespace(expression)

		if #expression <= 0 then
			error(num, "No expression to evaluate.")
		end

		local parts = {}
		for str in expression:gmatch("([^ ]+)") do
			-- print(str .. "|")
			table.insert(parts, str)
		end

		local var_name = parts[1]:sub(2, #parts[1])

		if parts[1]:sub(1, 1) ~= "$" then
			error(num, "Unrecognized '" .. var_name .. "'")
		end

		if not env.vars[var_name] then
			error(num, "No variable named '" .. var_name .. "'")
		end

		local operators = {
			["=="] = "equal",
			["!="] = "not_equal",
			["<"] = "lesser",
			[">"] = "greater",
			["<="] = "less_or_equal",
			[">="] = "greater_or_equal",
		}

		local operator = operators[parts[2]]

		if not operator then
			error(num, "Invalid operator '" .. parts[2] .. "'")
		end

		-- print(expression)
		--
		-- local untrusted_function, message = load(expression, nil, "t", env)
		-- if not untrusted_function then
		-- 	error(num, message)
		-- else
		-- 	local result = pcall(untrusted_function)
		-- 	print(result)
		-- end
		-- if not untrusted_function then return nil, message end
		-- return pcall(untrusted_function)

		if self.current_scope then
			data.scope = self.current_scope
		end
		table.insert(self.section, data)

		table.insert(self.scopes, self.section[#self.section])
		self.current_scope = self.scopes[#self.scopes]
	end,

	["section"] = function(self, line, num)
		local title = line:sub(2, #line)
		title = trim_whitespace(title)

		if #title <= 0 then
			error(num, "Title name missing.")
		end

		self.tree[title] = {}
		self.section = self.tree[title]
	end,

	["choice"] = function(self, line, num)
		local data = {
			type = "choice",
		}

		local choice = line:sub(2, #line)
		choice = trim_whitespace(choice)

		if #choice <= 0 then
			error(num, "Choice text missing.")
		end

		data.text = choice

		if self.current_scope then
			data.scope = self.current_scope
		end
		table.insert(self.section, data)

		table.insert(self.scopes, self.section[#self.section])
		self.current_scope = self.scopes[#self.scopes]
	end,
	["command"] = function(self, line, num) end,
	["whitespace"] = function(self, line, num) end,
	["end"] = function(self, line, num)
		line = trim_whitespace(line)

		if not self.current_scope then
			error(num, "Trying to exit nonexistent scope.")
		end

		table.remove(self.scopes, #self.scopes)
		self.current_scope = self.scopes[#self.scopes]
	end,
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
	self.scopes = {}
	self.current_scope = nil

	self.tree = {
		[1] = {},
	}

	self.section = self.tree[1]
	self:set_section(self.tree[1])
end

function lexer:set_section(section)
	self.prev_section = self.section
	self.section = section
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
