local Parser = require("shrift.parser") --[[@as ShriftParser]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

local input = [[
	! Invalid line type.
	Malformed dialogue.
	{true Character: Malformed dialogue condition.
	* {false Malformed choice condition: destination
]]

it("Parser parse errors", function()
	local parser = Parser:new(input)

	expect(#parser.lines).to.equal(4)
	expect(#parser.errors).to.equal(4)
end)
