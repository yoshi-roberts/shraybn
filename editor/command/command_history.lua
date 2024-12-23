local Class = require("libs.class")

---@class editor.CommandHistory : Class
local CommandHistory = Class:extend()

function CommandHistory:init()
	self.commands = {} ---@type editor.Command[]
	self.current = 0
	self.limit = 64
end

---@param cmd editor.Command: The command object to add.
---@param mergeable boolean?: Set to true to make the command mergeable.
function CommandHistory:add(cmd, mergeable)
	cmd.mergeable = mergeable or false
	cmd:execute()

	-- We don't want to deal with too many commands.
	if #self.commands == self.limit then
		-- Remove the oldest command.
		table.remove(self.commands, 1)
	end

	-- Check if the current command is the latest.
	-- If not, delete all the ones that come after.
	if self.current < #self.commands then
		local i = self.current + 1
		while i <= #self.commands do
			table.remove(self.commands, i)
		end
	end

	table.insert(self.commands, cmd)
	self.current = #self.commands

	-- Merge
	local latest = self.commands[#self.commands]
	local last = self.commands[#self.commands - 1]

	if #self.commands > 1 and last.mergeable and mergeable then
		if last:merge(latest) then
			table.remove(self.commands, #self.commands)
			self.current = #self.commands
		end
	end
end

function CommandHistory:undo()
	if self.current >= 1 then
		self.commands[self.current]:undo()
		self.current = self.current - 1
	end
end

function CommandHistory:redo()
	if self.commands[self.current + 1] then
		self.current = self.current + 1
		self.commands[self.current]:execute()
	end
end

return CommandHistory
