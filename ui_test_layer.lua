local window = require("engine.window")
local input = require("engine.input")
local engine = require("engine")

local UIFrame = require("engine.ui.frame")

local frame = nil ---@type engine.ui.Frame

local function ui_attach()
	frame = UIFrame:new(128, 128)
end

local function ui_detach() end

local function ui_update(dt) end

local function ui_draw()
	frame:draw()
end

return {
	attach = ui_attach,
	detach = ui_detach,
	update = ui_update,
	draw = ui_draw,
}
