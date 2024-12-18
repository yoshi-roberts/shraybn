local lib_path = "./"
local extension = jit.os == "Windows" and "dll"
	or jit.os == "Linux" and "so"
	or jit.os == "OSX" and "dylib"
package.cpath = string.format("%s;%s/?.%s", package.cpath, lib_path, extension)

local event = require("engine.event")
local imgui = require("libs.cimgui")

function ImguiEvent(code, data)
	local handled = true

	if code == event.code.KEY_PRESS then
		imgui.love.KeyPressed(data.key)
		handled = imgui.love.GetWantCaptureKeyboard()
	elseif code == event.code.KEY_RELEASE then
		imgui.love.KeyReleased(data.key)
		handled = imgui.love.GetWantCaptureKeyboard()
	elseif code == event.code.MOUSE_PRESS then
		imgui.love.MousePressed(data.button)
		handled = imgui.love.GetWantCaptureMouse()
	elseif code == event.code.MOUSE_RELEASE then
		imgui.love.MouseReleased(data.button)
		handled = imgui.love.GetWantCaptureMouse()
	elseif code == event.code.MOUSE_MOVE then
		imgui.love.MouseMoved(data.x, data.y)
		handled = imgui.love.GetWantCaptureMouse()
	elseif code == event.code.TEXT_INPUT then
		imgui.love.TextInput(data)
		handled = imgui.love.GetWantCaptureKeyboard()
	elseif code == event.code.MOUSE_WHEEL then
		imgui.love.WheelMoved(data.x, data.y)
		handled = imgui.love.GetWantCaptureMouse()
	end

	return handled
end

return imgui
