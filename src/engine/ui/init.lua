local input = require("engine.input")

---@alias engine.ui.Element {x: number, y: number, w: number, h: number}

---@class engine.ui
local ui = {
	theme = {},
	frame = {}, ---@type engine.ui.Element
	last = {}, ---@type engine.ui.Element
	next = {}, ---@type engine.ui.Element
	mouse_x = 0,
	mouse_y = 0,
	game_width = 0,
	game_height = 0,
	focussed = nil,
	callback = nil, ---@type function
	is_same_line = false,
}

function ui:init() end

function ui:update(dt, mx, my, gw, gh)
	self.mouse_x = mx
	self.mouse_y = my
	self.game_width = gw
	self.game_height = gh

	if self.focussed then
		if self.callback and input.button_pressed(input.mouse_button.LEFT) then
			self.callback()
		end
	end

	self.focussed = nil
	self.callback = nil
end

---@param theme table
function ui:set_theme(theme)
	self.theme = theme
end

function ui:draw_debug(x, y, w, h)
	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.rectangle("line", x, y, w, h)
end

function ui:get_next_pos()
	local padding = self.theme.padding
	local x, y

	if not self.is_same_line then
		x = self.next.x
		y = self.next.y
	else
		x = self.last.x + self.last.w + padding
		y = self.last.y
		self.is_same_line = false
	end

	return x, y
end

function ui:same_line()
	self.is_same_line = true
end

function ui:set_next_pos(x, y, w, h)
	local padding = self.theme.padding

	self.last.x = x
	self.last.y = y
	self.last.w = w
	self.last.h = h

	self.next.x = self.frame.x + padding
	self.next.y = y + h + padding
end

function ui:get_next_size()
	local padding = self.theme.padding
	local w = self.frame.w - (padding * 2)

	return w
end

---@return boolean
function ui:mouse_in_rect(x, y, w, h)
	if self.mouse_x >= x and self.mouse_x <= x + w then
		if self.mouse_y >= y and self.mouse_y <= y + h then
			return true
		end
	end

	return false
end

function ui:start(x, y, w, h, halign, valign)
	halign = halign or "left"
	valign = valign or "top"

	self.frame.x = x
	self.frame.y = y
	self.frame.w = w
	self.frame.h = h

	local gw, gh = self.game_width, self.game_height

	if halign == "right" then
		self.frame.x = (gw - w) + x
	elseif halign == "center" then
		self.frame.x = ((gw / 2) - (w / 2)) + x
	end

	if valign == "bottom" then
		self.frame.y = (gh - h) + y
	elseif valign == "center" then
		self.frame.y = ((gh / 2) - (h / 2)) + y
	end

	love.graphics.setColor(self.theme.outline_color)
	love.graphics.rectangle(
		"fill",
		self.frame.x - 1,
		self.frame.y - 1,
		self.frame.w + 2,
		self.frame.h + 2
	)
	love.graphics.setColor(self.theme.bg_color)
	love.graphics.rectangle("fill", self.frame.x, self.frame.y, self.frame.w, self.frame.h)

	self.next.x = self.frame.x + self.theme.padding
	self.next.y = self.frame.y + self.theme.padding
	self:draw_debug(self.frame.x, self.frame.y, self.frame.w, self.frame.h)
end

function ui:label(text)
	local padding = self.theme.padding
	local fnt = love.graphics.getFont()

	local x, y = self:get_next_pos()
	local w = self:get_next_size()

	local text_width, wrapped_text = fnt:getWrap(text, w)
	local h = fnt:getHeight() * #wrapped_text

	love.graphics.setColor(self.theme.fg_color)
	love.graphics.printf(text, x, y, w, "left")

	self:set_next_pos(x, y, w, h)
	self:draw_debug(x, y, w, h)
end

---@param text string
---@param callback function?
function ui:button(text, callback)
	local fnt = love.graphics.getFont()
	local theme = self.theme.button.normal

	local x, y = self:get_next_pos()
	local w = fnt:getWidth(text)
	local h = fnt:getHeight()

	if input.button_pressed(input.mouse_button.ANY) then
		print("Hey!")
	end

	if self:mouse_in_rect(x, y, w, h) then
		theme = self.theme.button.focussed
		self.focussed = self.last
		self.callback = callback and callback or self.callback
	end

	love.graphics.setColor(theme.outline_color)
	love.graphics.rectangle("fill", x - 1, y - 1, w + 2, h + 2)
	love.graphics.setColor(theme.bg_color)
	love.graphics.rectangle("fill", x, y, w, h)

	love.graphics.setColor(theme.fg_color)
	love.graphics.print(text, x, y)

	self:set_next_pos(x, y, w, h)
	self:draw_debug(x, y, w, h)
end

function ui:finish() end

return ui
