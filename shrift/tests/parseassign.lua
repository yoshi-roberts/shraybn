local Parser = require("shrift.parser") --[[@as ShriftParser]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

local input = [[
	$var = true
	$var_two = false
]]

it("Parser parse assignment", function()
	local parser = Parser:new(input)

	expect(#parser.lines).to.equal(2)

	expect(parser.lines[1].data.name).to.equal("var")
	expect(parser.lines[1].data.expression).to.equal("true")
	expect(parser.lines[2].data.name).to.equal("var_two")
	expect(parser.lines[2].data.expression).to.equal("false")
end)
