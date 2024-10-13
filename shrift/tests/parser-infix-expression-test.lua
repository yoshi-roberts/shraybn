local ast = require("shrift.ast") --[[@as ast]]
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

---@param int_literal ASTExpressionNode
---@param value integer
local function test_integer_literal(int_literal, value)
	local int = int_literal
	---@cast int ASTIntegerLiteral

	expect(int:is(ast.IntegerLiteral)).to.equal(true)
	expect(int.value).to.equal(value)
	expect(int:literal()).to.equal(tostring(value))
end

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
		check_parse_errors(p)

		expect(#program.statements).to.equal(1)

		local stmt = program.statements[1]
		---@cast stmt ASTExpressionStatement
		expect(stmt:is(ast.ExpressionStatement)).to.equal(true)

		local exp = stmt.expression
		---@cast exp ASTInfixExpression
		expect(exp:is(ast.InfixExpression)).to.equal(true)

		test_integer_literal(exp.left, left_val)
		expect(exp.operator).to.equal(operator)
		test_integer_literal(exp.right, right_val)
	end
end)
