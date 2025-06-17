local ui = require("engine.ui")
local DialogueBox = require("engine.dialogue")

local box = DialogueBox:new() ---@type engine.DialogueBox

local function ui_attach()
	ui:set_theme(require("engine.ui.default_theme"))

	box:queue("Title", "Some text!")
	box:queue("Title", "Additional text.")
	box:queue("Title", "It... It can't be! More text!")
end

local function ui_detach() end

local function ui_update(dt)
	box:update(dt)
end

local function ui_draw()
	box:draw()
end

return {
	attach = ui_attach,
	detach = ui_detach,
	update = ui_update,
	draw = ui_draw,
}
