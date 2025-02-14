local Action = require("engine.action")
local engine = require("engine")

---@class editor.action.ChangeScene: engine.Action
local ChangeScene = Action:extend()

---@param name string
function ChangeScene:init(name)
	self.scene_name = name
end

function ChangeScene:execute()
	engine.set_scene(self.scene_name)
end

return ChangeScene
