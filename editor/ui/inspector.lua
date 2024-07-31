local function display(self)
	Imgui.Begin("Inspector", nil)

	if self.item then
		if self.type == "image" then
			self:image(self.item)
		elseif self.type == "layer" then
			self:layer()
		end
	end

	Imgui.End()
end

return display
