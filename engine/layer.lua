---@class Layer
Layer = Object:extend()

function Layer:new(name, callbacks)
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

	table.insert(Engine.active_scene.layers, self)
	return Engine.active_scene.layers[#Engine.active_scene.layers]
end

return true
