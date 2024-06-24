---@class Scene
Scene = Object:extend()

function Scene:new(name)
	self.layers = {}
	self.world = World() -- New ECS world.

	self.world:addSystem(Engine.systems.sprite_render)

	Engine.scenes[name] = self
	return Engine.scenes[name]
end

function Scene:shutdown()
	for _, layer in pairs(self.layers) do
		if layer.detach ~= nil then
			layer.detach()
		end
	end
end

function Scene:update(dt)
	for _, layer in pairs(self.layers) do
		if layer.update ~= nil then
			layer.update(dt)
		end
	end

	self.world:emit("update", dt)
end

function Scene:draw()
	for _, layer in pairs(self.layers) do
		if layer.draw ~= nil then
			layer.draw()
		end
	end

	self.world:emit("draw")
end

function Scene:add_entity(entity)
	self.world:addEntity(entity)
end

function Scene:remove_entity(entity)
	self.world:remove_entity(entity)
end

-- function Scene.world:onEntityAdded(entity)
-- Entity has been added to world.
-- end

return true
