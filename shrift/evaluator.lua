local ast = require("shrift.ast") --[[@as ast]]
local object = require("shrift.object") --[[@as object]]

---@class evaluator
local evaluator = {}

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

---@param input boolean
---@return BooleanObject
function evaluator:native_bool_to_boolean_obj(input)
	if input then
		return TRUE
	end

	return FALSE
end

return evaluator
