local Action = require("engine.action")
local Scene = require("engine.scene")
local engine = require("engine")

---@class editor.action.ChangeScene: engine.Action
local ChangeSceneAction = Action:extend()

---@param name string
function ChangeSceneAction:init(name)
	self.scene_path = name
end

function ChangeSceneAction:execute()
	local scn = engine.add_scene(Scene.load(self.scene_path))
	engine.set_scene(scn.name)
end

function ChangeSceneAction:__tostring()
	return "ChangeSceneAction"
end

return ChangeSceneAction
