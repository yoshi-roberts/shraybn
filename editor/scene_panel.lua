---@class editor.scene_panel
local scene_panel = {
	display = require("editor.ui.scene_panel"),
}

---@param scene editor.SceneData
---@param layer engine.Layer
---@param index ?integer
function scene_panel.add_layer(scene, layer, index)
	layer.name = "Layer " .. #scene.scene.layers + 1
	scene.scene:add_layer(layer, index)

	scene.saved = false
	return #scene.scene.layers
end

---@param scene editor.SceneData
---@param index integer
---@return engine.Layer
function scene_panel.remove_layer(scene, index)
	local layer = scene.scene:remove_layer(index)
	scene.entity_count = scene.scene:entity_count()

	scene.saved = false
	return layer
end

return scene_panel
