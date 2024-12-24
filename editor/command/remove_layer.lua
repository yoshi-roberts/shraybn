local Command = require("editor.command.command")

---@class editor.command.RemoveLayer : editor.Command
---@field layer engine.Layer
local RemoveLayer = Command:extend()

---@param scene_data editor.SceneData
---@param index integer
function RemoveLayer:init(scene_data, index)
	self.scene_data = scene_data
	self.index = index
end

function RemoveLayer:execute()
	self.layer = self.scene_data:remove_layer(self.index)
end

function RemoveLayer:undo()
	self.scene_data:add_layer(self.layer, self.index)
end

return RemoveLayer
