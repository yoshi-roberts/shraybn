local Parser = require("shrift.parser") --[[@as shrift.Parser]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

local input = [[
	{true} Character: Some dialogue.
	* {false} Choice: destination
]]

it("Shrift parse condition", function()
	local parser = Parser:new(input)

	expect(#parser.lines).to.equal(2)
	expect(parser.lines[1].type).to.equal("DIALOGUE")
	expect(parser.lines[2].type).to.equal("CHOICE")

	expect(parser.lines[1].data.character).to.equal("Character")
	expect(parser.lines[1].data.text).to.equal("Some dialogue.")
	expect(parser.lines[1].data.condition).to.equal("true")

	expect(parser.lines[2].data.text).to.equal("Choice")
	expect(parser.lines[2].data.destination).to.equal("destination")
	expect(parser.lines[2].data.condition).to.equal("false")
end)
