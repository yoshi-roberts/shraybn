local input = require("engine.input")
local evaluator = require("shrift.evaluator")
local dialogue_box = require("engine.dialogue_box")
local engine = require("engine")
local assets = require("engine.assets")
local signal = require("engine.signal")

---@class engine.dialogue_manager: Class
local dialogue_manager = {}

dialogue_manager.env = { vars = {} }
dialogue_manager.active = false
dialogue_manager.blocked = false
dialogue_manager.parser = nil ---@type shrift.Parser
dialogue_manager.current_line = 1
dialogue_manager.current_portrait = nil ---@type engine.Portrait

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

local command_handlers = {
	["show"] = function(data)
		local character = engine.characters[data.args[1]] ---@type engine.Character
		dialogue_manager.current_portrait = character:get_portrait(data.args[2])
	end,

	["hide"] = function(data)
		dialogue_manager.current_portrait = nil
	end,

	["play"] = function(data)
		local asset = assets.get(data.args[1])
		love.audio.play(asset.resource)
	end,
}

local line_handlers = {
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
		local handler = command_handlers[line.data.command]
		handler(line.data)

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
		local handler = line_handlers[line.type]

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
			dialogue_manager.current_line = 1
			dialogue_manager.current_portrait = nil
		end
	end
end

function dialogue_manager.draw()
	if not dialogue_manager.active then
		return
	end

	if dialogue_manager.current_portrait then
		local portrait_asset = assets.get(dialogue_manager.current_portrait.asset_path)
		local res = portrait_asset.resource

		local canvas = engine.game_canvas
		local x = (canvas.width / 2) - (res:getWidth() / 2)
		local y = (canvas.height / 2) - (res:getHeight() / 2)

		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(res, x, y)
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
