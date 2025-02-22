local UIElement = require("engine.ui.element")
local UIRect = require("engine.ui.rect")

---@class engine.ui.Frame: engine.ui.Element
---@field super engine.ui.Element
local UIFrame = UIElement:extend()

---@param w number
---@param h number
function UIFrame:init(w, h)
	self.super.init(self)

	self.width = w
	self.height = h
	self.elements = {} ---@type engine.ui.Element[]
	self.theme = {
		bg_color = { 0, 0, 0, 1 },
		fg_color = { 1, 1, 1, 1 },
		border_color = { 1, 1, 1, 1 },
		padding = 6,
	}

	self.rect = UIRect:new(w, h) ---@type engine.ui.Rect
end

---@param element engine.ui.Element
---@return engine.ui.Element
function UIFrame:add(element)
	table.insert(self.elements, element)
	return table.front(self.elements)
end

function UIFrame:update()
	-- self.super.update(self, position, width, height)

	local last_element = nil

	for _, element in pairs(self.elements) do
		local offx = self.position.x + self.theme.padding
		local offy = self.position.y + self.theme.padding

		if last_element then
			offy = offy + last_element.position.y + last_element.height
		end

		local w = self.width - (self.theme.padding * 2)

		element:update(self.theme, Vec2(offx, offy), w)

		last_element = element
	end
end

function UIFrame:draw()
	self.rect:draw(self.theme)

	for _, element in pairs(self.elements) do
		element:draw(self.theme)
	end
end

return UIFrame
