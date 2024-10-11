---@class Token
local token = {}

---@enum TokenTypes
token.TYPE = {
	ILLEGAL = "ILLEGAL",
	EOF = "EOF",

	-- Identifiers and literals.
	IDENT = "IDENT",
	INT = "INT",

	-- Operators.
	ASSIGN = "=",
	PLUS = "+",

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

---@alias TokenData {type: TokenTypes, literal: string}
---@param type TokenTypes
---@param literal string
---@return TokenData
function token.new(type, literal)
	return {
		type = type,
		literal = literal,
	}
end

return token
