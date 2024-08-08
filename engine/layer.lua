---@class Layer
---@field name string
Layer = Object:extend()

---@param callbacks table
---@param depth integer
function Layer:new(callbacks, depth)
	self.depth = depth or 0
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
