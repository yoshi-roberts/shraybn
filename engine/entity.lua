Entity = Object:extend()

function Entity:new(position, rotation)
	self.position = position or Vec2(0, 0)
	self.scale = Vec2(1, 1)
	self.rotation = rotation or 0
end
