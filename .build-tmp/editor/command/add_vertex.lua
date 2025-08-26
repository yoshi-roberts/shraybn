local Command = require("editor.command.command")

---@class editor.command.AddVertex: editor.Command
local AddVertex = Command:extend()

---@param mergeable boolean?
---@param trigger engine.Trigger
function AddVertex:init(trigger, index, x, y, mergeable)
	AddVertex.super.init(self, mergeable)

	self.trigger = trigger
	self.index = index
	self.x = x
	self.y = y
end

function AddVertex:execute()
	table.insert(self.trigger.verticies, self.index, self.y)
	table.insert(self.trigger.verticies, self.index, self.x)
	self.trigger.tris = love.math.triangulate(self.trigger.verticies)
end

function AddVertex:undo()
	table.remove(self.trigger.verticies, self.index)
	table.remove(self.trigger.verticies, self.index)
	self.trigger.tris = love.math.triangulate(self.trigger.verticies)
end

---@private
function AddVertex:__tostring()
	return "AddVertex"
end

return AddVertex
