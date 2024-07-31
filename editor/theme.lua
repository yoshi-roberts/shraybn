local ffi = require("ffi")

local function apply_icons()
	local imio = Imgui.GetIO()
	local font_size = 16
	local icon_font_size = font_size

	local icon_ranges = ffi.new("const ImWchar[3]", { FONT_ICONS.ICON_MIN, FONT_ICONS.ICON_MAX, 0 })

	local config = Imgui.ImFontConfig()
	config.MergeMode = true
	config.PixelSnapH = true
	config.GlyphMinAdvanceX = icon_font_size

	local icon_font_path = "../editor/resources/" .. FONT_ICONS.FILE_NAME_FK
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

	colors[Imgui.ImGuiCol_Text] = Imgui.ImVec4_Float(1.00, 1.00, 1.00, 1.00)
	colors[Imgui.ImGuiCol_TextDisabled] = Imgui.ImVec4_Float(0.50, 0.50, 0.50, 1.00)
	colors[Imgui.ImGuiCol_WindowBg] = Imgui.ImVec4_Float(0.10, 0.10, 0.10, 1.00)
	colors[Imgui.ImGuiCol_ChildBg] = Imgui.ImVec4_Float(0.00, 0.00, 0.00, 0.00)
	colors[Imgui.ImGuiCol_PopupBg] = Imgui.ImVec4_Float(0.19, 0.19, 0.19, 0.92)
	colors[Imgui.ImGuiCol_Border] = Imgui.ImVec4_Float(0.19, 0.19, 0.19, 0.29)
	colors[Imgui.ImGuiCol_BorderShadow] = Imgui.ImVec4_Float(0.00, 0.00, 0.00, 0.24)
	colors[Imgui.ImGuiCol_FrameBg] = Imgui.ImVec4_Float(0.05, 0.05, 0.05, 0.54)
	colors[Imgui.ImGuiCol_FrameBgHovered] = Imgui.ImVec4_Float(0.19, 0.19, 0.19, 0.54)
	colors[Imgui.ImGuiCol_FrameBgActive] = Imgui.ImVec4_Float(0.20, 0.22, 0.23, 1.00)
	colors[Imgui.ImGuiCol_TitleBg] = Imgui.ImVec4_Float(0.00, 0.00, 0.00, 1.00)
	colors[Imgui.ImGuiCol_TitleBgActive] = Imgui.ImVec4_Float(0.06, 0.06, 0.06, 1.00)
	colors[Imgui.ImGuiCol_TitleBgCollapsed] = Imgui.ImVec4_Float(0.00, 0.00, 0.00, 1.00)
	colors[Imgui.ImGuiCol_MenuBarBg] = Imgui.ImVec4_Float(0.14, 0.14, 0.14, 1.00)
	colors[Imgui.ImGuiCol_ScrollbarBg] = Imgui.ImVec4_Float(0.05, 0.05, 0.05, 0.54)
	colors[Imgui.ImGuiCol_ScrollbarGrab] = Imgui.ImVec4_Float(0.34, 0.34, 0.34, 0.54)
	colors[Imgui.ImGuiCol_ScrollbarGrabHovered] = Imgui.ImVec4_Float(0.40, 0.40, 0.40, 0.54)
	colors[Imgui.ImGuiCol_ScrollbarGrabActive] = Imgui.ImVec4_Float(0.56, 0.56, 0.56, 0.54)
	colors[Imgui.ImGuiCol_CheckMark] = Imgui.ImVec4_Float(0.33, 0.67, 0.86, 1.00)
	colors[Imgui.ImGuiCol_SliderGrab] = Imgui.ImVec4_Float(0.34, 0.34, 0.34, 0.54)
	colors[Imgui.ImGuiCol_SliderGrabActive] = Imgui.ImVec4_Float(0.56, 0.56, 0.56, 0.54)
	colors[Imgui.ImGuiCol_Button] = Imgui.ImVec4_Float(0.05, 0.05, 0.05, 0.54)
	colors[Imgui.ImGuiCol_ButtonHovered] = Imgui.ImVec4_Float(0.19, 0.19, 0.19, 0.54)
	colors[Imgui.ImGuiCol_ButtonActive] = Imgui.ImVec4_Float(0.20, 0.22, 0.23, 1.00)
	colors[Imgui.ImGuiCol_Header] = Imgui.ImVec4_Float(0.00, 0.00, 0.00, 0.52)
	colors[Imgui.ImGuiCol_HeaderHovered] = Imgui.ImVec4_Float(0.00, 0.00, 0.00, 0.36)
	colors[Imgui.ImGuiCol_HeaderActive] = Imgui.ImVec4_Float(0.20, 0.22, 0.23, 0.33)
	colors[Imgui.ImGuiCol_Separator] = Imgui.ImVec4_Float(0.28, 0.28, 0.28, 0.29)
	colors[Imgui.ImGuiCol_SeparatorHovered] = Imgui.ImVec4_Float(0.44, 0.44, 0.44, 0.29)
	colors[Imgui.ImGuiCol_SeparatorActive] = Imgui.ImVec4_Float(0.40, 0.44, 0.47, 1.00)
	colors[Imgui.ImGuiCol_ResizeGrip] = Imgui.ImVec4_Float(0.28, 0.28, 0.28, 0.29)
	colors[Imgui.ImGuiCol_ResizeGripHovered] = Imgui.ImVec4_Float(0.44, 0.44, 0.44, 0.29)
	colors[Imgui.ImGuiCol_ResizeGripActive] = Imgui.ImVec4_Float(0.40, 0.44, 0.47, 1.00)
	colors[Imgui.ImGuiCol_Tab] = Imgui.ImVec4_Float(0.00, 0.00, 0.00, 0.52)
	colors[Imgui.ImGuiCol_TabHovered] = Imgui.ImVec4_Float(0.14, 0.14, 0.14, 1.00)
	colors[Imgui.ImGuiCol_TabActive] = Imgui.ImVec4_Float(0.20, 0.20, 0.20, 0.36)
	colors[Imgui.ImGuiCol_TabUnfocused] = Imgui.ImVec4_Float(0.00, 0.00, 0.00, 0.52)
	colors[Imgui.ImGuiCol_TabUnfocusedActive] = Imgui.ImVec4_Float(0.14, 0.14, 0.14, 1.00)
	colors[Imgui.ImGuiCol_DockingPreview] = Imgui.ImVec4_Float(0.33, 0.67, 0.86, 1.00)
	colors[Imgui.ImGuiCol_DockingEmptyBg] = Imgui.ImVec4_Float(1.00, 0.00, 0.00, 1.00)
	colors[Imgui.ImGuiCol_PlotLines] = Imgui.ImVec4_Float(1.00, 0.00, 0.00, 1.00)
	colors[Imgui.ImGuiCol_PlotLinesHovered] = Imgui.ImVec4_Float(1.00, 0.00, 0.00, 1.00)
	colors[Imgui.ImGuiCol_PlotHistogram] = Imgui.ImVec4_Float(1.00, 0.00, 0.00, 1.00)
	colors[Imgui.ImGuiCol_PlotHistogramHovered] = Imgui.ImVec4_Float(1.00, 0.00, 0.00, 1.00)
	colors[Imgui.ImGuiCol_TableHeaderBg] = Imgui.ImVec4_Float(0.00, 0.00, 0.00, 0.52)
	colors[Imgui.ImGuiCol_TableBorderStrong] = Imgui.ImVec4_Float(0.00, 0.00, 0.00, 0.52)
	colors[Imgui.ImGuiCol_TableBorderLight] = Imgui.ImVec4_Float(0.28, 0.28, 0.28, 0.29)
	colors[Imgui.ImGuiCol_TableRowBg] = Imgui.ImVec4_Float(0.00, 0.00, 0.00, 0.00)
	colors[Imgui.ImGuiCol_TableRowBgAlt] = Imgui.ImVec4_Float(1.00, 1.00, 1.00, 0.06)
	colors[Imgui.ImGuiCol_TextSelectedBg] = Imgui.ImVec4_Float(0.20, 0.22, 0.23, 1.00)
	colors[Imgui.ImGuiCol_DragDropTarget] = Imgui.ImVec4_Float(0.33, 0.67, 0.86, 1.00)
	colors[Imgui.ImGuiCol_NavHighlight] = Imgui.ImVec4_Float(1.00, 0.00, 0.00, 1.00)
	colors[Imgui.ImGuiCol_NavWindowingHighlight] = Imgui.ImVec4_Float(1.00, 0.00, 0.00, 0.70)
	colors[Imgui.ImGuiCol_NavWindowingDimBg] = Imgui.ImVec4_Float(1.00, 0.00, 0.00, 0.20)
	colors[Imgui.ImGuiCol_ModalWindowDimBg] = Imgui.ImVec4_Float(1.00, 0.00, 0.00, 0.35)

	style.WindowPadding = Imgui.ImVec2_Float(8.00, 8.00)
	style.FramePadding = Imgui.ImVec2_Float(5.00, 2.00)
	style.CellPadding = Imgui.ImVec2_Float(6.00, 6.00)
	style.ItemSpacing = Imgui.ImVec2_Float(6.00, 6.00)
	style.ItemInnerSpacing = Imgui.ImVec2_Float(6.00, 6.00)
	style.TouchExtraPadding = Imgui.ImVec2_Float(0.00, 0.00)
	style.IndentSpacing = 25
	style.ScrollbarSize = 15
	style.GrabMinSize = 10
	style.WindowBorderSize = 1
	style.ChildBorderSize = 1
	style.PopupBorderSize = 1
	style.FrameBorderSize = 1
	style.TabBorderSize = 1
	style.WindowRounding = 7
	style.ChildRounding = 4
	style.FrameRounding = 3
	style.PopupRounding = 4
	style.ScrollbarRounding = 9
	style.GrabRounding = 3
	style.LogSliderDeadzone = 4
	style.TabRounding = 4
end

return apply_theme
