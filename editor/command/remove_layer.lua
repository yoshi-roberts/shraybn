local Command = require("editor.command.command")

---@class editor.command.RemoveLayer : editor.Command
---@field layer engine.Layer
local RemoveLayer = Command:extend()

---@param scene_data editor.SceneData
---@param index integer
function RemoveLayer:init(scene_data, index)
	self.scene_data = scene_data
	self.entities = {}
	self.index = index
	self.saved = scene_data.saved
end

function RemoveLayer:execute()
	self.entities = self.scene_data.scene:get_layer_entities(self.index)
	self.layer = self.scene_data.scene:remove_layer(self.index)
	self.scene_data.saved = false
end

function RemoveLayer:undo()
	self.scene_data:add_layer(self.layer, self.index)

	for i, entity in pairs(self.entities) do
		self.scene_data:add_entity(self.layer, entity, i)
	end

	self.entities = {}
	self.scene_data.saved = self.saved
end

return RemoveLayer
