local Parser = require("shrift.parser") --[[@as shrift.Parser]]
local Action = require("engine.action")
local assets = require("engine.assets")
local pprint = require("libs.pprint")
local signal = require("engine.signal")
local dialogue_manager = require("engine.dialogue_manager")
-- local engine = require("engine")

---@class editor.action.Dialogue: engine.Action
local DialogueAction = Action:extend()

---@param name string
function DialogueAction:init(name)
	self.script_path = name
end

function DialogueAction:execute()
	local script = assets.get(self.script_path).resource
	dialogue_manager.run(Parser:new(script))
end

function DialogueAction:__tostring()
	return "DialogueAction"
end

return DialogueAction
