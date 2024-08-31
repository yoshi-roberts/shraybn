---@class Command
---@field extend function
Command = Object:extend()

function Command:new()
	self.mergable = false
end

function Command:execute() end

function Command:undo() end
