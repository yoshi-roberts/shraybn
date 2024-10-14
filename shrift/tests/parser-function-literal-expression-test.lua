local ast = require("shrift.ast") --[[@as ast]]
local Lexer = require("shrift.lexer") --[[@as Lexer]]
local Parser = require("shrift.parser") --[[@as Parser]]
local utils = require("shrift.tests.utils") --[[@as test_utils]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

it("Parse Functon Literal Expression", function()
	local input = "fn(x, y) {x + y\n}"

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

	local func = stmt.expression
	---@cast func ASTFunctionLiteral
	expect(func:is(ast.FunctionLiteral)).to.equal(true)

	expect(#func.parameters).to.equal(2)

	utils.test_literal_expression(func.parameters[1], "x")
	utils.test_literal_expression(func.parameters[2], "y")

	expect(#func.body.statements).to.equal(1)

	local body_stmt = func.body.statements[1]
	---@cast body_stmt ASTExpressionStatement
	expect(body_stmt:is(ast.ExpressionStatement)).to.equal(true)

	utils.test_infix_expression(body_stmt.expression, "x", "+", "y")
end)
