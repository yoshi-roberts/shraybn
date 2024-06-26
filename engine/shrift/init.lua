require("engine.shrift.lexer")

local function test_next_token()
	local input = "=+()$"

	local lexer = Lexer:new(input)

	for c in input:gmatch(".") do
	end
end
