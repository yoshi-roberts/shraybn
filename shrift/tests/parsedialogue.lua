local Parser = require("shrift.parser") --[[@as ShriftParser]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

local input = [[
	Character: Some dialogue.
	Malformed dialogue line.
]]

it("Parser parse dialogue line", function()
	local parser = Parser:new(input)
	local lines = parser:split_lines()

	expect(#lines).to.equal(2)

	local parts1 = parser:parse_dialogue(lines[1])
	local parts2 = parser:parse_dialogue(lines[2])

	expect(parts1[1]).to.equal("Character")
	expect(parts1[2]).to.equal("Some dialogue.")
	expect(#parser.errors).to.equal(1)
end)
