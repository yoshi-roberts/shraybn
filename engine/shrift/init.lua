local lexer = require("engine.shrift.lexer")
local shrift = {
	lexer = nil,
}

function shrift:lex(input)
	self.lexer = lexer(input)
	self.lexer:lex()
end

return shrift
