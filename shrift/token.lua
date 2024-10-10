---@class Token
local Token = {}

---@enum TokenTypes
Token.types = {
	ILLEGAL = "ILLEGAL",
	EOF = "EOF",

	-- Identifiers and literals.
	IDENT = "IDENT",
	INT = "INT",

	-- Operators.
	ASSIGN = "=",
	PLUS = "+",

	LPAREN = "(",
	RPAREN = ")",
	LBRACE = "{",
	RBRACE = "}",

	-- Keywords.
	LET = "LET",
}

---@alias TokenData {type: TokenTypes, literal: string}
---@param type TokenTypes
---@param literal string
---@return TokenData
function Token.new(type, literal)
	return {
		type = type,
		literal = literal,
	}
end

return Token
