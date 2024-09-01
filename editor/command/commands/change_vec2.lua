---@class ChangeVec2: Command
---@field super Command
ChangeVec2 = Command:extend()

function ChangeVec2:new(target, new)
	ChangeVec2.super.new(self)

	self.target = target
	self.new = new
	self.old = Vec2(target.x, target.y)
end

function ChangeVec2:execute()
	self.target.x = self.new.x
	self.target.y = self.new.y
end

function ChangeVec2:undo()
	print("Vec2 Undo!")
	self.target.x = self.old.x
	self.target.y = self.old.y
end

---@param cmd ChangeVec2
function ChangeVec2:merge(cmd)
	if not cmd:is(ChangeVec2) then
		return false
	end

	if string.format("%p", cmd.target) == string.format("%p", self.target) then
		cmd.new = self.new
		return true
	end

	return false
end

function ChangeVec2:__tostring()
	return "ChangeVec2"
end
