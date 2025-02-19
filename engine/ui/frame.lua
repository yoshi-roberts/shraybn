local Class = require("libs.class")

---@class engine.ui.Frame: Class
local UIFrame = Class:extend()

---@param w number
---@param h number
function UIFrame:init(w, h)
	self.width = w
	self.height = h
end

function UIFrame:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("fill", 0, 0, self.width, self.height)
end

return UIFrame
