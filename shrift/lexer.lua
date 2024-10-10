Object = require("libs.classic")
---@type Token
local Token = require("shrift.token")

---@class Lexer
local Lexer = Object:extend()

---@param input string
function Lexer:new(input)
	self.input = input
	self.position = 0
	self.read_position = 1
	self.ch = ""

	self:read_char()
end

function Lexer:read_char()
	if self.read_position >= #self.input + 1 then
		self.ch = ""
	else
		self.ch = self.input:sub(self.read_position, self.read_position)
	end

	self.position = self.read_position
	self.read_position = self.read_position + 1
end

---@return TokenData
function Lexer:next_token()
	local tok

	if self.ch == "=" then
		tok = Token.new(Token.types.ASSIGN, self.ch)
	elseif self.ch == "(" then
		tok = Token.new(Token.types.LPAREN, self.ch)
	elseif self.ch == ")" then
		tok = Token.new(Token.types.RPAREN, self.ch)
	elseif self.ch == "+" then
		tok = Token.new(Token.types.PLUS, self.ch)
	elseif self.ch == "{" then
		tok = Token.new(Token.types.LBRACE, self.ch)
	elseif self.ch == "}" then
		tok = Token.new(Token.types.RBRACE, self.ch)
	elseif self.ch == "" then
		tok = Token.new(Token.types.EOF, "")
	end

	self:read_char()
	return tok
end

return Lexer
