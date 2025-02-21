local UIElement = require("engine.ui.element")
local UIRect = require("engine.ui.rect")

---@class engine.ui.Frame: engine.ui.Element
local UIFrame = UIElement:extend()

---@param w number
---@param h number
function UIFrame:init(w, h)
	self.super.init(self)

	self.width = w
	self.height = h
	self.elements = {} ---@type engine.ui.Element[]

	self.rect = UIRect:new(w, h) ---@type engine.ui.Rect
end

---@param element engine.ui.Element
---@return engine.ui.Element
function UIFrame:add(element)
	table.insert(self.elements, element)
	return table.front(self.elements)
end

function UIFrame:update()
	local last_element = nil

	for _, element in pairs(self.elements) do
		local offx = self.position.x
		local offy = self.position.y

		if last_element then
			offy = offy + last_element.position.y + last_element.height
		end

		element:update(Vec2(offx, offy), self.width)

		last_element = element
	end
end

function UIFrame:draw()
	self.rect:draw()

	for _, element in pairs(self.elements) do
		element:draw()
	end
end

return UIFrame
