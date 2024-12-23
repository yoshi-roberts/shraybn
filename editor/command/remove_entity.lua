local Command = require("editor.command.command")

---@class editor.command.RemoveEntity : editor.Command
---@field entity engine.Entity
local RemoveEntity = Command:extend()

---@param scene_data editor.SceneData
---@param index integer
function RemoveEntity:init(scene_data, index)
	self.scene_data = scene_data
	self.index = index
end

function RemoveEntity:execute()
	self.entity = self.scene_data:remove_entity(self.index)
end

function RemoveEntity:undo()
	self.scene_data:add_entity(self.entity.layer, self.entity, self.index)
end

---@return editor.command.RemoveEntity
return RemoveEntity
