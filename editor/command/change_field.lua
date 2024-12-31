local Command = require("editor.command.command")

---@class editor.command.ChangeField: editor.Command
local ChangeField = Command:extend()

function ChangeField:init(target, field, new)
	ChangeField.super.init(self)

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

	if string.format("%p", cmd.target) == string.format("%p", self.target) then
		cmd.new = self.new
		return true
	end

	return false
end

function ChangeField:__tostring()
	return "ChangeField"
end

return ChangeField
