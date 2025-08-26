local Entity = require("engine.entity")

local engine = require("engine")
local input = require("engine.input")
local log = require("libs.log")

---@class engine.Trigger: engine.Entity
---@field action engine.Action
local Trigger = Entity:extend()

---@param verticies table
---@param name string?
function Trigger:init(verticies, name)
	Trigger.super.init(self, name)

	self.foccussed = false
	self.verticies = verticies
	self.position = Vec2(0, 0)
	self.action = nil

	if self.verticies then
		self.tris = love.math.triangulate(self.verticies)
	end
end

local function point_in_triangle(px, py, tri)
	local ax, ay = tri[1], tri[2]
	local bx, by = tri[3], tri[4]
	local cx, cy = tri[5], tri[6]

	-- Compute vectors
	local v0x, v0y = cx - ax, cy - ay
	local v1x, v1y = bx - ax, by - ay
	local v2x, v2y = px - ax, py - ay

	-- Compute dot products
	local dot00 = v0x * v0x + v0y * v0y
	local dot01 = v0x * v1x + v0y * v1y
	local dot02 = v0x * v2x + v0y * v2y
	local dot11 = v1x * v1x + v1y * v1y
	local dot12 = v1x * v2x + v1y * v2y

	-- Compute barycentric coordinates
	local invDenom = 1 / (dot00 * dot11 - dot01 * dot01)
	local u = (dot11 * dot02 - dot01 * dot12) * invDenom
	local v = (dot00 * dot12 - dot01 * dot02) * invDenom

	-- Check if point is in triangle
	return (u >= 0) and (v >= 0) and (u + v < 1)
end

local function translate_tri(tri, t)
	return {
		tri[1] + t.x,
		tri[2] + t.y,
		tri[3] + t.x,
		tri[4] + t.y,
		tri[5] + t.x,
		tri[6] + t.y,
	}
end

function Trigger:update()
	self.foccused = false
	local mpos = engine.camera:get_mouse_position()

	-- Check if mouse coords intersect any of the triangles.
	for _, tri in pairs(self.tris) do
		if point_in_triangle(mpos.x, mpos.y, translate_tri(tri, self.position)) then
			self.foccused = true
			break
		end
	end

	if self.foccused and self.action then
		if input.button_pressed(input.mouse_button.LEFT) then
			self.action:execute()
		end
	end
end

function Trigger:draw()
	love.graphics.setColor(1, 0, 1, 0.4)

	-- love.graphics.push()
	-- love.graphics.translate(self.position.x, self.position.y)
	for _, tri in pairs(self.tris) do
		local t = {
			tri[1] + self.position.x,
			tri[2] + self.position.y,
			tri[3] + self.position.x,
			tri[4] + self.position.y,
			tri[5] + self.position.x,
			tri[6] + self.position.y,
		}
		love.graphics.polygon("fill", t)
	end
	-- love.graphics.pop()
end

function Trigger:__tostring()
	return "Trigger"
end

return Trigger
