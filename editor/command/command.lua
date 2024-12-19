local Class = require("libs.class")

---@class editor.Command: Class
---@field merge fun(cmd: editor.Command): boolean
local Command = Class:extend()

function Command:init()
	self.mergable = false
end

function Command:execute() end
function Command:undo() end

return Command
