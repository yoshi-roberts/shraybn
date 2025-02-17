local Class = require("libs.class")

---@class engine.ui.Rect: Class
local Rect = Class:extend()

---@param w number
---@param h number
function Rect:init(w, h)
	self.width = w
	self.height = h
end

function Rect:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("fill", 0, 0, self.width, self.height)
end

return Rect
