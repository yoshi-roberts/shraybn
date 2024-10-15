local token = require("shrift.token") --[[@as token]]
local ast = require("shrift.ast") --[[@as ast]]
local Lexer = require("shrift.lexer") --[[@as Lexer]]
local Parser = require("shrift.parser") --[[@as Parser]]
local utils = require("shrift.tests.utils") --[[@as test_utils]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

it("Parse Return Statements", function()
	local tests = {
		{ "return 5\n", 5 },
		{ "return true", true },
		{ "return false\n", false },
		{ "return y\n", "y" },
	}

	for _, v in pairs(tests) do
		local input = v[1]
		local expected_val = v[2]

		---@type Lexer
		local l = Lexer(input)
		---@type Parser
		local p = Parser(l)

		---@type ASTProgram
		local program = p:parse_program()
		utils.check_parse_errors(p)

		expect(#program.statements).to.equal(1)

		local stmt = program.statements[1]
		---@cast stmt ASTReturnStatement
		expect(stmt:literal()).to.equal("return")

		local val = stmt.return_value
		utils.test_literal_expression(val, expected_val)
	end
end)
