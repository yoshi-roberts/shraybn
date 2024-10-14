local ast = require("shrift.ast") --[[@as ast]]
local Lexer = require("shrift.lexer") --[[@as Lexer]]
local Parser = require("shrift.parser") --[[@as Parser]]
local utils = require("shrift.tests.utils") --[[@as test_utils]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

it("Parse Functon Parameters", function()
	local tests = {
		{ "fn() {}\n", {} },
		{ "fn(x) {}\n", { "x" } },
		{ "fn(x, y, z) {}\n", { "x", "y", "z" } },
	}

	for _, v in pairs(tests) do
		local input = v[1]
		local expected_params = v[2]

		---@type Lexer
		local l = Lexer(input)
		---@type Parser
		local p = Parser(l)
		---@type ASTProgram
		local program = p:parse_program()
		utils.check_parse_errors(p)

		local stmt = program.statements[1]
		---@cast stmt ASTExpressionStatement
		expect(stmt:is(ast.ExpressionStatement)).to.equal(true)

		local func = stmt.expression
		---@cast func ASTFunctionLiteral
		expect(func:is(ast.FunctionLiteral)).to.equal(true)

		expect(#func.parameters).to.equal(#expected_params)

		for i, ident in pairs(expected_params) do
			utils.test_literal_expression(func.parameters[i], ident)
		end
	end
end)
