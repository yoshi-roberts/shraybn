---@class AddLayer
---@field index integer
AddLayer = Command:extend()

---@param scene SceneData
---@param layer Layer
function AddLayer:new(scene, layer)
	self.scene = scene
	self.layer = layer
end

function AddLayer:execute()
	self.index = ScenePanel.add_layer(self.scene, self.layer)
end

function AddLayer:undo()
	ScenePanel.remove_layer(self.scene, self.index)
end

---@class RemoveLayer
---@field layer Layer
RemoveLayer = Command:extend()

---@param scene SceneData
---@param index integer
function RemoveLayer:new(scene, index)
	self.scene = scene
	self.index = index
end

function RemoveLayer:execute()
	self.layer = ScenePanel.remove_layer(self.scene, self.index)
end

function RemoveLayer:undo()
	print("Layer Delete Undo!")
	ScenePanel.add_layer(self.scene, self.layer, self.index)
end
