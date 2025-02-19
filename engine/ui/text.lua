local UIElement = require("engine.ui.element")

---@class engine.ui.Text: engine.ui.Element
local UIText = UIElement:extend()

---@param text string
function UIText:init(text, align)
	self.super.init(self)

	self.text = text
	self.align = align or self.align
end

function UIText:update()
	local fnt = love.graphics.getFont()
	self.height = fnt:getHeight()
end

function UIText:draw()
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.printf(self.text, self.position.x, self.position.y, self.width, self.align)
end

return UIText
