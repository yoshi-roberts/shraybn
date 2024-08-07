---@class AddLayer
---@field layer Layer
AddLayer = Command:extend()

---@param scene SceneData
function AddLayer:new(scene)
	self.scene = scene
end

function AddLayer:execute()
	self.layer = ScenePanel.add_layer(self.scene)
end

function AddLayer:undo() end
