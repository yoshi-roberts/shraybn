local Command = require("editor.command.command")

---@class editor.command.AddEntity : editor.Command
local AddEntity = Command:extend()

---@param scene_data editor.SceneData
---@param layer engine.Layer
---@param entity engine.Entity
function AddEntity:init(scene_data, layer, entity)
	AddEntity.super.init(self)

	self.scene_data = scene_data
	self.layer = layer
	self.entity = entity
	self.index = 0
	self.saved = scene_data.saved
end

function AddEntity:execute()
	self.index = self.scene_data:add_entity(self.layer, self.entity)
	self.scene_data.saved = false
end

function AddEntity:undo()
	self.scene_data:remove_entity(self.index)
	self.scene_data.saved = self.saved
end

---@return editor.command.AddEntity
return AddEntity
