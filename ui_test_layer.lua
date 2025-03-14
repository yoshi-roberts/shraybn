local ui = require("engine.ui")

local function ui_attach()
	ui:init()
end

local function ui_detach() end

local function ui_update(dt)
	ui:update(dt)
end

local function ui_draw()
	ui:draw()
end

return {
	attach = ui_attach,
	detach = ui_detach,
	update = ui_update,
	draw = ui_draw,
}
