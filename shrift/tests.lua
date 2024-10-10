local lexer = require("shrift.lexer")
local token = require("shrift.token")
local lust = require("libs.lust")
local describe, it, expect = lust.describe, lust.it, lust.expect

describe("Shrift", function()
	lust.before(function()
		-- Runs before every test.
	end)

	it("Next Token", function()
		local tokens = {
			{ token.type.ASSIGN, "=" },
			{ token.type.PLUS, "+" },
			{ token.type.LPAREN, "(" },
			{ token.type.RPAREN, ")" },
			{ token.type.LBRACE, "{" },
			{ token.type.RBRACE, "}" },
			{ token.type.EOF, "" },
		}

		local l = lexer("=+(){}")

		for _, v in pairs(tokens) do
			local tok = l:next_token()

			expect(tok.type).to.equal(v[1])
			expect(tok.literal).to.equal(v[2])
		end
	end)
end)
