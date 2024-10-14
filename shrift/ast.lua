---@type Object
local Object = require("libs.classic")
local token = require("shrift.token")

---@class ast
local ast = {}

---@alias TokenLiteral fun(self: ASTNode): string
---@class ASTNode: Object
---@field literal TokenLiteral
---@class ASTStatementNode: ASTNode
---@field statement_node function
---@class ASTExpressionNode: ASTNode
---@field expression_node function

---@class ASTProgram: ASTNode
---@field statements ASTStatementNode[]
ast.Program = Object:extend()

---@private
function ast.Program:new()
	self.statements = {}
end

---@type TokenLiteral
function ast.Program:literal()
	if #self.statements > 0 then
		return self.statements[1]:literal()
	else
		return ""
	end
end

---@private
function ast.Program:__tostring()
	local out = ""
	for _, v in pairs(self.statements) do
		out = out .. tostring(v)
	end

	return out
end

---@class ASTBlockStatement: ASTStatementNode
---@field token TokenData
---@field statements ASTStatementNode[]
ast.BlockStatement = Object:extend()

---@private
---@param tok TokenData
function ast.BlockStatement:new(tok)
	self.token = tok
	self.statements = {}
end

---@type TokenLiteral
function ast.BlockStatement:literal()
	return self.token.literal
end

---@private
function ast.BlockStatement:__tostring()
	local out = ""
	for _, v in pairs(self.statements) do
		out = out .. tostring(v)
	end

	return out
end

---@class ASTLetStatement: ASTStatementNode
---@field token TokenData
---@field name ASTIdentifier
---@field value ASTExpressionNode
ast.LetStatement = Object:extend()

---@private
---@param tok TokenData
function ast.LetStatement:new(tok)
	self.token = tok
end

---@type TokenLiteral
function ast.LetStatement:literal()
	return self.token.literal
end

---@private
function ast.LetStatement:__tostring()
	local out = string.format("%s %s = ", self:literal(), tostring(self.name))

	if self.value ~= nil then
		out = out .. tostring(self.value)
	end

	return out
end

---@class ASTReturnStatement: ASTStatementNode
---@field token TokenData
---@field return_value ASTExpressionNode
ast.ReturnStatement = Object:extend()

---@private
---@param tok TokenData
function ast.ReturnStatement:new(tok)
	self.token = tok
end

---@type TokenLiteral
function ast.ReturnStatement:literal()
	return self.token.literal
end

---@private
function ast.ReturnStatement:__tostring()
	local out = "" .. self:literal() .. " "

	if self.return_value ~= nil then
		out = out .. tostring(self.return_value)
	end

	return out
end

---@class ASTExpressionStatement: ASTStatementNode
---@field token TokenData
---@field expression ASTExpressionNode
ast.ExpressionStatement = Object:extend()

---@private
---@param tok TokenData
function ast.ExpressionStatement:new(tok)
	self.token = tok
end

---@type TokenLiteral
function ast.ExpressionStatement:literal()
	return self.token.literal
end

---@private
function ast.ExpressionStatement:__tostring()
	if self.expression ~= nil then
		return tostring(self.expression)
	end

	return ""
end

---@class ASTIdentifier: ASTExpressionNode
---@field token TokenData
---@field value string
ast.Identifier = Object:extend()

---@private
---@param tok TokenData
---@param value string
function ast.Identifier:new(tok, value)
	self.token = tok
	self.value = value
end

function ast.Identifier:literal()
	return self.token.literal
end

---@private
function ast.Identifier:__tostring()
	return self.value
end

---@class ASTIntegerLiteral: ASTExpressionNode
---@field token TokenData
---@field value integer
ast.IntegerLiteral = Object:extend()

---@private
---@param tok TokenData
function ast.IntegerLiteral:new(tok)
	self.token = tok
end

---@type TokenLiteral
function ast.IntegerLiteral:literal()
	return self.token.literal
end

function ast.IntegerLiteral:__tostring()
	return tostring(self.value)
end

---@class ASTBoolean: ASTExpressionNode
---@field token TokenData
---@field value boolean
ast.Boolean = Object:extend()

---@private
---@param tok TokenData
---@param value boolean
function ast.Boolean:new(tok, value)
	self.token = tok
	self.value = value
end

---@type TokenLiteral
function ast.Boolean:literal()
	return self.token.literal
end

---@private
function ast.Boolean:__tostring()
	return self.token.literal
end

---@class ASTPrefixExpression: ASTExpressionNode
---@field token TokenData
---@field operator string
---@field right ASTExpressionNode
ast.PrefixExpression = Object:extend()

---@private
---@param tok TokenData
---@param operator string
function ast.PrefixExpression:new(tok, operator)
	self.token = tok
	self.operator = operator
end

---@type TokenLiteral
function ast.PrefixExpression:literal()
	return self.token.literal
end

---@private
function ast.PrefixExpression:__tostring()
	local out = string.format("(%s%s)", self.operator, tostring(self.right))
	return out
end

---@class ASTInfixExpression: ASTExpressionNode
---@field token TokenData
---@field left ASTExpressionNode
---@field operator string
---@field right ASTExpressionNode
ast.InfixExpression = Object:extend()

---@private
---@param tok TokenData
---@param operator string
---@param left ASTExpressionNode
function ast.InfixExpression:new(tok, operator, left)
	self.token = tok
	self.operator = operator
	self.left = left
end

---@type TokenLiteral
function ast.InfixExpression:literal()
	return self.token.literal
end

---@private
function ast.InfixExpression:__tostring()
	local out = string.format(
		"(%s %s %s)",
		tostring(self.left),
		self.operator,
		tostring(self.right)
	)
	return out
end

---@class ASTIfExpression: ASTExpressionNode
---@field token TokenData
---@field condition ASTExpressionNode
---@field consequence ASTBlockStatement
---@field alternative ASTBlockStatement
ast.IfExpression = Object:extend()

---@type TokenLiteral
function ast.IfExpression:literal()
	return self.token.literal
end

---@private
function ast.IfExpression:__tostring()
	local out = string.format(
		"if%s %s",
		tostring(self.condition),
		tostring(self.consequence)
	)

	if self.alternative then
		out = out .. " else " .. tostring(self.alternative)
	end

	return out
end

---@class ASTFunctionLiteral: ASTExpressionNode
---@field token TokenData
---@field parameters ASTIdentifier[]
---@field body ASTBlockStatement
ast.FunctionLiteral = Object:extend()

---@private
---@param tok TokenData
function ast.FunctionLiteral:new(tok)
	self.token = tok
end

---@type TokenLiteral
function ast.FunctionLiteral:literal()
	return self.token.literal
end

---@private
function ast.FunctionLiteral:__tostring()
	local out = self:literal() .. "("

	for _, v in pairs(self.parameters) do
		out = out .. tostring(v)
	end

	out = out .. ") " .. tostring(self.body)
	return out
end

---@class ASTCallExpression: ASTExpressionNode
---@field token TokenData
---@field func ASTExpressionNode
---@field arguments ASTExpressionNode[]
ast.CallExpression = Object:extend()

---@private
---@param tok TokenData
---@param func ASTExpressionNode
function ast.CallExpression:new(tok, func)
	self.token = tok
	self.func = func
end

---@type TokenLiteral
function ast.CallExpression:literal()
	return self.token.literal
end

---@private
function ast.CallExpression:__tostring()
	local out = tostring(self.func) .. "("

	for k, v in pairs(self.arguments) do
		out = out .. tostring(v)
		if k ~= #self.arguments then
			out = out .. ", "
		end
	end

	out = out .. ")"
	return out
end

return ast
