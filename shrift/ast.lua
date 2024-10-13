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

function ast.Program:__tostring()
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

return ast
