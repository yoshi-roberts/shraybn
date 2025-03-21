local Class = require("libs.class")

---@class engine.Canvas: Class
local Canvas = Class:extend()

---@param width integer
---@param height integer
---@param mode "fit"|"none"
---@param filter "nearest"|"linear"?
function Canvas:init(width, height, mode, filter)
	self.width = width
	self.height = height
	self.filter = filter or "linear"
	self.mode = mode

	self.target = love.graphics.newCanvas(width, height)
	self.target:setFilter(self.filter, self.filter)

	self.position = Vec2(0, 0)
	self.scale = 1
end

---@param x number
---@param y number
function Canvas:set_position(x, y)
	self.position.x = x
	self.position.y = y
end

---@return integer, integer
function Canvas:get_size()
	return self.width, self.height
end

---@param width integer
---@param height integer
function Canvas:resize(width, height)
	self.width = width
	self.height = height
	self.target = love.graphics.newCanvas(width, height)
	self.target:setFilter(self.filter, self.filter)
end

-- Update the canvas size and position.
---@param width integer
---@param height integer
function Canvas:update(width, height)
	if self.mode ~= "fit" then
		return
	end

	local sx = (height / self.height)
	local sy = (width / self.width)
	self.scale = math.min(sx, sy)

	self.position.x = (width / 2) - ((self.width * self.scale) / 2)
	self.position.y = (height / 2) - ((self.height * self.scale) / 2)
end

---@param coords Vec2
---@return Vec2
function Canvas:screen_to_canvas(coords)
	local x = (coords.x - self.position.x) / self.scale
	local y = (coords.y - self.position.y) / self.scale
	return Vec2(x, y)
end

-- Prepare the canvas to be drawn to.
function Canvas:attach()
	love.graphics.setCanvas(self.target)
end

-- Finish drawing to the canvas.
function Canvas:detach()
	love.graphics.setCanvas()
end

function Canvas:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(self.target, self.position.x, self.position.y, 0, self.scale, self.scale)
end

return Canvas
