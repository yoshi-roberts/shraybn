local Class = require("libs.class")
local binser = require("libs.binser")
local nativefs = require("libs.nativefs")
local log = require("libs.log")

---@class engine.Scene : Class
local Scene = Class:extend()

---@param name string
function Scene:init(name)
	self.name = name
	self.layers = {} ---@type engine.Layer[]
	self.entities = {} ---@type engine.Entity[]
end

function Scene:shutdown()
	for _, layer in pairs(self.layers) do
		if layer.is_active and layer.detach ~= nil then
			layer.detach()
		end
	end
end

function Scene:update(dt)
	for _, entity in pairs(self.entities) do
		-- if entity.layer.active then
		entity:update()
		-- end
	end

	for _, layer in pairs(self.layers) do
		if layer.is_active and layer.update ~= nil then
			layer.update(dt)
		end
	end
end

function Scene:draw()
	for _, entity in pairs(self.entities) do
		-- if entity.layer.active then
		entity:draw()
		-- end
	end

	for _, layer in pairs(self.layers) do
		if layer.is_active and layer.draw ~= nil then
			layer.draw()
		end
	end
end

function Scene:draw_gui()
	for _, layer in pairs(self.layers) do
		if layer.is_active and layer.draw_gui ~= nil then
			layer.draw_gui()
		end
	end
end

---@param layer engine.Layer
---@param index ?integer
---@return engine.Layer
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

---@param entity engine.Entity
---@param layer engine.Layer
---@param index ?integer
function Scene:add_entity(entity, layer, index)
	entity.layer = layer
	entity.depth = layer.depth
	table.insert(self.entities, index or (#self.entities + 1), entity)
end

---@param index integer
---@return engine.Entity
function Scene:remove_entity(index)
	return table.remove(self.entities, index)
end

---@param path string
---@return engine.Scene
function Scene.load(path)
	-- .scd are scene data files.

	local exists = nativefs.getInfo(path)

	if not exists then
		log.error("[SCENE] Could not load scene '" .. path .. "'")
		return Scene:new("scene_load_error")
	end

	local contents = nativefs.read(path)
	local deserialized = binser.deserialize(contents)

	return deserialized[1]
end

---@param path string
function Scene:save(path)
	local serialized = binser.serialize(self)

	if not nativefs.write(path, serialized, #serialized) then
		log.error("Scene data could not be written.")
	end
end

-- Returns a list of all the entities belonging to a layer.
---@param index integer
---@return engine.Entity[]
function Scene:get_layer_entities(index)
	local layer = self.layers[index]
	local entities = {}

	for _, entity in pairs(self.entities) do
		if entity.layer == layer then
			table.insert(entities, entity)
		end
	end

	return entities
end

---@private
function Scene:__tostring()
	return "Scene"
end

return Scene
