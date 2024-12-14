local Parser = require("shrift.parser") --[[@as ShriftParser]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

local input = [[
	! Invalid line type.
	Malformed dialogue.
	{true Character: Malformed dialogue condition.
	* {false Malformed choice condition: destination
	$var true
	$var
	$var = 
	$ = false
]]

it("Parser parse errors", function()
	local parser = Parser:new(input)

	local num = 8
	expect(#parser.lines).to.equal(num)
	expect(#parser.errors).to.equal(num)
end)
