local lexer = Object:extend()

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
function lexer:new(input)
	self.input = input
	self.position = 0
	self.read_position = 0
	self.ch = ""

	self:read_char()
end

function lexer:read_char()
	if self.read_position >= #self.input then
		self.ch = 0
	else
		self.ch = self.input:sub(self.read_position, self.read_position)
	end
	self.position = self.read_position
	self.read_position = self.read_position + 1
end

local function is_letter(char)
	return char:match("%a") or (char == "_")
end

function lexer:read_identifier()
	local position = self.position

	while is_letter(self.ch) do
		self:read_char()
	end

	return self.input:sub(position, self.position)
end

function lexer:next_token()
	local tok

	if self.ch == "=" then
		tok = token_new(TOKEN.COMPARE, self.ch --[[@as string]], 0)
	elseif self.ch == "+" then
		tok = token_new(TOKEN.PLUS, self.ch --[[@as string]], 0)
	elseif self.ch == "+" then
		tok = token_new(TOKEN.PLUS, self.ch --[[@as string]], 0)
	elseif self.ch == "$" then
		tok = token_new(TOKEN.DEFINE, self.ch --[[@as string]], 0)
	elseif self.ch == "(" then
		tok = token_new(TOKEN.LPAREN, self.ch --[[@as string]], 0)
	elseif self.ch == ")" then
		tok = token_new(TOKEN.RPAREN, self.ch --[[@as string]], 0)
	elseif self.ch == 0 then
		tok = token_new(TOKEN.EOF, "", 0)
	else
		if is_letter(self.ch) then
			-- Read Indentifier.
			return tok
		else
			tok = token_new(TOKEN.ILLEGAL, self.ch --[[@as string]], 0)
		end
	end

	self:read_char()
	return tok
end

return lexer
