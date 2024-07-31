---@class Scene
Scene = Object:extend()

---@param name string
---@return Scene
function Scene:new(name)
	---@type Layer[]
	self.layers = {}

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
end

function Scene:draw()
	for _, layer in pairs(self.layers) do
		if layer.draw ~= nil then
			layer.draw()
		end
	end
end

---@param path string
---@return Scene
function Scene.load(path)
	-- .scd are scene data files.
	local contents = Nativefs.read(path)
	local deserialized = Binser.deserialize(contents)

	return deserialized[1]
end

---@param path string
function Scene:save(path)
	local serialized = Binser.serialize(self)

	if not Nativefs.write(path, serialized, #serialized) then
		Log.error("Scene data could not be written.")
	end
end

return true
