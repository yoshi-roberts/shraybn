local default_style = require("editor.ui.themes.deep_dark")
local material_dark = require("editor.ui.themes.material_dark")
local imgui = require("engine.imgui")
local font_icon = require("editor.font_icons")
local ffi = require("ffi")

---@class editor.theme
local theme = {}

local function apply_icons()
	local imio = imgui.GetIO()
	local font_size = 18
	local icon_font_size = font_size

	local icon_ranges =
		ffi.new("const ImWchar[3]", { font_icon.ICON_MIN, font_icon.ICON_MAX, 0 })

	local config = imgui.ImFontConfig()
	config.MergeMode = true
	config.PixelSnapH = true
	config.GlyphMinAdvanceX = icon_font_size

	local icon_font_path = "editor/resources/" .. font_icon.FILE_NAME_FK
	imio.Fonts:AddFontFromFileTTF(icon_font_path, icon_font_size, config, icon_ranges)

	imgui.love.BuildFontAtlas()
end

local function apply_font()
	local imio = imgui.GetIO()
	local font_size = 16
	local config = imgui.ImFontConfig()

	config.FontDataOwnedByAtlas = false

	local content, size = love.filesystem.read("editor/resources/Roboto/Roboto-Regular.ttf")
	local newfont =
		imio.Fonts:AddFontFromMemoryTTF(ffi.cast("void*", content), size, font_size, config)
	imio.FontDefault = newfont

	imgui.love.BuildFontAtlas()
end

function theme.apply()
	apply_font()
	apply_icons()

	local style = imgui.GetStyle()
	local colors = style.Colors

	-- default_style(style, colors)
	material_dark(style, colors)
end

return theme
