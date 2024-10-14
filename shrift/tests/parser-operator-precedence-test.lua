local Lexer = require("shrift.lexer") --[[@as Lexer]]
local Parser = require("shrift.parser") --[[@as Parser]]
local utils = require("shrift.tests.utils")
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

it("Parse Operator Precedence", function()
	local tests = {
		{ "-a * b", "((-a) * b)" },
		{ "!-a", "(!(-a))" },
		{ "a + b + c", "((a + b) + c)" },
		{ "a + b - c", "((a + b) - c)" },
		{ "a * b * c", "((a * b) * c)" },
		{ "a * b / c", "((a * b) / c)" },
		{ "a + b / c", "(a + (b / c))" },
		{ "a + b * c + d / e - f", "(((a + (b * c)) + (d / e)) - f)" },
		{ "3 + 4\n -5 * 5", "(3 + 4)((-5) * 5)" },
		{ "5 > 4 == 3 < 4", "((5 > 4) == (3 < 4))" },
		{ "5 < 4 != 3 > 4", "((5 < 4) != (3 > 4))" },
		{
			"3 + 4 * 5 == 3 * 1 + 4 * 5",
			"((3 + (4 * 5)) == ((3 * 1) + (4 * 5)))",
		},
		{
			"3 + 4 * 5 == 3 * 1 + 4 * 5",
			"((3 + (4 * 5)) == ((3 * 1) + (4 * 5)))",
		},
		{ "true", "true" },
		{ "false", "false" },
		{ "3 > 5 == false", "((3 > 5) == false)" },
		{ "3 < 5 == true", "((3 < 5) == true)" },
		-- Grouped Expressions --
		{ "1 + (2 + 3) + 4", "((1 + (2 + 3)) + 4)" },
		{ "(5 + 5) * 2", "((5 + 5) * 2)" },
		{ "2 / (5 + 5)", "(2 / (5 + 5))" },
		{ "-(5 + 5)", "(-(5 + 5))" },
		{ "!(true == true)", "(!(true == true))" },
	}

	for _, v in pairs(tests) do
		local input = v[1]
		local expected = v[2]

		---@type Lexer
		local l = Lexer(input)
		---@type Parser
		local p = Parser(l)
		---@type ASTProgram
		local program = p:parse_program()
		utils.check_parse_errors(p)

		local actual = tostring(program)
		expect(actual).to.equal(expected)
	end
end)
