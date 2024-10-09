ScenePanel = {
	display = require("editor.ui.scene_panel"),
}

---@param scene SceneData
---@param layer Layer
---@param entity Entity
---@param index ?integer
function ScenePanel.add_entity(scene, layer, entity, index)
	local type = tostring(entity)
	local name = tostring(entity)

	local entity_count = scene.entity_count
	local available_names = scene.available_names

	-- Make sure entity count is not nil.
	entity_count[layer.name] = entity_count[layer.name] or {}
	entity_count[layer.name][type] = entity_count[layer.name][type] or 0

	available_names[layer.name] = available_names[layer.name] or {}
	available_names[layer.name][type] = available_names[layer.name][type] or {}

	local count = scene.entity_count[layer.name][type]

	if entity.name then
		scene:remove_name(available_names[layer.name][type], entity.name)
	else
		if #scene.available_names[layer.name][type] > 0 then
			name = table.remove(scene.available_names[layer.name][type], 1)
		else
			local suffix = count + 1
			name = name .. suffix
		end

		entity.name = name
	end

	scene.data:add_entity(entity, layer, index)

	scene.entity_count[layer.name][type] = scene.entity_count[layer.name][type]
		+ 1
	scene.saved = false

	-- Return the index of the added entity.
	return #scene.data.entities
end

---@param scene SceneData
---@param index integer
function ScenePanel.remove_entity(scene, index)
	local ent = scene.data.entities[index]
	local type = tostring(ent)

	local available_names = scene.available_names
	available_names[ent.layer.name] = available_names[ent.layer.name] or {}

	local layer = available_names[ent.layer.name]

	layer[type] = layer[type] or {}
	table.insert(layer[type], ent.name)

	local removed = scene.data:remove_entity(index)

	scene.entity_count = {}
	scene.entity_count = scene.data:entity_count()

	scene:sort_available_names()

	scene.saved = false
	return removed
end

---@param scene SceneData
---@param layer Layer
---@param index ?integer
function ScenePanel.add_layer(scene, layer, index)
	layer.name = "Layer " .. #scene.data.layers + 1
	scene.data:add_layer(layer, index)

	scene.saved = false
	return #scene.data.layers
end

---@param scene SceneData
---@param index integer
---@return Layer
function ScenePanel.remove_layer(scene, index)
	local layer = scene.data:remove_layer(index)
	scene.entity_count = scene.data:entity_count()

	scene.saved = false
	return layer
end
