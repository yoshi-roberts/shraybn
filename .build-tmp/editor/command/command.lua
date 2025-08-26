local Class = require("libs.class")

---@class editor.Command: Class
---@field merge fun(self: editor.Command, cmd: editor.Command): boolean
local Command = Class:extend()

---@param mergeable boolean?
---@param save_source table?
function Command:init(mergeable, save_source)
	self.mergeable = mergeable or false
	self.timestamp = love.timer.getTime()

	if save_source then
		self.save_source = save_source
		self.save_state_old = save_source.saved
	end
end

function Command:execute()
	if self.save_source then
		self.save_source.saved = false
	end
end

function Command:undo()
	if self.save_source then
		self.save_source.saved = self.save_state_old
	end
end

return Command
