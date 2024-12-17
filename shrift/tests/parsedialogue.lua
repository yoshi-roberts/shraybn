local Parser = require("shrift.parser") --[[@as shrift.Parser]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

local input = [[
	Character: Some dialogue.
]]

it("Shrift parse dialogue", function()
	local parser = Parser:new(input)

	expect(#parser.lines).to.equal(1)

	expect(parser.lines[1].data.character).to.equal("Character")
	expect(parser.lines[1].data.text).to.equal("Some dialogue.")
end)
