local Action = require("engine.action")
local Scene = require("engine.scene")
local engine = require("engine")

---@class editor.action.ChangeScene: engine.Action
local ChangeScene = Action:extend()

---@param name string
function ChangeScene:init(name)
	self.scene_path = name
end

function ChangeScene:execute()
	local path = "projects/" .. engine.loaded_project.name .. "/" .. self.scene_path

	local scn = engine.add_scene(Scene.load(path))
	engine.set_scene(scn.name)
end

return ChangeScene
