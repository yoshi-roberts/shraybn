local Parser = require("shrift.parser") --[[@as ShriftParser]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

local input = [[
	$var = 1
	[label]
	Character: Dialogue.
	* Choice.
	! Illegal
]]

local results = {
	"ASSIGN",
	"LABEL",
	"DIALOGUE",
	"CHOICE",
	"ILLEGAL",
}

it("Parser get line type", function()
	local parser = Parser:new(input)

	for k, line in pairs(parser.lines) do
		local type = parser:get_line_type(line)
		expect(type).to.equal(results[k])
	end
end)
