local Command = require("editor.command.command")

---@class editor.command.RemoveVertex: editor.Command
local RemoveVertex = Command:extend()

---@param mergeable boolean?
---@param trigger engine.Trigger
function RemoveVertex:init(trigger, index, mergeable)
	RemoveVertex.super.init(self, mergeable)

	self.trigger = trigger
	self.index = index
	self.x = 0
	self.y = 0
end

function RemoveVertex:execute()
	self.x = table.remove(self.trigger.verticies, self.index)
	self.y = table.remove(self.trigger.verticies, self.index)
	self.trigger.tris = love.math.triangulate(self.trigger.verticies)
end

function RemoveVertex:undo()
	table.insert(self.trigger.verticies, self.index, self.y)
	table.insert(self.trigger.verticies, self.index, self.x)
	self.trigger.tris = love.math.triangulate(self.trigger.verticies)
end

---@private
function RemoveVertex:__tostring()
	return "RemoveVertex"
end

return RemoveVertex
