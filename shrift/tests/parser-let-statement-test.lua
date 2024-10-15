local token = require("shrift.token") --[[@as token]]
local Lexer = require("shrift.lexer") --[[@as Lexer]]
local Parser = require("shrift.parser") --[[@as Parser]]
local utils = require("shrift.tests.utils") --[[@as test_utils]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

---@param statement ASTStatementNode
local function test_let_statement(statement, name)
	---@cast statement ASTLetStatement
	expect(statement:literal()).to.equal("let")
	expect(statement.name.value).to.equal(name)
	expect(statement.name:literal()).to.equal(name)
end

it("Parse Let Statements", function()
	local tests = {
		{ "let x = 5\n", "x", 5 },
		{ "let y = true", "y", true },
		{ "let foobar = y\n", "foobar", "y" },
	}

	for _, v in pairs(tests) do
		local input = v[1]
		local expected_ident = v[2]
		local expected_val = v[3]

		---@type Lexer
		local l = Lexer(input)
		---@type Parser
		local p = Parser(l)

		---@type ASTProgram
		local program = p:parse_program()
		utils.check_parse_errors(p)

		expect(#program.statements).to.equal(1)

		local stmt = program.statements[1]
		---@cast stmt ASTLetStatement
		test_let_statement(stmt, expected_ident)

		local val = stmt.value
		utils.test_literal_expression(val, expected_val)
	end
end)
