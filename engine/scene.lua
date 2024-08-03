---@class Scene
Scene = Object:extend()

---@param name string
---@return Scene
function Scene:new(name)
	---@type Layer[]
	self.layers = {}
	---@type Entity[]
	self.entities = {}

	Engine.scenes[name] = self
	return Engine.scenes[name]
end

function Scene:shutdown()
	for _, layer in pairs(self.layers) do
		if layer.active and layer.detach ~= nil then
			layer.detach()
		end
	end
end

function Scene:update(dt)
	for _, layer in pairs(self.layers) do
		if layer.active and layer.update ~= nil then
			layer.update(dt)
		end
	end
end

function Scene:draw()
	for _, layer in pairs(self.layers) do
		if layer.active and layer.draw ~= nil then
			layer.draw()
		end
	end
end

---@param name string
---@param callbacks table
---@return Layer
function Scene:add_layer(name, callbacks)
	table.insert(self.layers, Layer(name, #self.layers, callbacks))
	return self.layers[#self.layers]
end

function Scene:remove_layer(layer)
	-- Use layers depth value to get its index.
	local index = layer.depth + 1

	-- Remove all entities associated with the layer.
	for i, entity in pairs(self.entities) do
		if entity.layer == layer then
			table.remove(self.entities, i)
		end
	end

	table.remove(self.layers, index)
end

---@param entity Entity
---@param layer Layer
function Scene:add_entity(entity, layer)
	entity.layer = layer
	entity.depth = layer.depth
	table.insert(self.entities, entity)
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

---@return table
function Scene:entity_type_count()
	local counts = {}

	for _, entity in pairs(self.entities) do
		local key = tostring(entity):lower()

		if not counts[key] then
			counts[key] = 0
		end

		counts[key] = counts[key] + 1
	end

	require("libs.pprint")(counts)
	return counts
end

return true
