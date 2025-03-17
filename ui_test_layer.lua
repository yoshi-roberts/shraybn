local ui = require("engine.ui")
local engine = require("engine")
local input = require("engine.input")

local function ui_attach()
	ui:init()
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

local function ui_update(dt)
	local mpos = engine.camera:get_mouse_position()
	ui:update(dt, mpos.x, mpos.y)
end

local function ui_draw()
	ui:start(128, 128, 128, 256)
	ui:label("Hey there!")
	ui:label("This is a longer line of text.")
	ui:label("Hey there!")
	ui:button("Button", function()
		print("Button 1!")
	end)
	ui:same_line()
	ui:button("Button")
	ui:label("More text.")
end

return {
	attach = ui_attach,
	detach = ui_detach,
	update = ui_update,
	draw = ui_draw,
}
