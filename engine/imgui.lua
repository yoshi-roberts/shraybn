local lib_path = "./"
local extension = jit.os == "Windows" and "dll"
	or jit.os == "Linux" and "so"
	or jit.os == "OSX" and "dylib"
package.cpath = string.format("%s;%s/?.%s", package.cpath, lib_path, extension)

local theme = require("editor.ui.themes.material_you")
local font_icon = require("editor.font_icons")
local event = require("engine.event")
local imgui = require("libs.cimgui")
local ffi = require("ffi")

imgui.engine = {}

---@param docking boolean?
function imgui.engine.init(docking)
	imgui.love.Init()

	local io = imgui.GetIO()

	if docking then
		io.ConfigFlags = bit.bor(io.ConfigFlags, imgui.ImGuiConfigFlags_DockingEnable)
	end

	-- Apply font.
	local font_size = 16
	local config = imgui.ImFontConfig()

	config.FontDataOwnedByAtlas = false

	local content, size = love.filesystem.read("editor/resources/Roboto/Roboto-Regular.ttf")
	local newfont =
		io.Fonts:AddFontFromMemoryTTF(ffi.cast("void*", content), size, font_size, config)
	io.FontDefault = newfont

	-- Apply icons.
	local icon_size = 18
	local icon_font_size = icon_size

	local icon_ranges =
		ffi.new("const ImWchar[3]", { font_icon.ICON_MIN, font_icon.ICON_MAX, 0 })

	config.MergeMode = true
	config.PixelSnapH = true
	config.GlyphMinAdvanceX = icon_font_size

	local icon_font_path = "editor/resources/" .. font_icon.FILE_NAME_FK
	io.Fonts:AddFontFromFileTTF(icon_font_path, icon_font_size, config, icon_ranges)

	imgui.love.BuildFontAtlas()

	-- Apply theme.
	theme(imgui)
end

function imgui.engine.shutdown()
	imgui.love.Shutdown()
end

---@param dt number
function imgui.engine.update(dt)
	imgui.love.Update(dt)
	imgui.NewFrame()
end

function imgui.engine.draw()
	imgui.Render()
	imgui.love.RenderDrawLists()
end

---@type event.callback
local function imgui_event_callback(code, data)
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

event.register_category(event.category.INPUT, imgui_event_callback)

return imgui
