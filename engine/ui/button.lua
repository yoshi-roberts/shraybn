local UIElement = require("engine.ui.element")
local UIRect = require("engine.ui.rect")
local UIText = require("engine.ui.text")

---@class engine.ui.Button: engine.ui.Element
---@field super engine.ui.Element
local UIButton = UIElement:extend()

function UIButton:init(text)
	self.super.init(self)

	self.width = 0
	self.height = 0

	self.rect = UIRect:new(self.width, self.height) ---@type engine.ui.Rect
	self.text = UIText:new(text, "center") ---@type engine.ui.Text
end

---@param position Vec2
function UIButton:update(position)
	local fnt = love.graphics.getFont()

	local w = fnt:getWidth(self.text.text)
	local h = fnt:getHeight()

	self.super.update(self, position, w, h)
	self.rect:update(self.position, self.width, self.height)
	self.text:update(self.position, self.width)
end

function UIButton:draw()
	self.rect:draw()
	self.text:draw()
end

return UIButton
