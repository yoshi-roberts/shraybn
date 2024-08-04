ScenePanel = {
	display = require("editor.ui.scene_panel"),
}

---@param scene SceneData
---@param layer Layer
---@param type string | "sprite" | "trigger"
function ScenePanel.add_entity(scene, layer, type)
	local name = type:sub(1, 1):upper() .. type:sub(2, #type)

	if not scene.entity_count[layer.name] then
		scene.entity_count[layer.name] = {}
	end

	local entity_count = scene.entity_count[layer.name]

	-- Make sure entity count is not nil.
	if not entity_count[type] then
		entity_count[type] = 0
	end

	if scene.last_deleted.type == type then
		name = scene.last_deleted.name
		scene.last_deleted.name = nil
		scene.last_deleted.type = nil
	else
		local suffix = entity_count[type] + 1

		if suffix <= 1 then
			suffix = ""
		end

		name = name .. suffix
	end

	if type == "sprite" then
		scene.data:add_entity(Sprite(name), layer)
	elseif type == "trigger" then
		scene.data:add_entity(Trigger(name), layer)
	end

	entity_count[type] = entity_count[type] + 1
	scene.saved = false
end

---@param scene SceneData
---@param entity Entity
---@param index integer
function ScenePanel.remove_entity(scene, entity, index)
	scene.data:remove_entity(index)

	scene.entity_count = {}
	scene.entity_count = scene.data:entity_type_count()

	scene.last_deleted.name = entity.name
	scene.last_deleted.type = tostring(entity):lower()

	scene.saved = false
end

---@param scene SceneData
---@param type string | "sprite" | "trigger"
function ScenePanel.add_layer(scene, type)
	local layer = scene.data:add_layer("Layer " .. #scene.data.layers + 1, {})
	ScenePanel.add_entity(scene, layer, type)

	scene.saved = false
end
