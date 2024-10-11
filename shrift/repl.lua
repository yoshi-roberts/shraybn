---@type Lexer
local lexer = require("shrift.lexer")
---@type Token
local token = require("shrift.token")

local repl = {}

local prompt = ">> "

function repl:start()
	while true do
		io.write(prompt)

		local line = io.read("*l")
		---@type Lexer
		local l = lexer(line)

		local tok = l:next_token()
		while tok.type ~= token.TYPE.EOF do
			print(tok.type, tok.literal)
			tok = l:next_token()
		end
	end
end

return repl
