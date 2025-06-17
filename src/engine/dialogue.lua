local Class = require("libs.class")
local Layer = require("engine.layer")
local input = require("engine.input")
local ui = require("engine.ui")

---@class engine.DialogueBox: Class
local DialogueBox = Class:extend()

function DialogueBox:init()
	self.visible = false
	self.title = ""
	self.messages = {}
	self.current_message = nil
end

function DialogueBox:queue(title, text)
	table.insert(self.messages, {
		title = title,
		text = text,
	})

	if not self.current_message then
		self.current_message = 1
	end

	self.visible = true
end

function DialogueBox:update(dt)
	if not self.visible or not self.current_message then
		return
	end

	if input.button_pressed(input.mouse_button.LEFT) then
		if self.current_message < #self.messages then
			self.current_message = self.current_message + 1
		else
			self.visible = false
			self.current_message = nil
		end
	end
end

function DialogueBox:draw()
	if not self.visible then
		return
	end

	local msg = self.messages[self.current_message]

	ui:start(0, -32, 256 * 2, 128, "center", "bottom")
	ui:label(msg.title)
	ui:separator()
	ui:label(msg.text)
end

return DialogueBox
