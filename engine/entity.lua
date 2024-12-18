local Class = require("libs.class")

---@class engine.Entity: Class
---@field draw function
---@field update function
local Entity = Class:extend()

---@param position Vec2?
---@param rotation number?
function Entity:init(position, rotation, name)
	self.name = name
	self.depth = 0
	self.layer = nil
	self.position = position or Vec2(0, 0)
	self.scale = Vec2(1, 1)
	self.rotation = rotation or 0
end

return Entity
