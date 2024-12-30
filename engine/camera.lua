local Class = require("libs.class")
local input = require("engine.input")

---@class engine.Camera: Class
local Camera = Class:extend()

---@param canvas engine.Canvas
function Camera:init(canvas)
	self.scale = 1
	self.canvas = canvas
	self.position = Vec2(0, 0)
end

---@param coords Vec2
---@return Vec2
function Camera:screen_to_world(coords)
	if self.canvas then
		return (self.canvas:screen_to_canvas(coords) + self.position) / self.scale
	else
		return (coords + self.position) / self.scale
	end
end

---@param coords Vec2
---@return Vec2
function Camera:screen_to_world_unscaled(coords)
	if self.canvas then
		return (self.canvas:screen_to_canvas(coords) + self.position)
	else
		return (coords + self.position)
	end
end

---@return Vec2
function Camera:get_position()
	return self.position / self.scale
end

---@return Vec2
function Camera:get_mouse_position()
	return self:screen_to_world(input.get_mouse_position())
end

---@param anchor Vec2
---@param y number
function Camera:zoom_to(anchor, y)
	local pos = self:screen_to_world_unscaled(anchor)
	local last_scale = self.scale

	self.scale = self.scale + y

	local nx = pos.x * (self.scale / last_scale)
	local ny = pos.y * (self.scale / last_scale)

	self.position.x = self.position.x - (pos.x - nx)
	self.position.y = self.position.y - (pos.y - ny)
end

function Camera:attach()
	if self.canvas then
		self.canvas:attach()
	end
	love.graphics.push()
	local x = -self.position.x
	local y = -self.position.y
	love.graphics.translate(x, y)
	love.graphics.scale(self.scale)
end

function Camera:detach()
	love.graphics.pop()
	if self.canvas then
		self.canvas:detach()
	end
end

function Camera:draw()
	-- Needs to hook up to a canvas somehow.
	-- Don't know if it should use the Canvas system.
	if self.canvas then
		self.canvas:draw()
	end
end

return Camera
