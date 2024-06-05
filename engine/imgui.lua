local lib_path = "./"
local extension = jit.os == "Windows" and "dll" or jit.os == "Linux" and "so" or jit.os == "OSX" and "dylib"
package.cpath = string.format("%s;%s/?.%s", package.cpath, lib_path, extension)

Imgui = require("libs.cimgui")

function ImguiEvent(code, data)
	local handled = false

	if code == EVENT_CODE.KEY_PRESS then
		Imgui.love.KeyPressed(data.key)
		handled = Imgui.love.GetWantCaptureKeyboard()
	elseif code == EVENT_CODE.KEY_RELEASE then
		Imgui.love.KeyReleased(data.key)
		handled = Imgui.love.GetWantCaptureKeyboard()
		handled = Imgui.love.GetWantCaptureMouse()
	elseif code == EVENT_CODE.MOUSE_PRESS then
		Imgui.love.MousePressed(data.button)
		handled = Imgui.love.GetWantCaptureMouse()
	elseif code == EVENT_CODE.MOUSE_RELEASE then
		Imgui.love.MouseReleased(data.button)
		handled = Imgui.love.GetWantCaptureMouse()
	elseif code == EVENT_CODE.MOUSE_MOVE then
		Imgui.love.MouseMoved(data.x, data.y)
		handled = Imgui.love.GetWantCaptureMouse()
	elseif code == EVENT_CODE.TEXT_INPUT then
		Imgui.love.TextInput(data)
		handled = Imgui.love.GetWantCaptureKeyboard()
	elseif code == EVENT_CODE.MOUSE_WHEEL then
		Imgui.love.WheelMoved(data.x, data.y)
		handled = Imgui.love.GetWantCaptureMouse()
	end

	return handled
end
