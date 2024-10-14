local ast = require("shrift.ast") --[[@as ast]]
local Lexer = require("shrift.lexer") --[[@as Lexer]]
local Parser = require("shrift.parser") --[[@as Parser]]
local utils = require("shrift.tests.utils") --[[@as test_utils]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

it("Parse Call Expression", function()
	local input = "add(1, 2 * 3, 4 + 5)\n"

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
	expect(#exp.arguments).to.equal(3)

	utils.test_literal_expression(exp.arguments[1], 1)
	utils.test_infix_expression(exp.arguments[2], 2, "*", 3)
	utils.test_infix_expression(exp.arguments[3], 4, "+", 5)
end)
