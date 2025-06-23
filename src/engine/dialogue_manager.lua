local input = require("engine.input")
local evaluator = require("shrift.evaluator")
local dialogue_box = require("engine.dialogue")
local signal = require("engine.signal")

---@class engine.dialogue_manager: Class
local dialogue_manager = {}

dialogue_manager.env = { vars = {} }
dialogue_manager.active = false
dialogue_manager.parser = nil ---@type shrift.Parser
dialogue_manager.current_line = 1

---@param parser shrift.Parser
function dialogue_manager.run(parser)
	dialogue_manager.parser = parser
	dialogue_manager.active = true
end

local handlers = {
	["ASSIGN"] = function(line)
		local result = evaluator.eval_line(line, dialogue_manager.env)
		return true
	end,

	["DIALOGUE"] = function(line)
		local condition_met = evaluator.eval_line(line, dialogue_manager.env)

		if condition_met then
			dialogue_box.show(line.data.character, line.data.text)
			if input.button_pressed(input.mouse_button.LEFT) then
				return true
			end
		else
			return true
		end

		return false
	end,
}

function dialogue_manager.update()
	if not dialogue_manager.active then
		return
	end

	local parser = dialogue_manager.parser
	local line = parser.lines[dialogue_manager.current_line]
	local proceed = nil

	if proceed == nil then
		local handler = handlers[line.type]

		if handler then
			proceed = handler(line)
		else
			proceed = true
		end
	end

	if proceed then
		dialogue_manager.current_line = dialogue_manager.current_line + 1

		if dialogue_manager.current_line > parser.line_count then
			dialogue_box.hide()
			dialogue_manager.active = false
		end
	end
end

return dialogue_manager
