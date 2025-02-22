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
---@param theme table
function UIButton:update(theme, position)
	local fnt = love.graphics.getFont()

	local w = fnt:getWidth(self.text.text) + (theme.padding * 2)
	local h = fnt:getHeight()

	self.super.update(self, position, w, h)
	self.rect:update(theme, self.position, self.width, self.height)
	self.text:update(theme, self.position, self.width)
end

---@param theme table
function UIButton:draw(theme)
	self.rect:draw(theme)
	self.text:draw(theme)
end

return UIButton
