ScenePanel = {
	display = require("editor.ui.scene_panel"),
}

---@param scene SceneData
---@param layer Layer
---@param type string | "sprite" | "trigger"
function ScenePanel.add_entity(scene, layer, type)
	local name = type:sub(1, 1):upper() .. type:sub(2, #type)

	-- Make sure entity count is not nil.
	if not scene.entity_count[layer.name] then
		scene.entity_count[layer.name] = 0
	end
	local entity_count = scene.entity_count[layer.name]

	if not scene.available_names[layer.name] then
		scene.available_names[layer.name] = {}
	end

	if #scene.available_names[layer.name] > 0 then
		name = table.remove(scene.available_names[layer.name], 1)
	else
		local suffix = entity_count + 1
		name = name .. suffix
	end

	if type == "sprite" then
		scene.data:add_entity(Sprite(name), layer)
	elseif type == "trigger" then
		scene.data:add_entity(Trigger(name), layer)
	end

	scene.entity_count[layer.name] = scene.entity_count[layer.name] + 1
	scene.saved = false
end

---@param scene SceneData
---@param index integer
function ScenePanel.remove_entity(scene, index)
	local e = scene.data.entities[index]

	if not scene.available_names[e.layer.name] then
		scene.available_names[e.layer.name] = {}
	end

	table.insert(scene.available_names[e.layer.name], e.name)

	scene.data:remove_entity(index)

	scene.entity_count = {}
	scene.entity_count = scene.data:entity_count()

	table.sort(scene.available_names, function(a, b)
		return tonumber(a:match("%d+")) < tonumber(b:match("%d+"))
	end)

	scene.saved = false
end

---@param scene SceneData
---@param type string | "sprite" | "trigger"
function ScenePanel.add_layer(scene, type)
	local layer = scene.data:add_layer("Layer " .. #scene.data.layers + 1, {})
	ScenePanel.add_entity(scene, layer, type)

	scene.saved = false
end
