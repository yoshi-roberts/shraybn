local UIElement = require("engine.ui.element")

---@class engine.ui.Text: engine.ui.Element
local UIText = UIElement:extend()

---@param text string
function UIText:init(text)
	self.super.init(self)

	self.text = text
end

function UIText:update()
	local fnt = love.graphics.getFont()
	self.height = fnt:getHeight()
end

function UIText:draw()
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.printf(self.text, self.position.x, self.position.y, self.width)
end

return UIText
