local Class = require("libs.class")

---@class engine.Camera: Class
local Camera = Class:extend()

function Camera:init()
	self.scale = 1
	self.position = Vec2(0, 0)
	self.dscale = 2 ^ (1 / 6)
end

---@param coords Vec2
function Camera:to_world(coords)
	return (coords + self.position) / self.scale
end

---@param pos Vec2
---@param y number
function Camera:zoom_to(pos, y)
	-- NOTE: Not yet sure this is working properly.
	local pos_x = pos.x - self.position.x
	local pos_y = pos.y - self.position.y
	local k = self.dscale ^ y
	self.scale = self.scale * k
	self.position.x = math.floor(self.position.x - pos_x * (1 - k))
	self.position.y = math.floor(self.position.y - pos_y * (1 - k))
end

function Camera:attach()
	love.graphics.push()
	love.graphics.translate(-self.position.x, -self.position.y)
	love.graphics.scale(self.scale)
end

function Camera:detach()
	love.graphics.pop()
end

function Camera:draw()
	-- Needs to hook up to a canvas somehow.
	-- Don't know if it should use the Canvas system.
end

return Camera
