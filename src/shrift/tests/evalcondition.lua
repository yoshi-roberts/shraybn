local Parser = require("shrift.parser") --[[@as shrift.Parser]]
local evaluator = require("shrift.evaluator") --[[@as shrift.evaluator]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect
local pprint = require("libs.pprint")

local input = [[
	{1 == 1} Character: Conditional dialogue.
	{1 == 0} Character: Conditional dialogue.
	$var = 2
	{$var == 2} Character: Conditional dialogue.
	{$var == 1} Character: Conditional dialogue.
	* {not $var} Choice 2 : Label 3
]]

it("Shrift eval condition", function()
	local parser = Parser:new(input)
	expect(#parser.lines).to.equal(6)

	local result = evaluator.eval_line(parser.lines[1], parser.env)
	expect(result).to.equal(true)

	result = evaluator.eval_line(parser.lines[2], parser.env)
	expect(result).to.equal(false)

	evaluator.eval_line(parser.lines[3], parser.env)
	result = evaluator.eval_line(parser.lines[4], parser.env)
	expect(result).to.equal(true)

	result = evaluator.eval_line(parser.lines[5], parser.env)
	expect(result).to.equal(false)

	result = evaluator.eval_line(parser.lines[6], parser.env)
	expect(result).to.equal(false)
end)
