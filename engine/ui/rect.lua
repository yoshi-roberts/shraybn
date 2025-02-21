local UIElement = require("engine.ui.element")

---@class engine.ui.Rect: engine.ui.Element
---@field super engine.ui.Element
local UIRect = UIElement:extend()

function UIRect:init(w, h)
	self.super.init(self)

	self.width = w or 0
	self.height = h or 0
end

---@param position Vec2
---@param width number
---@param height number
function UIRect:update(position, width, height)
	self.super.update(self, position, width, height)
end

function UIRect:draw()
	love.graphics.setColor(0, 0, 0, 1)
	local outline = 2
	love.graphics.rectangle(
		"fill",
		self.position.x - outline,
		self.position.y - outline,
		self.width + (outline * 2),
		self.height + (outline * 2)
	)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("fill", self.position.x, self.position.y, self.width, self.height)
end

return UIRect
