local ast = require("shrift.ast") --[[@as ast]]
local Lexer = require("shrift.lexer") --[[@as Lexer]]
local Parser = require("shrift.parser") --[[@as Parser]]
local utils = require("shrift.tests.utils") --[[@as test_utils]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

it("Parse If Expression", function()
	local input = "if (x < y) { x }"

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
	---@cast exp ASTIfExpression
	expect(exp:is(ast.IfExpression)).to.equal(true)

	utils.test_infix_expression(exp.condition, "x", "<", "y")
	expect(#exp.consequence.statements).to.equal(1)

	local consequence = exp.consequence.statements[1]
	---@cast consequence ASTExpressionStatement
	expect(consequence:is(ast.ExpressionStatement)).to.equal(true)

	utils.test_identifier(consequence.expression, "x")

	expect(exp.alternative).to.equal(nil)
end)

it("Parse If/Else Expression", function()
	local input = "if (x < y) { x } else { y }"

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
	---@cast exp ASTIfExpression
	expect(exp:is(ast.IfExpression)).to.equal(true)

	utils.test_infix_expression(exp.condition, "x", "<", "y")
	expect(#exp.consequence.statements).to.equal(1)

	local consequence = exp.consequence.statements[1]
	---@cast consequence ASTExpressionStatement
	expect(consequence:is(ast.ExpressionStatement)).to.equal(true)

	utils.test_identifier(consequence.expression, "x")

	expect(exp.alternative).to_not.equal(nil)
	local alternative = exp.alternative.statements[1]
	---@cast alternative ASTExpressionStatement
	expect(consequence:is(ast.ExpressionStatement)).to.equal(true)

	utils.test_identifier(alternative.expression, "y")
end)
