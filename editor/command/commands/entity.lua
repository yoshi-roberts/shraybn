---@class AddEntity
AddEntity = Command:extend()

---@param scene SceneData
---@param layer Layer
---@param entity Entity
function AddEntity:new(scene, layer, entity)
	self.scene = scene
	self.layer = layer
	self.entity = entity
	self.index = 0
end

function AddEntity:execute()
	self.index = ScenePanel.add_entity(self.scene, self.layer, self.entity)
end

function AddEntity:undo()
	ScenePanel.remove_entity(self.scene, self.index)
end

---@class RemoveEntity
---@field entity Entity
RemoveEntity = Command:extend()

---@param scene SceneData
---@param index integer
function RemoveEntity:new(scene, index)
	self.scene = scene
	self.index = index
end

function RemoveEntity:execute()
	self.entity = ScenePanel.remove_entity(self.scene, self.index)
end

function RemoveEntity:undo()
	ScenePanel.add_entity(self.scene, self.entity.layer, self.entity, self.index)
end
