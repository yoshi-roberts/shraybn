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

---@class ASTIdentifier: ASTExpressionNode
---@field token TokenData
---@field value string
ast.Identifier = Object:extend()

---@private
---@param tok TokenData
---@param value string
function ast.Identifier:new(tok, value)
	self.tok = tok
	self.value = value
end

function ast.Identifier:literal()
	return self.tok.literal
end

return ast
