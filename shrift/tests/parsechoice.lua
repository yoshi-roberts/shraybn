local Parser = require("shrift.parser") --[[@as shrift.Parser]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

local input = [[
	* Choice : destination
	* Choice 2
]]

it("Parser parse choice", function()
	local parser = Parser:new(input)

	expect(#parser.lines).to.equal(2)

	expect(parser.lines[1].data.text).to.equal("Choice")
	expect(parser.lines[1].data.destination).to.equal("destination")
	expect(parser.lines[2].data.text).to.equal("Choice 2")
	expect(parser.lines[2].data.destination).to.equal(nil)
end)
