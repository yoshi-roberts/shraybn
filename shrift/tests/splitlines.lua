local Parser = require("shrift.parser") --[[@as ShriftParser]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

it("Parser split lines", function()
	local parser = Parser:new("Character: Text.\nCharacter: More text.")
	local lines = parser:split_lines()

	expect(#lines).to.equal(2)
	expect(lines[1]).to.equal("Character: Text.")
	expect(lines[2]).to.equal("Character: More text.")
end)
