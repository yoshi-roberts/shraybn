local Parser = require("shrift.parser") --[[@as shrift.Parser]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

local input = [[
	$var = 1
	[label]
	Character: Dialogue.
	* Choice.
]]

local results = {
	"ASSIGN",
	"LABEL",
	"DIALOGUE",
	"CHOICE",
}

it("Parser get line type", function()
	local parser = Parser:new(input)

	for k, line in pairs(parser.lines) do
		expect(line.type).to.equal(results[k])
	end
end)
