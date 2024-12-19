local Command = require("editor.command.command")

---@class editor.command.AddLayer : editor.Command
---@field index integer
local AddLayer = Command:extend()

---@param scene editor.SceneData
---@param layer engine.Layer
function AddLayer:init(scene, layer)
	self.scene = scene
	self.layer = layer
end

function AddLayer:execute()
	self.index = scene_panel.add_layer(self.scene, self.layer)
end

function AddLayer:undo()
	scene_panel.remove_layer(self.scene, self.index)
end

---@class editor.command.RemoveLayer : editor.Command
---@field layer engine.Layer
local RemoveLayer = Command:extend()

---@param scene SceneData
---@param index integer
function RemoveLayer:init(scene, index)
	self.scene = scene
	self.index = index
end

function RemoveLayer:execute()
	self.layer = scene_panel.remove_layer(self.scene, self.index)
end

function RemoveLayer:undo()
	print("Layer Delete Undo!")
	scene_panel.add_layer(self.scene, self.layer, self.index)
end
