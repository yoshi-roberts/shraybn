local ui = require("engine.ui")

local function ui_attach()
	-- ui:init()
	ui:set_theme({
		bg_color = { 0, 0, 0, 1 },
		fg_color = { 1, 1, 1, 1 },
		outline_color = { 1, 1, 1, 1 },
		padding = 4,
		button = {
			normal = {
				bg_color = { 0, 0, 0, 1 },
				fg_color = { 1, 1, 1, 1 },
				outline_color = { 1, 1, 1, 1 },
			},
			focussed = {
				bg_color = { 1, 1, 1, 1 },
				fg_color = { 0, 0, 0, 1 },
				outline_color = { 1, 1, 1, 1 },
			},
		},
	})
end

local function ui_detach() end

local function ui_update(dt) end

local function ui_draw()
	ui:start(0, -32, 256 * 2, 128, "center", "bottom")
	ui:label("Hey! This is some sample text.")
	ui:label("It is inside a textbox.")
	ui:label("How exciting!")
end

return {
	attach = ui_attach,
	detach = ui_detach,
	update = ui_update,
	draw = ui_draw,
}
