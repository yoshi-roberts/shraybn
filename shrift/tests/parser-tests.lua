local token = require("shrift.token") --[[@as token]]
local Lexer = require("shrift.lexer") --[[@as Lexer]]
local Parser = require("shrift.parser") --[[@as Parser]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

---@param statement ASTStatementNode
local function test_let_statement(statement, name)
	---@cast statement ASTLetStatement
	expect(statement:literal()).to.equal("let")
	expect(statement.name.value).to.equal(name)
	expect(statement.name:literal()).to.equal(name)
end

---@param parser Parser
local function check_parse_errors(parser)
	if #parser.errors == 0 then
		return
	end

	print(string.format("Parser has %d errors.", #parser.errors))
	for _, msg in pairs(parser.errors) do
		print("Parser error: " .. msg)
	end

	-- Fail if we have any errors.
	expect(#parser.errors).to.equal(0)
end

it("Parse Let Statements", function()
	local input = [[
let x 5
let = 10
let 3675209
]]

	---@type Lexer
	local l = Lexer(input)
	---@type Parser
	local p = Parser(l)

	---@type ASTProgram
	local program = p:parse_program()
	check_parse_errors(p)

	expect(program).to_not.equal(nil)
	expect(#program.statements).to.equal(3)

	local tests = {
		"x",
		"y",
		"foobar",
	}

	for k, v in pairs(tests) do
		---@type ASTStatementNode
		local stmt = program.statements[k]
		test_let_statement(stmt, v)
	end
end)
