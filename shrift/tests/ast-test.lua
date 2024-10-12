local token = require("shrift.token") --[[@as token]]
local ast = require("shrift.ast") --[[@as ast]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

it("AST Test String", function()
	---@type ASTProgram
	local program = ast.Program()

	---@type ASTLetStatement
	local stmt = ast.LetStatement(token.new(token.TYPE.LET, "let"))
	stmt.name = ast.Identifier(token.new(token.TYPE.IDENT, "myVar"), "myVar")
	stmt.value =
		ast.Identifier(token.new(token.TYPE.IDENT, "anotherVar"), "anotherVar")

	table.insert(program.statements, stmt)

	print(tostring(program))
	expect(tostring(program)).to.equal("let myVar = anotherVar")
end)
