local ast = require("shrift.ast") --[[@as ast]]
local token = require("shrift.token") --[[@as token]]
local Object = require("libs.classic") --[[@as Object]]
local Lexer = require("shrift.lexer") --[[@as Lexer]]

---@class Parser
---@field lexer Lexer
---@field cur_token TokenData
---@field peek_token TokenData
local Parser = Object:extend()

---@private
---@param lexer Lexer
function Parser:new(lexer)
	self.lexer = lexer

	self:next_token()
	self:next_token()
end

function Parser:next_token()
	self.cur_token = self.peek_token
	self.peek_token = self.lexer:next_token()
end

---@return ASTProgram
function Parser:parse_program()
	---@type ASTProgram
	local program = ast.Program()

	while self.cur_token.type ~= token.TYPE.EOF do
		local stmt = self:parse_statement()
		if stmt ~= nil then
			table.insert(program.statements, stmt)
		end
		self:next_token()
	end

	return program
end

function Parser:parse_statement()
	if self.cur_token.type == token.TYPE.LET then
		return self:parse_let_statement()
	else
		return nil
	end
end

function Parser:parse_let_statement()
	---@type ASTLetStatement
	local stmt = ast.LetStatement(self.cur_token)

	if not self:expect_peek(token.TYPE.IDENT) then
		return nil
	end

	stmt.name = ast.Identifier(self.cur_token, self.cur_token.literal)

	if not self:expect_peek(token.TYPE.ASSIGN) then
		return nil
	end

	-- TODO: We are skipping the expressions until we
	-- reach a newline.
end

---@param tok_type TokenType
---@return boolean
function Parser:cur_token_is(tok_type)
	return self.cur_token.type == tok_type
end

---@param tok_type TokenType
---@return boolean
function Parser:peek_token_is(tok_type)
	return self.peek_token.type == tok_type
end

---@param tok_type TokenType
---@return boolean
function Parser:expect_peek(tok_type)
	if self:peek_token_is(tok_type) then
		self:next_token()
		return true
	else
		return false
	end
end

return Parser
