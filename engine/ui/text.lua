local Class = require("libs.class")

---@class engine.ui.Text: Class
local UIText = Class:extend()

---@param text string
function UIText:init(text)
	self.text = text
	self.position = Vec2(0, 0)
	self.width = 128
	self.height = 0
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
