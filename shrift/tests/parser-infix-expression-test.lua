local ast = require("shrift.ast") --[[@as ast]]
local Lexer = require("shrift.lexer") --[[@as Lexer]]
local Parser = require("shrift.parser") --[[@as Parser]]
local utils = require("shrift.tests.utils")
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

it("Parse Infix Expression", function()
	local infix_tests = {
		{ "5 + 5", 5, "+", 5 },
		{ "5 - 5", 5, "-", 5 },
		{ "5 * 5", 5, "*", 5 },
		{ "5 / 5", 5, "/", 5 },
		{ "5 > 5", 5, ">", 5 },
		{ "5 < 5", 5, "<", 5 },
		{ "5 == 5", 5, "==", 5 },
		{ "5 != 5", 5, "!=", 5 },
		{ "true == true", true, "==", true },
		{ "true != false", true, "!=", false },
		{ "false == false", false, "==", false },
	}

	for _, v in pairs(infix_tests) do
		local input = v[1]
		local left_val = v[2]
		local operator = v[3]
		local right_val = v[4]

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
		utils.test_infix_expression(
			stmt.expression,
			left_val,
			operator,
			right_val
		)
		-- expect(stmt:is(ast.ExpressionStatement)).to.equal(true)
		--
		-- local exp = stmt.expression
		-- ---@cast exp ASTInfixExpression
		-- expect(exp:is(ast.InfixExpression)).to.equal(true)
		--
		-- utils.test_integer_literal(exp.left, left_val)
		-- expect(exp.operator).to.equal(operator)
		-- utils.test_integer_literal(exp.right, right_val)
	end
end)
