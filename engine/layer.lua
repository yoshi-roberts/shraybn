Layer = Class({
	name = "",
	attach = nil,
	detach = nil,
	update = nil,
	draw = nil,
})

function Layer:init(name, callbacks)
	self.name = name

	if not callbacks then
		return
	end
	self.attach = callbacks.attach or nil
	self.detach = callbacks.detach or nil
	self.update = callbacks.update or nil
	self.draw = callbacks.draw or nil

	if self.attach then
		self:attach()
	end
end

return true
