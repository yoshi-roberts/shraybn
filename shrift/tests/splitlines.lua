local Parser = require("shrift.parser") --[[@as ShriftParser]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

it("Parser split lines", function()
	local parser = Parser:new("Character: Text.\nCharacter: More text.")

	expect(#parser.lines).to.equal(2)
	expect(parser.lines[1].str).to.equal("Character: Text.")
	expect(parser.lines[2].str).to.equal("Character: More text.")
end)
