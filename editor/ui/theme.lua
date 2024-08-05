local ffi = require("ffi")
local default_style = require("editor.ui.themes.deep_dark")
local material_dark = require("editor.ui.themes.material_dark")

local function apply_icons()
	local imio = Imgui.GetIO()
	local font_size = 18
	local icon_font_size = font_size

	local icon_ranges = ffi.new("const ImWchar[3]", { FONT_ICONS.ICON_MIN, FONT_ICONS.ICON_MAX, 0 })

	local config = Imgui.ImFontConfig()
	config.MergeMode = true
	config.PixelSnapH = true
	config.GlyphMinAdvanceX = icon_font_size

	local icon_font_path = "editor/resources/" .. FONT_ICONS.FILE_NAME_FK
	imio.Fonts:AddFontFromFileTTF(icon_font_path, icon_font_size, config, icon_ranges)

	Imgui.love.BuildFontAtlas()
end

local function apply_font()
	local imio = Imgui.GetIO()
	local font_size = 16
	local config = Imgui.ImFontConfig()

	config.FontDataOwnedByAtlas = false

	local content, size = love.filesystem.read("editor/resources/Roboto/Roboto-Regular.ttf")
	local newfont = imio.Fonts:AddFontFromMemoryTTF(ffi.cast("void*", content), size, font_size, config)
	imio.FontDefault = newfont

	Imgui.love.BuildFontAtlas()
end

local function apply_theme()
	apply_font()
	apply_icons()

	local style = Imgui.GetStyle()
	local colors = style.Colors

	-- default_style(style, colors)
	material_dark(style, colors)
end

return apply_theme
