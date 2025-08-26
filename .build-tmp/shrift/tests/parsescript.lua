local Parser = require("shrift.parser") --[[@as shrift.Parser]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

local file = io.open("shrift/syntax.shr", "r")
local input = file:read("*a")
file:close()

it("Parser parse script", function()
	local parser = Parser:new(input)

	expect(#parser.errors).to.equal(0)
	expect(#parser.lines).to.equal(12)
end)
