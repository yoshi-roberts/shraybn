ScenePanel = {
	display = require("editor.ui.scene_panel"),
}

---@param scene SceneData
---@param layer Layer
---@param type string | "sprite" | "trigger"
function ScenePanel.add_entity(scene, layer, type)
	-- Make sure entity count is not nil.
	if not scene.entity_count[type] then
		scene.entity_count[type] = 0
	end

	local name

	-- if scene.last_deleted then
	-- 	name
	-- end

	local suffix = scene.entity_count[type]

	-- Set name to entity that was last deleted?

	if type == "sprite" then
		scene.data:add_entity(Sprite("Sprite" .. suffix), layer)
	elseif type == "trigger" then
		scene.data:add_entity(Trigger("Trigger" .. suffix), layer)
	end

	scene.entity_count[type] = scene.entity_count[type] + 1
	scene.saved = false
end

---@param scene SceneData
---@param type string | "sprite" | "trigger"
function ScenePanel.add_layer(scene, type)
	local layer = scene.data:add_layer("Layer " .. #scene.data.layers + 1, {})
	ScenePanel.add_entity(scene, layer, type)

	scene.saved = false
end
