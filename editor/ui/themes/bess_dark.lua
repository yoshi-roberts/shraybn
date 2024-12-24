local imgui = require("engine.imgui")

return function(style, colors)
	colors[imgui.ImGuiCol_Text] = imgui.ImVec4_Float(0.92, 0.93, 0.94, 1.00)
	colors[imgui.ImGuiCol_TextDisabled] = imgui.ImVec4_Float(0.50, 0.52, 0.54, 1.00)
	colors[imgui.ImGuiCol_WindowBg] = imgui.ImVec4_Float(0.14, 0.14, 0.16, 1.00)
	colors[imgui.ImGuiCol_ChildBg] = imgui.ImVec4_Float(0.16, 0.16, 0.18, 1.00)
	colors[imgui.ImGuiCol_PopupBg] = imgui.ImVec4_Float(0.18, 0.18, 0.20, 1.00)
	colors[imgui.ImGuiCol_Border] = imgui.ImVec4_Float(0.28, 0.29, 0.30, 0.60)
	colors[imgui.ImGuiCol_BorderShadow] = imgui.ImVec4_Float(0.00, 0.00, 0.00, 0.00)
	colors[imgui.ImGuiCol_FrameBg] = imgui.ImVec4_Float(0.20, 0.22, 0.24, 1.00)
	colors[imgui.ImGuiCol_FrameBgHovered] = imgui.ImVec4_Float(0.22, 0.24, 0.26, 1.00)
	colors[imgui.ImGuiCol_FrameBgActive] = imgui.ImVec4_Float(0.24, 0.26, 0.28, 1.00)
	colors[imgui.ImGuiCol_TitleBg] = imgui.ImVec4_Float(0.14, 0.14, 0.16, 1.00)
	colors[imgui.ImGuiCol_TitleBgActive] = imgui.ImVec4_Float(0.16, 0.16, 0.18, 1.00)
	colors[imgui.ImGuiCol_TitleBgCollapsed] = imgui.ImVec4_Float(0.14, 0.14, 0.16, 1.00)
	colors[imgui.ImGuiCol_MenuBarBg] = imgui.ImVec4_Float(0.20, 0.20, 0.22, 1.00)
	colors[imgui.ImGuiCol_ScrollbarBg] = imgui.ImVec4_Float(0.16, 0.16, 0.18, 1.00)
	colors[imgui.ImGuiCol_ScrollbarGrab] = imgui.ImVec4_Float(0.24, 0.26, 0.28, 1.00)
	colors[imgui.ImGuiCol_ScrollbarGrabHovered] = imgui.ImVec4_Float(0.28, 0.30, 0.32, 1.00)
	colors[imgui.ImGuiCol_ScrollbarGrabActive] = imgui.ImVec4_Float(0.32, 0.34, 0.36, 1.00)
	colors[imgui.ImGuiCol_CheckMark] = imgui.ImVec4_Float(0.46, 0.56, 0.66, 1.00)
	colors[imgui.ImGuiCol_SliderGrab] = imgui.ImVec4_Float(0.36, 0.46, 0.56, 1.00)
	colors[imgui.ImGuiCol_SliderGrabActive] = imgui.ImVec4_Float(0.40, 0.50, 0.60, 1.00)
	colors[imgui.ImGuiCol_Button] = imgui.ImVec4_Float(0.24, 0.34, 0.44, 1.00)
	colors[imgui.ImGuiCol_ButtonHovered] = imgui.ImVec4_Float(0.28, 0.38, 0.48, 1.00)
	colors[imgui.ImGuiCol_ButtonActive] = imgui.ImVec4_Float(0.32, 0.42, 0.52, 1.00)
	colors[imgui.ImGuiCol_Header] = imgui.ImVec4_Float(0.24, 0.34, 0.44, 1.00)
	colors[imgui.ImGuiCol_HeaderHovered] = imgui.ImVec4_Float(0.28, 0.38, 0.48, 1.00)
	colors[imgui.ImGuiCol_HeaderActive] = imgui.ImVec4_Float(0.32, 0.42, 0.52, 1.00)
	colors[imgui.ImGuiCol_Separator] = imgui.ImVec4_Float(0.28, 0.29, 0.30, 1.00)
	colors[imgui.ImGuiCol_SeparatorHovered] = imgui.ImVec4_Float(0.46, 0.56, 0.66, 1.00)
	colors[imgui.ImGuiCol_SeparatorActive] = imgui.ImVec4_Float(0.46, 0.56, 0.66, 1.00)
	colors[imgui.ImGuiCol_ResizeGrip] = imgui.ImVec4_Float(0.36, 0.46, 0.56, 1.00)
	colors[imgui.ImGuiCol_ResizeGripHovered] = imgui.ImVec4_Float(0.40, 0.50, 0.60, 1.00)
	colors[imgui.ImGuiCol_ResizeGripActive] = imgui.ImVec4_Float(0.44, 0.54, 0.64, 1.00)
	colors[imgui.ImGuiCol_Tab] = imgui.ImVec4_Float(0.20, 0.22, 0.24, 1.00)
	colors[imgui.ImGuiCol_TabHovered] = imgui.ImVec4_Float(0.28, 0.38, 0.48, 1.00)
	colors[imgui.ImGuiCol_TabActive] = imgui.ImVec4_Float(0.24, 0.34, 0.44, 1.00)
	colors[imgui.ImGuiCol_TabUnfocused] = imgui.ImVec4_Float(0.20, 0.22, 0.24, 1.00)
	colors[imgui.ImGuiCol_TabUnfocusedActive] = imgui.ImVec4_Float(0.24, 0.34, 0.44, 1.00)
	colors[imgui.ImGuiCol_DockingPreview] = imgui.ImVec4_Float(0.24, 0.34, 0.44, 0.70)
	colors[imgui.ImGuiCol_DockingEmptyBg] = imgui.ImVec4_Float(0.14, 0.14, 0.16, 1.00)
	colors[imgui.ImGuiCol_PlotLines] = imgui.ImVec4_Float(0.46, 0.56, 0.66, 1.00)
	colors[imgui.ImGuiCol_PlotLinesHovered] = imgui.ImVec4_Float(0.46, 0.56, 0.66, 1.00)
	colors[imgui.ImGuiCol_PlotHistogram] = imgui.ImVec4_Float(0.36, 0.46, 0.56, 1.00)
	colors[imgui.ImGuiCol_PlotHistogramHovered] = imgui.ImVec4_Float(0.40, 0.50, 0.60, 1.00)
	colors[imgui.ImGuiCol_TableHeaderBg] = imgui.ImVec4_Float(0.20, 0.22, 0.24, 1.00)
	colors[imgui.ImGuiCol_TableBorderStrong] = imgui.ImVec4_Float(0.28, 0.29, 0.30, 1.00)
	colors[imgui.ImGuiCol_TableBorderLight] = imgui.ImVec4_Float(0.24, 0.25, 0.26, 1.00)
	colors[imgui.ImGuiCol_TableRowBg] = imgui.ImVec4_Float(0.20, 0.22, 0.24, 1.00)
	colors[imgui.ImGuiCol_TableRowBgAlt] = imgui.ImVec4_Float(0.22, 0.24, 0.26, 1.00)
	colors[imgui.ImGuiCol_TextSelectedBg] = imgui.ImVec4_Float(0.24, 0.34, 0.44, 0.35)
	colors[imgui.ImGuiCol_DragDropTarget] = imgui.ImVec4_Float(0.46, 0.56, 0.66, 0.90)
	colors[imgui.ImGuiCol_NavHighlight] = imgui.ImVec4_Float(0.46, 0.56, 0.66, 1.00)
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
	style.FramePadding = imgui.ImVec2_Float(6.0, 4.0)
	style.ItemSpacing = imgui.ImVec2_Float(8.0, 8.0)
	style.ItemInnerSpacing = imgui.ImVec2_Float(8.0, 6.0)
	style.IndentSpacing = 22.0

	style.ScrollbarSize = 16.0
	style.GrabMinSize = 10.0

	style.AntiAliasedLines = true
	style.AntiAliasedFill = true
end
