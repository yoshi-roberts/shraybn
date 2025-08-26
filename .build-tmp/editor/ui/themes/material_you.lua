-- Dark blue: 0.18, 0.471, 0.91
-- Light blue: 0.29, 0.62, 0.91

return function(imgui)
	local style = imgui.GetStyle()
	local colors = style.Colors

	local primary = imgui.ImVec4_Float(0.29, 0.267, 0.345, 1.0)
	local primary_hover = imgui.ImVec4_Float(0.239, 0.341, 0.439, 1.0)

	colors[imgui.ImGuiCol_Text] = imgui.ImVec4_Float(0.93, 0.93, 0.94, 1.00)
	colors[imgui.ImGuiCol_TextDisabled] = imgui.ImVec4_Float(0.50, 0.50, 0.50, 1.00)
	colors[imgui.ImGuiCol_WindowBg] = imgui.ImVec4_Float(0.12, 0.12, 0.12, 1.00)
	colors[imgui.ImGuiCol_ChildBg] = imgui.ImVec4_Float(0.12, 0.12, 0.12, 1.00)
	colors[imgui.ImGuiCol_PopupBg] = imgui.ImVec4_Float(0.15, 0.15, 0.15, 1.00)
	colors[imgui.ImGuiCol_Border] = imgui.ImVec4_Float(0.25, 0.25, 0.28, 1.00)
	colors[imgui.ImGuiCol_BorderShadow] = imgui.ImVec4_Float(0.00, 0.00, 0.00, 0.00)
	colors[imgui.ImGuiCol_FrameBg] = imgui.ImVec4_Float(0.18, 0.18, 0.18, 1.00)
	colors[imgui.ImGuiCol_FrameBgHovered] = imgui.ImVec4_Float(0.22, 0.22, 0.22, 1.00)
	colors[imgui.ImGuiCol_FrameBgActive] = imgui.ImVec4_Float(0.24, 0.24, 0.24, 1.00)
	colors[imgui.ImGuiCol_TitleBg] = imgui.ImVec4_Float(0.14, 0.14, 0.14, 1.00)
	colors[imgui.ImGuiCol_TitleBgActive] = imgui.ImVec4_Float(0.16, 0.16, 0.16, 1.00)
	colors[imgui.ImGuiCol_TitleBgCollapsed] = imgui.ImVec4_Float(0.14, 0.14, 0.14, 1.00)
	colors[imgui.ImGuiCol_MenuBarBg] = imgui.ImVec4_Float(0.14, 0.14, 0.14, 1.00)
	colors[imgui.ImGuiCol_ScrollbarBg] = imgui.ImVec4_Float(0.14, 0.14, 0.14, 1.00)
	colors[imgui.ImGuiCol_ScrollbarGrab] = imgui.ImVec4_Float(0.18, 0.18, 0.18, 1.00)
	colors[imgui.ImGuiCol_ScrollbarGrabHovered] = imgui.ImVec4_Float(0.20, 0.20, 0.20, 1.00)
	colors[imgui.ImGuiCol_ScrollbarGrabActive] = imgui.ImVec4_Float(0.24, 0.24, 0.24, 1.00)
	colors[imgui.ImGuiCol_CheckMark] = imgui.ImVec4_Float(0.45, 0.76, 0.29, 1.00)
	colors[imgui.ImGuiCol_SliderGrab] = primary_hover
	colors[imgui.ImGuiCol_SliderGrabActive] = imgui.ImVec4_Float(0.29, 0.66, 0.91, 1.00)
	colors[imgui.ImGuiCol_Button] = primary
	colors[imgui.ImGuiCol_ButtonHovered] = primary_hover
	colors[imgui.ImGuiCol_ButtonActive] = imgui.ImVec4_Float(0.22, 0.52, 0.91, 1.00)
	colors[imgui.ImGuiCol_Header] = primary
	colors[imgui.ImGuiCol_HeaderHovered] = primary_hover
	colors[imgui.ImGuiCol_HeaderActive] = imgui.ImVec4_Float(0.29, 0.66, 0.91, 1.00)
	colors[imgui.ImGuiCol_Separator] = imgui.ImVec4_Float(0.22, 0.22, 0.22, 1.00)
	colors[imgui.ImGuiCol_SeparatorHovered] = primary_hover
	colors[imgui.ImGuiCol_SeparatorActive] = imgui.ImVec4_Float(0.29, 0.66, 0.91, 1.00)
	colors[imgui.ImGuiCol_ResizeGrip] = primary_hover
	colors[imgui.ImGuiCol_ResizeGripHovered] = imgui.ImVec4_Float(0.29, 0.66, 0.91, 1.00)
	colors[imgui.ImGuiCol_ResizeGripActive] = imgui.ImVec4_Float(0.29, 0.70, 0.91, 1.00)
	colors[imgui.ImGuiCol_Tab] = imgui.ImVec4_Float(0.18, 0.18, 0.18, 1.00)
	colors[imgui.ImGuiCol_TabHovered] = primary_hover
	colors[imgui.ImGuiCol_TabActive] = primary
	colors[imgui.ImGuiCol_TabUnfocused] = imgui.ImVec4_Float(0.14, 0.14, 0.14, 1.00)
	colors[imgui.ImGuiCol_TabUnfocusedActive] = primary
	colors[imgui.ImGuiCol_DockingPreview] = primary_hover
	colors[imgui.ImGuiCol_DockingEmptyBg] = imgui.ImVec4_Float(0.12, 0.12, 0.12, 1.00)
	colors[imgui.ImGuiCol_PlotLines] = imgui.ImVec4_Float(0.61, 0.61, 0.61, 1.00)
	colors[imgui.ImGuiCol_PlotLinesHovered] = imgui.ImVec4_Float(0.29, 0.66, 0.91, 1.00)
	colors[imgui.ImGuiCol_PlotHistogram] = imgui.ImVec4_Float(0.90, 0.70, 0.00, 1.00)
	colors[imgui.ImGuiCol_PlotHistogramHovered] = imgui.ImVec4_Float(1.00, 0.60, 0.00, 1.00)
	colors[imgui.ImGuiCol_TableHeaderBg] = imgui.ImVec4_Float(0.19, 0.19, 0.19, 1.00)
	colors[imgui.ImGuiCol_TableBorderStrong] = imgui.ImVec4_Float(0.31, 0.31, 0.35, 1.00)
	colors[imgui.ImGuiCol_TableBorderLight] = imgui.ImVec4_Float(0.23, 0.23, 0.25, 1.00)
	colors[imgui.ImGuiCol_TableRowBg] = imgui.ImVec4_Float(0.00, 0.00, 0.00, 0.00)
	colors[imgui.ImGuiCol_TableRowBgAlt] = imgui.ImVec4_Float(1.00, 1.00, 1.00, 0.06)
	colors[imgui.ImGuiCol_TextSelectedBg] = primary_hover
	colors[imgui.ImGuiCol_DragDropTarget] = primary_hover
	colors[imgui.ImGuiCol_NavHighlight] = primary_hover
	colors[imgui.ImGuiCol_NavWindowingHighlight] = imgui.ImVec4_Float(1.00, 1.00, 1.00, 0.70)
	colors[imgui.ImGuiCol_NavWindowingDimBg] = imgui.ImVec4_Float(0.80, 0.80, 0.80, 0.20)
	colors[imgui.ImGuiCol_ModalWindowDimBg] = imgui.ImVec4_Float(0.80, 0.80, 0.80, 0.35)

	style.WindowRounding = 8.0
	style.FrameRounding = 4.0
	style.ScrollbarRounding = 6.0
	style.GrabRounding = 4.0
	style.ChildRounding = 4.0

	style.WindowTitleAlign = imgui.ImVec2_Float(0.50, 0.50)
	style.WindowPadding = imgui.ImVec2_Float(10.0, 10.0)
	style.FramePadding = imgui.ImVec2_Float(8.0, 4.0)
	style.ItemSpacing = imgui.ImVec2_Float(8.0, 8.0)
	style.ItemInnerSpacing = imgui.ImVec2_Float(8.0, 6.0)
	style.IndentSpacing = 22.0

	style.ScrollbarSize = 16.0
	style.GrabMinSize = 10.0

	style.AntiAliasedLines = true
	style.AntiAliasedFill = true
end
