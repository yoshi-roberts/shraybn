local Parser = require("shrift.parser") --[[@as shrift.Parser]]
local evaluator = require("shrift.evaluator") --[[@as shrift.evaluator]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

local input = [[
	$var = true
	$var_two = false
	$var_three = $var_two
]]

it("Shrift eval assignment", function()
	local parser = Parser:new(input)

	expect(#parser.lines).to.equal(3)

	local env = { vars = {} }

	evaluator.eval_value(parser.lines[1], env)
	evaluator.eval_value(parser.lines[2], env)
	evaluator.eval_value(parser.lines[3], env)

	expect(env.vars.var).to.equal(true)
	expect(env.vars.var_two).to.equal(false)
	expect(env.vars.var_three).to.equal(false)
end)
