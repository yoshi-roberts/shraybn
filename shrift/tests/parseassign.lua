local Parser = require("shrift.parser") --[[@as ShriftParser]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

local input = [[
	$var = true
]]

it("Parser parse assignment", function()
	local parser = Parser:new(input)

	expect(#parser.lines).to.equal(1)

	expect(parser.lines[1].data.name).to.equal("var")
	expect(parser.lines[1].data.expression).to.equal("true")
end)
