local ast = require("shrift.ast") --[[@as ast]]
local object = require("shrift.object") --[[@as object]]

---@class evaluator
local evaluator = {}

---@type NullObject
local NULL = object.Null()
---@type BooleanObject
local TRUE = object.Boolean(true)
---@type BooleanObject
local FALSE = object.Boolean(false)

---@param node ASTNode
---@return ObjectInterface?
function evaluator:eval(node)
	if node:is(ast.Program) then
		---@cast node ASTProgram
		return self:eval_statements(node.statements)
	elseif node:is(ast.ExpressionStatement) then
		---@cast node ASTExpressionStatement
		return self:eval(node.expression)
	elseif node:is(ast.PrefixExpression) then
		---@cast node ASTPrefixExpression
		local right = self:eval(node.right)
		return self:eval_prefix_expression(node.operator, right)
	elseif node:is(ast.IntegerLiteral) then
		---@cast node ASTIntegerLiteral
		return object.Integer(node.value)
	elseif node:is(ast.Boolean) then
		---@cast node ASTBoolean
		return self:native_bool_to_boolean_obj(node.value)
	end

	return nil
end

---@param statements ASTStatementNode[]
---@return ObjectInterface?
function evaluator:eval_statements(statements)
	---@type ObjectInterface?
	local result

	for _, stmt in pairs(statements) do
		result = self:eval(stmt)
	end

	return result
end

---@param operator string
---@param right ObjectInterface
function evaluator:eval_prefix_expression(operator, right)
	if operator == "!" then
		return self:eval_bang_operator_expression(right)
	elseif operator == "-" then
		return self:eval_minus_prefix_operator_expression(right)
	else
		return NULL
	end
end

---@param right ObjectInterface
---@return ObjectInterface
function evaluator:eval_bang_operator_expression(right)
	if right == TRUE then
		return FALSE
	elseif right == FALSE then
		return TRUE
	elseif right == NULL then
		return TRUE
	else
		return FALSE
	end
end

---@param right ObjectInterface
---@return ObjectInterface
function evaluator:eval_minus_prefix_operator_expression(right)
	if right:type() ~= object.TYPE.INTEGER then
		return NULL
	end

	---@cast right IntegerObject
	return object.Integer(-right.value)
end

---@param input boolean
---@return BooleanObject
function evaluator:native_bool_to_boolean_obj(input)
	if input then
		return TRUE
	end

	return FALSE
end

return evaluator
