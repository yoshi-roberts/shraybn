local event = require("engine.event")
local engine = require("engine")

---@class engine.ui
local ui = {
	theme = {},
	frame = {
		x = 0,
		y = 0,
		w = 0,
		h = 0,
	},
	last = {
		x = 0,
		y = 0,
		w = 0,
		h = 0,
	},
	next = {
		x = 0,
		y = 0,
		w = 0,
		h = 0,
	},
	is_same_line = false,
}

---@type event.callback
local function update_ui_input(code, data)
	local mpos = engine.camera:get_mouse_position()

	if code == event.code.MOUSE_PRESS then
	end

	if code == event.code.MOUSE_RELEASE then
	end

	if code == event.code.KEY_PRESS then
	end

	if code == event.code.KEY_RELEASE then
	end

	return false
end

function ui:init()
	event.register_category(event.category.INPUT, update_ui_input)
end

function ui:update(dt)
	local mpos = engine.camera:get_mouse_position()
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

function ui:update_last(x, y, w, h)
	self.last.x = x
	self.last.y = y
	self.last.w = w
	self.last.h = h
end

function ui:start(x, y, w, h)
	self.frame.x = x
	self.frame.y = y
	self.frame.w = w
	self.frame.h = h

	love.graphics.setColor(self.theme.outline_color)
	love.graphics.rectangle("fill", x - 1, y - 1, w + 2, h + 2)
	love.graphics.setColor(self.theme.bg_color)
	love.graphics.rectangle("fill", x, y, w, h)

	self.next.x = self.frame.x + self.theme.padding
	self.next.y = y + self.theme.padding
	self:draw_debug(x, y, w, h)
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

	-- local width, wrapped_text = fnt:getWrap(text, self.last.w)
	-- self.last.h = fnt:getHeight() * #wrapped_text
	-- self.last.y = y + self.last.h
	-- self.last.x = x

	-- self:update_last(x, y + self.last.h, w, h)
	self:set_next_pos(x, y, w, h)
	self:draw_debug(x, y, w, h)
end

function ui:button(text)
	local fnt = love.graphics.getFont()

	local x, y = self:get_next_pos()
	local w = fnt:getWidth(text)
	local h = fnt:getHeight()

	love.graphics.setColor(self.theme.outline_color)
	love.graphics.rectangle("fill", x - 1, y - 1, w + 2, h + 2)
	love.graphics.setColor(self.theme.bg_color)
	love.graphics.rectangle("fill", x, y, w, h)

	love.graphics.setColor(self.theme.fg_color)
	love.graphics.print(text, x, y)

	self:set_next_pos(x, y, w, h)
	self:draw_debug(x, y, w, h)
end

function ui:finish() end

return ui
