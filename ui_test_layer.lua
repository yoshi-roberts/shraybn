local ui = require("engine.ui")

local function ui_attach()
	ui:init()
	ui:set_theme({
		bg_color = { 0, 0, 0, 1 },
		fg_color = { 1, 1, 1, 1 },
		outline_color = { 1, 1, 1, 1 },
		padding = 4,
	})
end

local function ui_detach() end

local function ui_update(dt)
	ui:update(dt)
end

local function ui_draw()
	ui:start(128, 128, 128, 256)
	ui:label("Hey there!")
	ui:label("This is a longer line of text.")
	ui:label("Hey there!")
	ui:button("Button")
	ui:same_line()
	ui:button("Button")
	-- ui:button("Button")
end

return {
	attach = ui_attach,
	detach = ui_detach,
	update = ui_update,
	draw = ui_draw,
}
