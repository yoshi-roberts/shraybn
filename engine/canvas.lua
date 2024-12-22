local Class = require("libs.class")
local binser = require("libs.binser")

---@class engine.Canvas : Class
local Canvas = Class:extend()

function Canvas:new(width, height, filter)
	self.width = width
	self.height = height

	self.target = love.graphics.newCanvas(width, height)
	self.target:setFilter(filter or "linear", filter or "linear")

	self.x = 0
	self.y = 0
	self.scale = 0
end

-- Update the canvas size and position.
---@param width integer
---@param height integer
function Canvas:update(width, height)
	local sx = (height / self.height)
	local sy = (width / self.width)
	self.scale = math.min(sx, sy)

	self.x = (width / 2) - ((self.width * self.scale) / 2)
	self.y = (height / 2) - ((self.height * self.scale) / 2)
end

-- Prepare the canvas to be drawn to.
function Canvas:start()
	love.graphics.setCanvas(self.target)
	love.graphics.clear()
end

-- Finish drawing to the canvas.
function Canvas:finish()
	love.graphics.setCanvas()
end

function Canvas:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(self.target, self.x, self.y, 0, self.scale, self.scale)
end

binser.register(Canvas, "Canvas")
return Canvas
