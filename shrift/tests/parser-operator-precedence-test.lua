local Lexer = require("shrift.lexer") --[[@as Lexer]]
local Parser = require("shrift.parser") --[[@as Parser]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

---@param parser Parser
local function check_parse_errors(parser)
	if #parser.errors == 0 then
		return
	end

	print(string.format("Parser has %d errors.", #parser.errors))
	for _, msg in pairs(parser.errors) do
		print("Parser error: " .. msg)
	end

	-- Fail if we have any errors.
	expect(#parser.errors).to.equal(0)
end

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
		check_parse_errors(p)

		local actual = tostring(program)
		expect(actual).to.equal(expected)
	end
end)
