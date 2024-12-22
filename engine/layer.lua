local Class = require("libs.class")
local binser = require("libs.binser")

---@class engine.Layer : Class
---@field name string
local Layer = Class:extend()

---@param callbacks table
---@param depth integer
function Layer:init(callbacks, depth)
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

binser.register(Layer, "Layer")
return Layer
