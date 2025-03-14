local initLuis = require("libs.luis.init")
local luis = initLuis("libs/luis/widgets")
luis.flux = require("libs.luis.3rdparty.flux")
local event = require("engine.event")
local engine = require("engine")

---@class engine.ui
local ui = {}

---@type event.callback
local function update_ui_input(code, data)
	local mpos = engine.camera:get_mouse_position()

	if code == event.code.MOUSE_PRESS then
		luis.mousepressed(mpos.x, mpos.y, data.button, data.istouch)
	end

	if code == event.code.MOUSE_RELEASE then
		luis.mousereleased(mpos.x, mpos.y, data.button, data.istouch)
	end

	return false
end

function ui:init()
	event.register_category(event.category.INPUT, update_ui_input)

	local container = luis.newFlexContainer(20, 20, 10, 10)

	-- Add some widgets to the container
	local button1 = luis.newButton("Button 1", 15, 3, function()
		print("Button 1 clicked!")
	end, function()
		print("Button 1 released!")
	end, 5, 2)
	local button2 = luis.newButton("Button 2", 15, 3, function()
		print("Button 2 clicked!")
	end, function()
		print("Button 2 released!")
	end, 5, 2)
	local slider = luis.newSlider(0, 100, 50, 10, 2, function(value)
		print("Slider value:", value)
	end, 10, 2)

	container:addChild(button1)
	container:addChild(button2)
	container:addChild(slider)

	luis.newLayer("main")
	luis.setCurrentLayer("main")

	-- Add the container to your LUIS layer
	luis.createElement(luis.currentLayer, "FlexContainer", container)
end

function ui:update(dt)
	local mpos = engine.camera:get_mouse_position()
	luis.update(dt, mpos.x, mpos.y)
end

function ui:draw()
	luis.draw()
end

return ui
