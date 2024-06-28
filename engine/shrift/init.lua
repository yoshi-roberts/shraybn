local lexer = require("engine.shrift.lexer")
local shrift = {
	lexer = nil,
}

function shrift:lex(input)
	self.lexer = lexer:new(input)
end

return shrift
