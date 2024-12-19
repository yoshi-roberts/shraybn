-- TODO: Adding and removing entities should not be functions of scene_panel
local Command = require("editor.command.command")

---@class editor.command.AddEntity : editor.Command
local AddEntity = Command:extend()

---@param scene editor.SceneData
---@param layer engine.Layer
---@param entity engine.Entity
function AddEntity:init(scene, layer, entity)
	AddEntity.super.new(self)

	self.scene = scene
	self.layer = layer
	self.entity = entity
	self.index = 0
end

function AddEntity:execute()
	-- self.index = scene_panel.add_entity(self.scene, self.layer, self.entity)
end

function AddEntity:undo()
	-- scene_panel.remove_entity(self.scene, self.index)
end

---@class editor.command.RemoveEntity : editor.Command
---@field entity engine.Entity
local RemoveEntity = Command:extend()

---@param scene editor.SceneData
---@param index integer
function RemoveEntity:init(scene, index)
	self.scene = scene
	self.index = index
end

function RemoveEntity:execute()
	-- self.entity = scene_panel.remove_entity(self.scene, self.index)
end

function RemoveEntity:undo()
	-- scene_panel.add_entity(self.scene, self.entity.layer, self.entity, self.index)
end

---@return editor.command.AddEntity, editor.command.RemoveEntity
return AddEntity, RemoveEntity
