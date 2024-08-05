ChangeVec2 = Command:extend()

function ChangeVec2:new(target, new)
	ChangeVec2.super.new()

	self.target = target
	self.new = new
	self.old = Vec2(target.x, target.y)
end

function ChangeVec2:execute()
	self.target.x = self.new.x
	self.target.y = self.new.y
end

function ChangeVec2:undo()
	self.target.x = self.old.x
	self.target.y = self.old.y
end
