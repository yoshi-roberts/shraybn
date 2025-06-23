local Parser = require("shrift.parser") --[[@as shrift.Parser]]
local Action = require("engine.action")
local assets = require("engine.assets")
local pprint = require("libs.pprint")
local signal = require("engine.signal")
-- local engine = require("engine")

---@class editor.action.Dialogue: engine.Action
local DialogueAction = Action:extend()

---@param name string
function DialogueAction:init(name)
	self.script_path = name
end

function DialogueAction:execute()
	local script = assets.get(self.script_path).resource
	local parser = Parser:new(script)

	for _, line in pairs(parser.lines) do
		signal.emit("dialogue_manager_queue", line)
	end
end

function DialogueAction:__tostring()
	return "DialogueAction"
end

return DialogueAction
