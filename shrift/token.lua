---@class token
local token = {}

---@enum
token.type = {
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

---@param type string
---| `token.type`
---@param literal string
function token.new(type, literal)
	return {
		type = type,
		literal = literal,
	}
end

return token
