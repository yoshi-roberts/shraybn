local ast = require("shrift.ast") --[[@as ast]]
local lust = require("libs.lust")
local expect = lust.expect

---@class test_utils
local utils = {}

---@param parser Parser
function utils.check_parse_errors(parser)
	if #parser.errors == 0 then
		return
	end

	print(string.format("		Parser has %d errors.", #parser.errors))
	for _, msg in pairs(parser.errors) do
		print("		Parser error: " .. msg)
	end

	-- Fail if we have any errors.
	expect(#parser.errors).to.equal(0)
end

---@param int_literal ASTExpressionNode
---@param value integer
function utils.test_integer_literal(int_literal, value)
	local int = int_literal
	---@cast int ASTIntegerLiteral

	expect(int:is(ast.IntegerLiteral)).to.equal(true)
	expect(int.value).to.equal(value)
	expect(int:literal()).to.equal(tostring(value))
end

---@param exp ASTExpressionNode
---@param value string
function utils.test_identifier(exp, value)
	expect(exp:is(ast.Identifier)).to.equal(true)

	---@cast exp ASTIdentifier
	expect(exp.value).to.equal(value)
	expect(exp:literal()).to.equal(value)
end

---@param exp ASTExpressionNode
---@param value boolean
function utils.test_boolean_literal(exp, value)
	expect(exp:is(ast.Boolean)).to.equal(true)
	---@cast exp ASTBoolean

	expect(exp.value).to.equal(value)
	expect(exp:literal()).to.equal(tostring(value))
end

---@param expression ASTExpressionNode
---@param expected string|integer|boolean
function utils.test_literal_expression(expression, expected)
	local v = type(expected)

	expect(expected).to_not.equal("nil")
	expect(expected).to_not.equal("table")
	expect(expected).to_not.equal("function")
	expect(expected).to_not.equal("thread")
	expect(expected).to_not.equal("userdata")

	if v == "number" then
		utils.test_integer_literal(expression, expected)
	elseif v == "string" then
		utils.test_identifier(expression, expected)
	elseif v == "boolean" then
		utils.test_boolean_literal(expression, expected)
	end
end

---@param exp ASTExpressionNode
---@param left string|integer
---@param operator string
---@param right string|integer
function utils.test_infix_expression(exp, left, operator, right)
	expect(exp:is(ast.InfixExpression)).to.equal(true)

	---@cast exp ASTInfixExpression
	utils.test_literal_expression(exp.left, left)
	expect(exp.operator).to.equal(operator)
	utils.test_literal_expression(exp.right, right)
end

return utils
