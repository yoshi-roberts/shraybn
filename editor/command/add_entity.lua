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
end

function AddEntity:execute()
	self.index = self.scene_data:add_entity(self.layer, self.entity)
end

function AddEntity:undo()
	self.scene_data:remove_entity(self.index)
end

---@return editor.command.AddEntity
return AddEntity
