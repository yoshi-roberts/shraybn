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
	for _, entity in pairs(self.entities) do
		if entity.layer.active then
			entity:draw()
		end
	end

	for _, layer in pairs(self.layers) do
		if layer.active and layer.draw ~= nil then
			layer.draw()
		end
	end
end

---@param layer Layer
---@param index ?integer
---@return Layer
function Scene:add_layer(layer, index)
	layer.depth = #self.layers + 1
	table.insert(self.layers, index or (#self.layers + 1), layer)
	return self.layers[#self.layers]
end

---@param index integer
function Scene:remove_layer(index)
	-- Remove all entities associated with the layer.
	local i = 1
	while i <= #self.entities do
		local entity = self.entities[i]

		if entity.layer == self.layers[index] then
			table.remove(self.entities, i)
		else
			i = i + 1
		end
	end

	return table.remove(self.layers, index)
end

---@param entity Entity
---@param layer Layer
---@param index ?integer
function Scene:add_entity(entity, layer, index)
	entity.layer = layer
	entity.depth = layer.depth
	table.insert(self.entities, index or (#self.entities + 1), entity)
end

function Scene:remove_entity(index)
	return table.remove(self.entities, index)
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
function Scene:entity_count()
	local counts = {}

	for _, entity in pairs(self.entities) do
		local layer = entity.layer.name
		local type = tostring(entity)

		-- Make sure values are not nil.
		counts[layer] = counts[layer] or {}
		counts[layer][type] = counts[layer][type] or 0

		counts[layer][type] = counts[layer][type] + 1
	end

	return counts
end

return true
