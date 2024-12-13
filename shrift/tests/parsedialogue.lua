local Parser = require("shrift.parser") --[[@as ShriftParser]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

local input = [[
	Character: Some dialogue.
	Malformed dialogue line.
]]

it("Parser parse dialogue line", function()
	local parser = Parser:new(input)

	expect(#parser.lines).to.equal(2)

	expect(parser.lines[1].data.character).to.equal("Character")
	expect(parser.lines[1].data.text).to.equal("Some dialogue.")
	expect(#parser.errors).to.equal(1)
end)
