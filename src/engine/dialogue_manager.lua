local input = require("engine.input")
local evaluator = require("shrift.evaluator")
local dialogue_box = require("engine.dialogue_box")
local signal = require("engine.signal")

---@class engine.dialogue_manager: Class
local dialogue_manager = {}

dialogue_manager.env = { vars = {} }
dialogue_manager.active = false
dialogue_manager.blocked = false
dialogue_manager.parser = nil ---@type shrift.Parser
dialogue_manager.current_line = 1

---@param parser shrift.Parser
function dialogue_manager.run(parser)
	dialogue_manager.parser = parser
	dialogue_manager.active = true
end

local function handle_choice(line)
	local condition_met = evaluator.eval_line(line, dialogue_manager.env)

	if condition_met and not dialogue_manager.blocked then
		dialogue_box.add_choice(line.data.text, line.data.destination)
	end
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

	["CHOICE"] = function(line)
		if dialogue_manager.blocked then
			return
		end

		handle_choice(line)

		local parser = dialogue_manager.parser
		local next_id = dialogue_manager.current_line + 1

		while next_id < parser.line_count do
			local next_line = parser.lines[next_id]

			if next_line.type == "CHOICE" then
				handle_choice(next_line)
				next_id = next_id + 1
			else
				break
			end
		end

		dialogue_manager.blocked = true
		return false
	end,

	["COMMAND"] = function(line)
		-- TODO: Handle commands
		print(line.command)

		return true
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

function dialogue_manager.goto_label(label)
	local parser = dialogue_manager.parser
	local id = parser.label_ids[label]

	dialogue_manager.current_line = id
	dialogue_manager.blocked = false
end

signal.register("dialogue_manager_goto_label", dialogue_manager.goto_label)

return dialogue_manager
