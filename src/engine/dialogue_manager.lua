local input = require("engine.input")
local evaluator = require("shrift.evaluator")
local dialogue_box = require("engine.dialogue")

---@class engine.dialogue_manager: Class
local dialogue_manager = {}

dialogue_manager.env = {}
dialogue_manager.active = false
dialogue_manager.lines = {} ---@type shrift.LineData[]

---@param line shrift.LineData
function dialogue_manager.queue(line)
	table.inser(dialogue_manager.lines, line)
	dialogue_manager.active = true
end

function dialogue_manager.update()
	if not dialogue_manager.active then
		return
	end

	local line = dialogue_manager.lines[1]
	local proceed = true

	if line.data.condition then
		proceed = evaluator.eval_line(line, dialogue_manager.env)
	end

	if proceed then
		if line.type == "DIALOGUE" then
			dialogue_box.show(line.data.character, line.data.text)
		end
	end

	-- if input.button_pressed(input.mouse_button.LEFT) then
	-- 	table.remove(dialogue_manager.messages, 1)
	--
	-- 	if #dialogue_box.messages <= 0 then
	-- 		dialogue_box.visible = false
	-- 	end
	-- end
end
