local object = require("shrift.object") --[[@as object]]
local evaluator = require("shrift.evaluator") --[[@as evaluator]]
local Lexer = require("shrift.lexer") --[[@as Lexer]]
local Parser = require("shrift.parser") --[[@as Parser]]
local utils = require("shrift.tests.utils") --[[@as test_utils]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

local function test_eval(input)
	---@type Lexer
	local l = Lexer(input)
	---@type Parser
	local p = Parser(l)

	---@type ASTProgram
	local program = p:parse_program()
	utils.check_parse_errors(p)

	return evaluator:eval(program)
end

---@param obj ObjectInterface
---@param expected integer
local function test_integer_object(obj, expected)
	expect(obj).to_not.equal(nil)
	---@cast obj IntegerObject
	expect(obj:is(object.Integer)).to.equal(true)
	expect(obj.value).to.equal(expected)
end

it("Eval Integer Expression", function()
	local tests = {
		{ "5", 5 },
		{ "10", 10 },
	}

	for _, v in pairs(tests) do
		local input = v[1]
		local expected = v[2]

		local evaluated = test_eval(input)
		test_integer_object(evaluated, expected)
	end
end)
