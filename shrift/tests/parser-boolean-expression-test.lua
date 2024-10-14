local ast = require("shrift.ast") --[[@as ast]]
local Lexer = require("shrift.lexer") --[[@as Lexer]]
local Parser = require("shrift.parser") --[[@as Parser]]
local utils = require("shrift.tests.utils")
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

it("Parse Boolean Expression", function()
	local tests = {
		{ "true", true },
		{ "false", false },
	}

	for _, v in pairs(tests) do
		local input = v[1]
		local expected = v[2]

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

		local literal = stmt.expression
		---@cast literal ASTBoolean
		expect(literal:is(ast.Boolean)).to.equal(true)

		expect(literal.value).to.equal(expected)
		expect(literal:literal()).to.equal(input)
	end
end)
