local Class = require("libs.class")

---@class editor.Command: Class
---@field merge fun(self: editor.Command, cmd: editor.Command): boolean
local Command = Class:extend()

---@param mergeable boolean?
function Command:init(mergeable)
	self.mergeable = mergeable or false
end

function Command:execute() end
function Command:undo() end

return Command
