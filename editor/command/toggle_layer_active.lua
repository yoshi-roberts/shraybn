local Command = require("editor.command.command")

---@class editor.command.ToggleLayerActive: editor.Command
local ToggleLayerActive = Command:extend()

---@param scene_data editor.SceneData
---@param layer engine.Layer
function ToggleLayerActive:init(scene_data, layer)
	self.layer = layer
	self.scene_data = scene_data
	self.was_saved = scene_data.saved
end

function ToggleLayerActive:execute()
	self.layer.active = not self.layer.active
	self.scene_data.saved = false
end

function ToggleLayerActive:undo()
	self.layer.active = not self.layer.active
	self.scene_data.saved = self.was_saved
end

return ToggleLayerActive
