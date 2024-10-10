---@type Lexer
local Lexer = require("shrift.lexer")
---@type Token
local Token = require("shrift.token")
local lust = require("libs.lust")
local describe, it, expect = lust.describe, lust.it, lust.expect

describe("Shrift", function()
	lust.before(function()
		-- Runs before every test.
	end)

	it("Next Token", function()
		local tokens = {
			{ Token.types.ASSIGN, "=" },
			{ Token.types.PLUS, "+" },
			{ Token.types.LPAREN, "(" },
			{ Token.types.RPAREN, ")" },
			{ Token.types.LBRACE, "{" },
			{ Token.types.RBRACE, "}" },
			{ Token.types.EOF, "" },
		}

		---@type Lexer
		local l = Lexer("=+(){}")

		for _, v in pairs(tokens) do
			local tok = l:next_token()

			expect(tok.type).to.equal(v[1])
			expect(tok.literal).to.equal(v[2])
		end
	end)
end)
