local UIFrame = require("engine.ui.frame")
local UIText = require("engine.ui.text")
local UIButton = require("engine.ui.button")

local frame = nil ---@type engine.ui.Frame

local function ui_attach()
	frame = UIFrame:new(128, 128)
	frame:add(UIText:new("Some text."))
	frame:add(UIText:new("Some more text.", "right"))
	-- frame:add(UIText:new("A third line of text."))
	-- frame:add(UIText:new("This is a long line of text that will need to be wrapped."))
	frame:add(UIButton:new("Button"))
end

local function ui_detach() end

local function ui_update(dt)
	frame:update()
end

local function ui_draw()
	frame:draw()
end

return {
	attach = ui_attach,
	detach = ui_detach,
	update = ui_update,
	draw = ui_draw,
}
