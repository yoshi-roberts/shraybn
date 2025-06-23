local Class = require("libs.class")
local Layer = require("engine.layer")
local input = require("engine.input")
local signal = require("engine.signal")
local ui = require("engine.ui")

---@class engine.dialogue_box: Class
local dialogue_box = {}

dialogue_box.visible = false
dialogue_box.title = ""
dialogue_box.text = ""
dialogue_box.messages = {}

function dialogue_box.show(title, text)
	dialogue_box.title = title
	dialogue_box.text = text
	dialogue_box.visible = true
end

function dialogue_box.hide()
	dialogue_box.title = ""
	dialogue_box.text = ""
	dialogue_box.visible = false
end

function dialogue_box.update(dt)
	if not dialogue_box.visible then
		return
	end

	-- if input.button_pressed(input.mouse_button.LEFT) then
	-- 	table.remove(dialogue_box.messages, 1)
	--
	-- 	if #dialogue_box.messages <= 0 then
	-- 		dialogue_box.visible = false
	-- 	end
	-- end
end

function dialogue_box.draw()
	if not dialogue_box.visible then
		return
	end

	ui:start(0, -32, 256 * 2, 128, "center", "bottom")

	ui:label(dialogue_box.title)
	ui:separator()
	ui:label(dialogue_box.text)
end

return dialogue_box
