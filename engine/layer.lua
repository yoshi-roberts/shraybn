local Class = require("libs.class")

---@class engine.Layer: Class
---@field name string
local Layer = Class:extend()

---@param callbacks table
---@param depth integer?
function Layer:init(callbacks, depth)
	self.depth = depth or 0
	self.is_active = true

	if not callbacks then
		return
	end

	-- NOTE: Just keeping these in a callbacks table might be good.
	self.attach = callbacks.attach or nil
	self.detach = callbacks.detach or nil
	self.update = callbacks.update or nil
	self.draw = callbacks.draw or nil

	if self.attach then
		self:attach()
	end
end

---@private
function Layer:__tostring()
	return "Layer"
end

return Layer
