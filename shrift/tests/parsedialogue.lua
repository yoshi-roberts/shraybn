local Parser = require("shrift.parser") --[[@as ShriftParser]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

it("Parser parse dialogue line", function()
	local parser = Parser:new("Character: Some dialogue.")
	local lines = parser:split_lines()
	local parts = parser:parse_dialogue(lines[1])

	expect(parts[1]).to.equal("Character")
	expect(parts[2]).to.equal("Some dialogue.")
end)
