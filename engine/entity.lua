---@class Entity: Object
Entity = Object:extend()

---@param position Vec2?
---@param rotation float?
function Entity:new(name, position, rotation)
	self.name = name
	self.depth = 0
	self.layer = nil
	self.position = position or Vec2(0, 0)
	self.scale = Vec2(1, 1)
	self.rotation = rotation or 0
end
