local Action = require("engine.action")
local Scene = require("engine.scene")
local engine = require("engine")

---@class editor.action.Dialogue: engine.Action
local DialogueAction = Action:extend()

---@param name string
function DialogueAction:init(name)
	self.script_path = name
end

function DialogueAction:execute()
	-- local path = "projects/" .. engine.loaded_project.name .. "/" .. self.scene_path
	--
	-- local scn = engine.add_scene(Scene.load(path))
	-- engine.set_scene(scn.name)
end

function DialogueAction:__tostring()
	return "DialogueAction"
end

return DialogueAction
