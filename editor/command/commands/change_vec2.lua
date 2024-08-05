ChangeVec2 = Command:extend()

function ChangeVec2:new(target, new)
	ChangeVec2.super.new()

	self.target = target
	self.new = new
	self.old = target:clone()
end

function ChangeVec2:execute()
	self.target:replace(self.new)
end

function ChangeVec2:undo()
	self.target:replace(self.old)
end
