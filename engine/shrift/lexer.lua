Lexer = Object:extend()

---@enum TOKEN
TOKEN = {
	ILLEGAL = "ILLEGAL",
	EOF = "EOF",

	IDENT = "IDENT",
	INT = "INT",

	COMPARE = "=",
	PLUS = "+",

	LPAREN = "(",
	RPAREN = ")",
	DEFINE = "$",
}

---@alias tokenType string
---@alias token table<tokenType, string, integer>

---@param type string
---@param literal string
---@param line integer
---@return token
local function token_new(type, literal, line)
	return {
		type = type,
		literal = literal,
		line = line,
	}
end

---@param input string
function Lexer:new(input)
	self.input = input
	self.position = 0
	self.read_position = 0
	self.ch = ""

	self:read_char()
end

function Lexer:read_char()
	if self.read_position >= #self.input then
		self.ch = 0
	else
		self.ch = self.input:sub(self.read_position, self.read_position)
	end
	self.position = self.read_position
	self.read_position = self.read_position + 1
end
