local UIElement = require("engine.ui.element")

---@class engine.ui.Text: engine.ui.Element
---@field super engine.ui.Element
local UIText = UIElement:extend()

---@param text string
function UIText:init(text, align)
	self.super.init(self)

	self.text = text
	self.align = align or self.align
end

---@param theme table
---@param position Vec2
---@param width number
function UIText:update(theme, position, width)
	self.super.update(self, position, width)

	local fnt = love.graphics.getFont()
	self.height = fnt:getHeight()
end

---@param theme table
function UIText:draw(theme)
	love.graphics.setColor(theme.fg_color)
	love.graphics.printf(self.text, self.position.x, self.position.y, self.width, self.align)
end

return UIText
