local ast = require("shrift.ast") --[[@as ast]]
local Lexer = require("shrift.lexer") --[[@as Lexer]]
local Parser = require("shrift.parser") --[[@as Parser]]
local utils = require("shrift.tests.utils")
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

it("Parse Identifier Expression", function()
	local input = "foobar"

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

	local ident = stmt.expression
	---@cast ident ASTIdentifier
	expect(ident:is(ast.Identifier)).to.equal(true)

	expect(ident.value).to.equal("foobar")
	expect(ident:literal()).to.equal("foobar")
end)
