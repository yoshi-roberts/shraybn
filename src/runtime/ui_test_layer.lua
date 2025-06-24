local ui = require("engine.ui")
local dialogue_manager = require("engine.dialogue_manager")
local dialogue_box = require("engine.dialogue_box")

local function ui_attach()
	ui:set_theme(require("engine.ui.default_theme"))
end

local function ui_detach() end

local function ui_update(dt)
	dialogue_manager.update()
	dialogue_box.update(dt)
end

local function ui_draw()
	dialogue_box.draw()
end

return {
	attach = ui_attach,
	detach = ui_detach,
	update = ui_update,
	draw = ui_draw,
}
