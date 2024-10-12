Object = require("libs.classic")
---@type token
local token = require("shrift.token")

---@class Lexer
local lexer = Object:extend()

---@private
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
	local tok = {}

	self:skip_whitespace()

	if self.ch == "=" then
		if self:peek_char() == "=" then
			local ch = self.ch
			self:read_char()
			tok = token.new(token.TYPE.EQ, ch .. self.ch)
		else
			tok = token.new(token.TYPE.ASSIGN, self.ch)
		end
	elseif self.ch == "+" then
		tok = token.new(token.TYPE.PLUS, self.ch)
	elseif self.ch == "-" then
		tok = token.new(token.TYPE.MINUS, self.ch)
	elseif self.ch == "!" then
		if self:peek_char() == "=" then
			local ch = self.ch
			self:read_char()
			tok = token.new(token.TYPE.NOT_EQ, ch .. self.ch)
		else
			tok = token.new(token.TYPE.BANG, self.ch)
		end
	elseif self.ch == "/" then
		tok = token.new(token.TYPE.SLASH, self.ch)
	elseif self.ch == "*" then
		tok = token.new(token.TYPE.ASTERISK, self.ch)
	elseif self.ch == "<" then
		tok = token.new(token.TYPE.LT, self.ch)
	elseif self.ch == ">" then
		tok = token.new(token.TYPE.GT, self.ch)
	elseif self.ch == "(" then
		tok = token.new(token.TYPE.LPAREN, self.ch)
	elseif self.ch == ")" then
		tok = token.new(token.TYPE.RPAREN, self.ch)
	elseif self.ch == "," then
		tok = token.new(token.TYPE.COMMA, self.ch)
	elseif self.ch == "\n" then
		tok = token.new(token.TYPE.NEWLINE, self.ch)
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
			tok.type = token.lookup_ident(tok.literal)
			return tok
		elseif self:is_digit() then
			tok.type = token.TYPE.INT
			tok.literal = self:read_number()
			return tok
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

	return self.input:sub(position, self.position - 1)
end

---@return string
function lexer:read_number()
	local position = self.position

	while self:is_digit() do
		self:read_char()
	end

	return self.input:sub(position, self.position - 1)
end

function lexer:skip_whitespace()
	while self.ch:match(" ") or self.ch == "\t" or self.ch == "\r" do
		self:read_char()
	end
end

function lexer:peek_char()
	if self.read_position >= #self.input then
		return ""
	else
		return self.input:sub(self.read_position, self.read_position)
	end
end

---@return boolean
function lexer:is_letter()
	return self.ch:match("%a") or self.ch == "_"
end

---@return boolean
function lexer:is_digit()
	return self.ch:match("%d")
end

return lexer
