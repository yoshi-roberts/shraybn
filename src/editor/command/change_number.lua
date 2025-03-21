local Command = require("editor.command.command")

---@class editor.command.ChangeNumber: editor.Command
local ChangeNumber = Command:extend()

function ChangeNumber:init()
	ChangeNumber.super.init(self)
end

function ChangeNumber:execute() end

function ChangeNumber:undo() end

---@param cmd editor.command.ChangeField
---@return boolean
function ChangeNumber:merge(cmd) end

function ChangeNumber:__tostring()
	return "ChangeNumber"
end

return ChangeNumber
