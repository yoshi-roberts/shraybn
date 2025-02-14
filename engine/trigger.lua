local Entity = require("engine.entity")
local input = require("engine.input")

---@class engine.Trigger: engine.Entity
---@field action engine.Action
local Trigger = Entity:extend()

-- TODO: Add action execution.
-- Probably use some kind of command patter.

---@param verticies table
---@param name string?
function Trigger:init(verticies, name)
	Trigger.super.init(self, name)

	self.foccussed = false
	self.verticies = verticies
	self.position = Vec2(0, 0)

	if self.verticies then
		self.tris = love.math.triangulate(self.verticies)
	end
end

local function area(x1, y1, x2, y2, x3, y3)
	return math.abs((x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2)) / 2.0)
end

local function in_tri(x, y, p)
	local a = area(p[1], p[2], p[3], p[4], p[5], p[6])
	local a1 = area(x, y, p[3], p[4], p[5], p[6])
	local a2 = area(p[1], p[2], x, y, p[5], p[6])
	local a3 = area(p[1], p[2], p[3], p[4], x, y)

	return a == a1 + a2 + a3
end

function Trigger:update()
	local pos = input.get_mouse_position()

	-- Check if mouse coords intersect any of the triangles.
	for _, tri in pairs(self.tris) do
		if in_tri(pos.x, pos.y, tri) then
			self.foccused = true
			break
		end
	end
end

function Trigger:draw()
	love.graphics.setColor(1, 0, 1, 0.4)

	love.graphics.push()
	love.graphics.translate(self.position.x, self.position.y)
	for _, tri in pairs(self.tris) do
		love.graphics.polygon("fill", tri)
	end
	love.graphics.pop()
end

function Trigger:__tostring()
	return "Trigger"
end

return Trigger
