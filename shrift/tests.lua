---@type Lexer
local lexer = require("shrift.lexer")
---@type Token
local token = require("shrift.token")
local lust = require("libs.lust")
local describe, it, expect = lust.describe, lust.it, lust.expect

describe("Shrift", function()
	lust.before(function()
		-- Runs before every test.
	end)

	it("Next Token", function()
		local tests = {
			{ token.TYPE.LET, "let" },
			{ token.TYPE.IDENT, "five" },
			{ token.TYPE.ASSIGN, "=" },
			{ token.TYPE.INT, "5" },
			{ token.TYPE.LET, "let" },
			{ token.TYPE.IDENT, "ten" },
			{ token.TYPE.ASSIGN, "=" },
			{ token.TYPE.INT, "10" },
			{ token.TYPE.LET, "let" },
			{ token.TYPE.IDENT, "add" },
			{ token.TYPE.ASSIGN, "=" },
			{ token.TYPE.FUNCTION, "fn" },
			{ token.TYPE.LPAREN, "(" },
			{ token.TYPE.IDENT, "x" },
			{ token.TYPE.COMMA, "," },
			{ token.TYPE.IDENT, "y" },
			{ token.TYPE.RPAREN, ")" },
			{ token.TYPE.LBRACE, "{" },
			{ token.TYPE.IDENT, "x" },
			{ token.TYPE.PLUS, "+" },
			{ token.TYPE.IDENT, "y" },
			{ token.TYPE.RBRACE, "}" },
			{ token.TYPE.LET, "let" },
			{ token.TYPE.IDENT, "result" },
			{ token.TYPE.ASSIGN, "=" },
			{ token.TYPE.IDENT, "add" },
			{ token.TYPE.LPAREN, "(" },
			{ token.TYPE.IDENT, "five" },
			{ token.TYPE.COMMA, "," },
			{ token.TYPE.IDENT, "ten" },
			{ token.TYPE.RPAREN, ")" },
			{ token.TYPE.BANG, "!" },
			{ token.TYPE.MINUS, "-" },
			{ token.TYPE.SLASH, "/" },
			{ token.TYPE.ASTERISK, "*" },
			{ token.TYPE.INT, "5" },
			{ token.TYPE.INT, "5" },
			{ token.TYPE.LT, "<" },
			{ token.TYPE.INT, "10" },
			{ token.TYPE.GT, ">" },
			{ token.TYPE.INT, "5" },
			{ token.TYPE.IF, "if" },
			{ token.TYPE.LPAREN, "(" },
			{ token.TYPE.INT, "5" },
			{ token.TYPE.LT, "<" },
			{ token.TYPE.INT, "10" },
			{ token.TYPE.RPAREN, ")" },
			{ token.TYPE.LBRACE, "{" },
			{ token.TYPE.RETURN, "return" },
			{ token.TYPE.TRUE, "true" },
			{ token.TYPE.RBRACE, "}" },
			{ token.TYPE.ELSE, "else" },
			{ token.TYPE.LBRACE, "{" },
			{ token.TYPE.RETURN, "return" },
			{ token.TYPE.FALSE, "false" },
			{ token.TYPE.RBRACE, "}" },
			{ token.TYPE.EOF, "" },
		}

		local input = [[
let five = 5
let ten = 10

let add = fn(x, y) {
	x + y
}

let result = add(five, ten)
!-/*5
5 < 10 > 5

if (5 < 10) {
	return true
} else {
	return false
}
		]]

		---@type Lexer
		local l = lexer(input)

		for _, v in pairs(tests) do
			local tok = l:next_token()

			print(tok.literal, tok.type)
			expect(tok.type).to.equal(v[1])
			expect(tok.literal).to.equal(v[2])
		end
	end)
end)
