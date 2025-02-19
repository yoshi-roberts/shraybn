local UIElement = require("engine.ui.element")

---@class engine.ui.Frame: engine.ui.Element
local UIFrame = UIElement:extend()

---@param w number
---@param h number
function UIFrame:init(w, h)
	self.position = Vec2(0, 0)
	self.width = w
	self.height = h
	self.elements = {} ---@type engine.ui.Element[]
end

function UIFrame:add(element)
	table.insert(self.elements, element)
end

function UIFrame:update()
	local last_element = nil

	for _, element in pairs(self.elements) do
		local offx = self.position.x
		local offy = self.position.y

		if last_element then
			offy = offy + last_element.position.y + last_element.height
		end

		element.position.x = offx
		element.position.y = offy
		element.width = self.width

		element:update()

		last_element = element
	end
end

function UIFrame:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("fill", 0, 0, self.width, self.height)

	for _, element in pairs(self.elements) do
		element:draw()
	end
end

return UIFrame
