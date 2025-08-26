local Class = require("libs.class")

---@class editor.SceneData: Class
local SceneData = Class:extend()

---@param scene engine.Scene
---@param path string
function SceneData:init(scene, path)
	self.scene = scene
	self.path = path
	self.saved = true
end

---@param layer engine.Layer
---@param entity engine.Entity
---@param index integer?
---@return integer
function SceneData:add_entity(layer, entity, index)
	entity.name = self:get_available_entity_name(layer, entity)
	self.scene:add_entity(entity, layer, index)

	return #self.scene.entities
end

---@param layer engine.Layer
---@param index integer?
---@return integer
function SceneData:add_layer(layer, index)
	layer.name = self:get_available_layer_name()
	self.scene:add_layer(layer, index)

	return #self.scene.layers
end

---@param layer engine.Layer
---@param class Class
---@return string
function SceneData:get_available_entity_name(layer, class)
	local class_type = tostring(class)

	local indicies = {}

	-- Get the indicies of existing entities.
	for _, ent in pairs(self.scene.entities) do
		local ent_layer = ent.layer.name
		local ent_type = tostring(ent)

		if ent_layer == layer.name and ent_type == class_type then
			local index = ent.name:sub(#ent.name, #ent.name)
			index = tonumber(index)

			if index then
				table.insert(indicies, index)
			end
		end
	end

	if #indicies == 0 then
		return class_type .. "1"
	end

	table.sort(indicies, function(a, b)
		return a < b
	end)

	local max = indicies[#indicies]
	local available_name = class_type .. (max + 1)

	for i = 1, max, 1 do
		if not table.index_of(indicies, i) then
			available_name = class_type .. i
			break
		end
	end

	return available_name
end

function SceneData:get_available_layer_name()
	local indicies = {}

	-- Get the indicies of existing entities.
	for _, layer in pairs(self.scene.layers) do
		local index = tonumber(layer.name:sub(#layer.name, #layer.name))

		if index then
			table.insert(indicies, index)
		end
	end

	if #indicies == 0 then
		return "Layer " .. "1"
	end

	table.sort(indicies, function(a, b)
		return a < b
	end)

	local max = indicies[#indicies]
	local available_name = "Layer " .. (max + 1)

	for i = 1, max, 1 do
		if not table.index_of(indicies, i) then
			available_name = "Layer " .. i
			break
		end
	end

	return available_name
end

return SceneData
