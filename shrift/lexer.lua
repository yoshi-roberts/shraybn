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
	---@type TokenData
	local tok

	if self.ch == "=" then
		tok = token.new(token.TYPE.ASSIGN, self.ch)
	elseif self.ch == "(" then
		tok = token.new(token.TYPE.LPAREN, self.ch)
	elseif self.ch == ")" then
		tok = token.new(token.TYPE.RPAREN, self.ch)
	elseif self.ch == "+" then
		tok = token.new(token.TYPE.PLUS, self.ch)
	elseif self.ch == "{" then
		tok = token.new(token.TYPE.LBRACE, self.ch)
	elseif self.ch == "}" then
		tok = token.new(token.TYPE.RBRACE, self.ch)
	elseif self.ch == "" then
		tok = token.new(token.TYPE.EOF, "")
	else -- Default.
		if self:is_letter() then
			tok.literal = self:read_identifier()
		else
			tok = token.new(token.TYPE.ILLEGAL, self.ch)
		end
	end

	self:read_char()
	return tok
end

---@return string
function lexer:read_identifier()
	local position = self.position

	while self:is_letter() do
		self:read_char()
	end

	return self.input:sub(position, self.position)
end

---@return boolean
function lexer:is_letter()
	return self.ch:match("%a") or self.ch == "_"
end

return lexer
