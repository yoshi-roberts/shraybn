local ast = require("shrift.ast") --[[@as ast]]
local Lexer = require("shrift.lexer") --[[@as Lexer]]
local Parser = require("shrift.parser") --[[@as Parser]]
local utils = require("shrift.tests.utils") --[[@as test_utils]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

it("Parse Call Expression Parameters", function()
	local tests = {
		{ "add()\n", {} },
		{ "add(x)\n", { "x" } },
		{ "add(x, y)\n", { "x", "y" } },
		{ "add(x, y, z)\n", { "x", "y", "z" } },
	}

	for _, v in pairs(tests) do
		local input = v[1]
		local expected_args = v[2]

		---@type Lexer
		local l = Lexer(input)
		---@type Parser
		local p = Parser(l)
		---@type ASTProgram
		local program = p:parse_program()
		utils.check_parse_errors(p)

		expect(#program.statements).to.equal(1)

		local stmt = program.statements[1]
		---@cast stmt ASTExpressionStatement
		expect(stmt:is(ast.ExpressionStatement)).to.equal(true)

		local exp = stmt.expression
		---@cast exp ASTCallExpression
		expect(exp:is(ast.CallExpression)).to.equal(true)

		utils.test_identifier(exp.func, "add")

		expect(#exp.arguments).to.equal(#expected_args)

		for i, ident in pairs(expected_args) do
			utils.test_literal_expression(exp.arguments[i], ident)
		end
	end
end)
