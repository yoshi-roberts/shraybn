local ui = require("engine.ui")
local dialogue_manager = require("engine.dialogue_manager")
local dialogue_box = require("engine.dialogue_box")
local input = require("engine.input")
local engine = require("engine")

local function ui_attach()
	ui:set_theme(require("engine.ui.default_theme"))
end

local function ui_detach() end

local function ui_update(dt)
	dialogue_manager.update()
	dialogue_box.update(dt)

	if input.button_pressed(input.mouse_button.LEFT) then
		local mpos = input.get_mouse_position()
	end
end

local function ui_draw()
	dialogue_box.draw()
	local mpos = engine.camera:get_mouse_position()
	love.graphics.circle("fill", mpos.x, mpos.y, 8)
end

return {
	attach = ui_attach,
	detach = ui_detach,
	update = ui_update,
	draw = ui_draw,
}
