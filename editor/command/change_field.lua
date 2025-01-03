local Command = require("editor.command.command")

---@class editor.command.ChangeField: editor.Command
local ChangeField = Command:extend()

---@param mergeable boolean?
function ChangeField:init(target, field, new, mergeable)
	ChangeField.super.init(self, mergeable)

	self.target = target
	self.field = field
	self.new = new
	self.old = target[field]
end

function ChangeField:execute()
	self.target[self.field] = self.new
end

function ChangeField:undo()
	self.target[self.field] = self.old
end

---@param cmd editor.command.ChangeField
---@return boolean
function ChangeField:merge(cmd)
	if not cmd:is(ChangeField) then
		return false
	end

	if cmd.field ~= self.field then
		return false
	end

	if cmd.target == self.target then
		cmd.new = self.new
		return true
	end

	return false
end

---@private
function ChangeField:__tostring()
	return "ChangeField"
end

return ChangeField
