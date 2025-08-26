local Parser = require("shrift.parser") --[[@as shrift.Parser]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

local input = [[
	@show Character Bob 
	@play AlertSound
]]

it("Shrift parse command", function()
	local parser = Parser:new(input)

	expect(#parser.lines).to.equal(2)

	expect(parser.lines[1].data.command).to.equal("show")
	expect(#parser.lines[1].data.args).to.equal(2)
	expect(parser.lines[1].data.args[1]).to.equal("Character")
	expect(parser.lines[1].data.args[2]).to.equal("Bob")

	expect(parser.lines[2].data.command).to.equal("play")
	expect(#parser.lines[2].data.args).to.equal(1)
	expect(parser.lines[2].data.args[1]).to.equal("AlertSound")
end)
