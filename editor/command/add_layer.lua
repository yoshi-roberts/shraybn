local Command = require("editor.command.command")

---@class editor.command.AddLayer : editor.Command
---@field index integer
local AddLayer = Command:extend()

---@param scene_data editor.SceneData
---@param layer engine.Layer
function AddLayer:init(scene_data, layer)
	self.scene_data = scene_data
	self.layer = layer
end

function AddLayer:execute()
	self.index = self.scene_data:add_layer(self.layer)
end

function AddLayer:undo()
	self.scene_data:remove_layer(self.index)
end

return AddLayer
