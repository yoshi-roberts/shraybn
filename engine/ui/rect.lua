local UIElement = require("engine.ui.element")

---@class engine.ui.Rect: engine.ui.Element
---@field super engine.ui.Element
local UIRect = UIElement:extend()

function UIRect:init(w, h)
	self.super.init(self)

	self.width = w or 0
	self.height = h or 0
end

---@param theme table
---@param position Vec2
---@param width number
---@param height number
function UIRect:update(theme, position, width, height)
	self.super.update(self, position, width, height)
end

---@param theme table
function UIRect:draw(theme)
	love.graphics.setColor(theme.border_color)
	local outline = 2
	love.graphics.rectangle(
		"fill",
		self.position.x - outline,
		self.position.y - outline,
		self.width + (outline * 2),
		self.height + (outline * 2)
	)

	love.graphics.setColor(theme.bg_color)
	love.graphics.rectangle("fill", self.position.x, self.position.y, self.width, self.height)
end

return UIRect
