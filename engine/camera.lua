local Class = require("libs.class")

---@class engine.Camera: Class
local Camera = Class:extend()

function Camera:init()
	self.scale = 1
	self.position = Vec2(0, 0)
end

function Camera:zoom()
	-- Set the scale of the camera.
end

function Camera:attach()
	love.graphics.push()
	love.graphics.translate(-self.position.x, -self.position.y)
end

function Camera:detach()
	love.graphics.pop()
end

function Camera:draw()
	-- Needs to hook up to a canvas somehow.
	-- Don't know if it should use the Canvas system.
end

return Camera
