Scene = Object:extend()

function Scene:new()
	self.world = World() -- New ECS world.
end

function Scene:update(dt)
	self.world:emit("update", dt)
end

function Scene:add_entity(entity)
	self.world:addEntity(entity)
end

function Scene:remove_entity(entity)
	self.world:remove_entity(entity)
end
