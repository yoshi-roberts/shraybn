---@class Token
local token = {}

---@enum TokenType
token.TYPE = {
	ILLEGAL = "ILLEGAL",
	EOF = "EOF",

	-- Identifiers and literals.
	IDENT = "IDENT",
	INT = "INT",

	-- Operators.
	ASSIGN = "=",
	PLUS = "+",
	MINUS = "-",
	BANG = "!",
	ASTERISK = "*",
	SLASH = "/",
	LT = "<",
	GT = ">",

	-- Delimiters.
	COMMA = ",",

	LPAREN = "(",
	RPAREN = ")",
	LBRACE = "{",
	RBRACE = "}",

	-- Keywords.
	FUNCTION = "FUNCTION",
	LET = "LET",
}

local keywords = {
	["fn"] = token.TYPE.FUNCTION,
	["let"] = token.TYPE.LET,
}

---@alias TokenData {type: TokenType, literal: string}
---@param type TokenType
---@param literal string
---@return TokenData
function token.new(type, literal)
	return {
		type = type,
		literal = literal,
	}
end

---@param ident string
---@return TokenType
function token.lookup_ident(ident)
	if keywords[ident] then
		return keywords[ident]
	end

	return token.TYPE.IDENT
end

return token
