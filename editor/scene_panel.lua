ScenePanel = {
	display = require("editor.ui.scene_panel"),
}

---@param scene SceneData
---@param type string | "sprite" | "trigger"
function ScenePanel.add_layer(scene, type)
	local layer = scene.data:add_layer("Layer " .. #scene.data.layers + 1, {})

	-- Make sure entity count is not nil.
	if not scene.entity_count[type] then
		scene.entity_count[type] = 0
	end

	local suffix = scene.entity_count[type]

	if type == "sprite" then
		scene.data:add_entity(Sprite("Sprite" .. suffix), layer)
	elseif type == "trigger" then
		scene.data:add_entity(Trigger("Trigger" .. suffix), layer)
	end

	scene.entity_count[type] = scene.entity_count[type] + 1
	scene.saved = false
end
