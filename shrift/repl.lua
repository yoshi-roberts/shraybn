local Lexer = require("shrift.lexer") --[[@as Lexer]]
local Parser = require("shrift.parser") --[[@as Parser]]
local token = require("shrift.token") --[[@as token]]
local evaluator = require("shrift.evaluator") --[[@as evaluator]]

local repl = {}

local prompt = ">> "

local function print_parser_erors(errors)
	print("Parser errors:")
	for _, msg in pairs(errors) do
		print("\t" .. msg)
	end
end

function repl:start()
	print("Shrift (Running on " .. _VERSION .. ")")

	while true do
		io.write(prompt)

		local line = io.read("*L")

		---@type Lexer
		local l = Lexer(line)
		---@type Parser
		local p = Parser(l)

		local program = p:parse_program()
		if #p.errors ~= 0 then
			print_parser_erors(p.errors)
			goto continue
		end

		local evaluated = evaluator:eval(program)
		if evaluated then
			print(evaluated:inspect())
		end

		::continue::
	end
end

return repl
