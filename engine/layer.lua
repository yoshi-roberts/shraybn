---@class Layer
Layer = Object:extend()

---@param name string
---@param depth integer
---@param callbacks table
function Layer:new(name, depth, callbacks)
	self.name = name
	self.depth = depth
	self.active = true

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
