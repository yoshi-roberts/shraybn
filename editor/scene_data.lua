local Class = require("libs.class")

---@class editor.SceneData : Class
local SceneData = Class:extend()

---@param scene engine.Scene
---@param path string
function SceneData:init(scene, path)
	self.scene = scene
	self.path = path
	self.saved = true
	self.entity_count = scene:entity_count()
end

---@param layer engine.Layer
---@param entity engine.Entity
---@param index integer?
---@return integer
function SceneData:add_entity(layer, entity, index)
	entity.name = self:get_available_entity_name(layer.name, entity)
	self.scene:add_entity(entity, layer, index)
	self.saved = false

	return #self.scene.entities
end

---@param index integer
---@return engine.Entity
function SceneData:remove_entity(index)
	self.saved = false
	return self.scene:remove_entity(index)
end

---@param layer_name string: The layer to get the count from.
---@param class Class: The entity type to get the count of.
---@return integer
function SceneData:get_entity_count(layer_name, class)
	local class_type = tostring(class)

	if not self.entity_count[layer_name] then
		return 0
	end

	if not self.entity_count[layer_name][class_type] then
		return 0
	end

	for _, ent in pairs(self.scene.entities) do
		local ent_layer = ent.layer.name
		local ent_type = tostring(ent)

		-- Make sure values are not nil.
		self.entity_count[ent_layer] = self.entity_count[ent_layer] or {}

		local count = self.entity_count[ent_layer][ent_type] or 0
		self.entity_count[ent_layer][ent_type] = count + 1
	end

	return self.entity_count[layer_name][class_type]
end

---@param layer_name string
---@param class Class
---@return string
function SceneData:get_available_entity_name(layer_name, class)
	local class_type = tostring(class)

	local indicies = {}

	-- Get the indicies of existing entities.
	for _, ent in pairs(self.scene.entities) do
		local ent_layer = ent.layer.name
		local ent_type = tostring(ent)

		if ent_layer ~= layer_name or ent_type ~= class_type then
			goto continue
		end

		local index = ent.name:sub(#ent.name, #ent.name)
		index = tonumber(index)

		if index then
			table.insert(indicies, index)
		end

		::continue::
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

return SceneData
