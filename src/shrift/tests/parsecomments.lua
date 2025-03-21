local Parser = require("shrift.parser") --[[@as shrift.Parser]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

local input = [[
	# Line with just a comment
	Character: Some dialogue.
	Character: Some more dialogue. # Comment
]]

it("Shrift parse comments", function()
	local parser = Parser:new(input)

	expect(#parser.lines).to.equal(2)

	expect(parser.lines[1].data.character).to.equal("Character")
	expect(parser.lines[1].data.text).to.equal("Some dialogue.")
	expect(parser.lines[2].data.character).to.equal("Character")
	expect(parser.lines[2].data.text).to.equal("Some more dialogue.")
end)
