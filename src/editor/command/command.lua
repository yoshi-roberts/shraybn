local Class = require("libs.class")

---@class editor.Command: Class
---@field merge fun(self: editor.Command, cmd: editor.Command): boolean
local Command = Class:extend()

---@param mergeable boolean?
function Command:init(mergeable)
	self.mergeable = mergeable or false
	self.timestamp = love.timer.getTime()
end

function Command:execute() end
function Command:undo() end

return Command
