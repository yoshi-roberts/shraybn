local Class = require("libs.class")

---@class engine.ui.Element: Class
---@field update function
---@field draw function
local UIElement = Class:extend()

function UIElement:init()
	self.position = Vec2(0, 0)
	self.width = 0
	self.height = 0
	self.align = "left"
end

---@param position Vec2?
---@param width number?
---@param height number?
function UIElement:update(position, width, height)
	self.position = position or self.position
	self.width = width or self.width
	self.height = height or self.height
end

return UIElement
