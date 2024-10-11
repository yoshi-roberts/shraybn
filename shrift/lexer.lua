Object = require("libs.classic")
---@type Token
local token = require("shrift.token")

---@class Lexer
local lexer = Object:extend()

---@param input string
function lexer:new(input)
	self.input = input
	self.position = 0
	self.read_position = 1
	self.ch = ""

	self:read_char()
end

function lexer:read_char()
	if self.read_position >= #self.input + 1 then
		self.ch = ""
	else
		self.ch = self.input:sub(self.read_position, self.read_position)
	end

	self.position = self.read_position
	self.read_position = self.read_position + 1
end

---@return TokenData
function lexer:next_token()
	local tok

	if self.ch == "=" then
		tok = token.new(token.TYPES.ASSIGN, self.ch)
	elseif self.ch == "(" then
		tok = token.new(token.TYPES.LPAREN, self.ch)
	elseif self.ch == ")" then
		tok = token.new(token.TYPES.RPAREN, self.ch)
	elseif self.ch == "+" then
		tok = token.new(token.TYPES.PLUS, self.ch)
	elseif self.ch == "{" then
		tok = token.new(token.TYPES.LBRACE, self.ch)
	elseif self.ch == "}" then
		tok = token.new(token.TYPES.RBRACE, self.ch)
	elseif self.ch == "" then
		tok = token.new(token.TYPES.EOF, "")
	end

	self:read_char()
	return tok
end

return lexer
