local Parser = require("shrift.parser") --[[@as shrift.Parser]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

local input = [[
	$var = true
	$var_two = false
	$var_three = $var_two
]]

it("Parser parse assignment", function()
	local parser = Parser:new(input)

	expect(#parser.lines).to.equal(3)

	expect(parser.lines[1].data.name).to.equal("var")
	expect(parser.lines[1].data.value).to.equal("true")
	expect(parser.lines[2].data.name).to.equal("var_two")
	expect(parser.lines[2].data.value).to.equal("false")
	expect(parser.lines[3].data.name).to.equal("var_three")
	expect(parser.lines[3].data.value).to.equal("$var_two")
end)
