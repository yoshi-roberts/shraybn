local Lexer = require("shrift.lexer") --[[@as Lexer]]
local token = require("shrift.token") --[[@as token]]

local repl = {}

local prompt = ">> "

function repl:start()
	while true do
		io.write(prompt)

		local line = io.read("*L")

		---@type Lexer
		local l = Lexer(line)

		local tok = l:next_token()
		while tok.type ~= token.TYPE.EOF do
			if tok.type ~= token.TYPE.NEWLINE then
				print(tok.type, tok.literal)
			else
				print("NEWLINE", "\\n")
			end
			tok = l:next_token()
		end
	end
end

return repl
