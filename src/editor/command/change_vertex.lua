local Command = require("editor.command.command")

---@class editor.command.ChangeVertex: editor.Command
local ChangeVertex = Command:extend()

---@param mergeable boolean?
---@param trigger engine.Trigger
function ChangeVertex:init(trigger, index, x, y, mergeable)
	ChangeVertex.super.init(self, mergeable)

	self.trigger = trigger
	self.index = index
	self.new_x = x
	self.new_y = y
	self.old_x = trigger.verticies[index]
	self.old_y = trigger.verticies[index + 1]
end

function ChangeVertex:execute()
	self.trigger.verticies[self.index] = self.new_x
	self.trigger.verticies[self.index + 1] = self.new_y
	self.trigger.tris = love.math.triangulate(self.trigger.verticies)
end

function ChangeVertex:undo()
	self.trigger.verticies[self.index] = self.old_x
	self.trigger.verticies[self.index + 1] = self.old_y
	self.trigger.tris = love.math.triangulate(self.trigger.verticies)
end

---@param cmd editor.command.ChangeVertex
---@return boolean
function ChangeVertex:merge(cmd)
	if not cmd:is(ChangeVertex) then
		return false
	end

	if cmd.index ~= self.index then
		return false
	end

	if cmd.trigger == self.trigger then
		cmd.new = self.new
		return true
	end

	return false
end

---@private
function ChangeVertex:__tostring()
	return "ChangeVertex"
end

return ChangeVertex
