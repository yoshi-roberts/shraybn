local imgui = require("engine.imgui")

return function(style, colors)
	colors[imgui.ImGuiCol_Text] = imgui.ImVec4_Float(1.00, 1.00, 1.00, 1.00)
	colors[imgui.ImGuiCol_TextDisabled] = imgui.ImVec4_Float(0.50, 0.50, 0.50, 1.00)
	colors[imgui.ImGuiCol_WindowBg] = imgui.ImVec4_Float(0.13, 0.14, 0.15, 1.00)
	colors[imgui.ImGuiCol_ChildBg] = imgui.ImVec4_Float(0.13, 0.14, 0.15, 1.00)
	colors[imgui.ImGuiCol_PopupBg] = imgui.ImVec4_Float(0.13, 0.14, 0.15, 1.00)
	colors[imgui.ImGuiCol_Border] = imgui.ImVec4_Float(0.43, 0.43, 0.50, 0.50)
	colors[imgui.ImGuiCol_BorderShadow] = imgui.ImVec4_Float(0.00, 0.00, 0.00, 0.00)
	colors[imgui.ImGuiCol_FrameBg] = imgui.ImVec4_Float(0.25, 0.25, 0.25, 1.00)
	colors[imgui.ImGuiCol_FrameBgHovered] = imgui.ImVec4_Float(0.38, 0.38, 0.38, 1.00)
	colors[imgui.ImGuiCol_FrameBgActive] = imgui.ImVec4_Float(0.67, 0.67, 0.67, 0.39)
	colors[imgui.ImGuiCol_TitleBg] = imgui.ImVec4_Float(0.08, 0.08, 0.09, 1.00)
	colors[imgui.ImGuiCol_TitleBgActive] = imgui.ImVec4_Float(0.08, 0.08, 0.09, 1.00)
	colors[imgui.ImGuiCol_TitleBgCollapsed] = imgui.ImVec4_Float(0.00, 0.00, 0.00, 0.51)
	colors[imgui.ImGuiCol_MenuBarBg] = imgui.ImVec4_Float(0.14, 0.14, 0.14, 1.00)
	colors[imgui.ImGuiCol_ScrollbarBg] = imgui.ImVec4_Float(0.02, 0.02, 0.02, 0.53)
	colors[imgui.ImGuiCol_ScrollbarGrab] = imgui.ImVec4_Float(0.31, 0.31, 0.31, 1.00)
	colors[imgui.ImGuiCol_ScrollbarGrabHovered] = imgui.ImVec4_Float(0.41, 0.41, 0.41, 1.00)
	colors[imgui.ImGuiCol_ScrollbarGrabActive] = imgui.ImVec4_Float(0.51, 0.51, 0.51, 1.00)
	colors[imgui.ImGuiCol_CheckMark] = imgui.ImVec4_Float(0.11, 0.64, 0.92, 1.00)
	colors[imgui.ImGuiCol_SliderGrab] = imgui.ImVec4_Float(0.11, 0.64, 0.92, 1.00)
	colors[imgui.ImGuiCol_SliderGrabActive] = imgui.ImVec4_Float(0.08, 0.50, 0.72, 1.00)
	colors[imgui.ImGuiCol_Button] = imgui.ImVec4_Float(0.25, 0.25, 0.25, 1.00)
	colors[imgui.ImGuiCol_ButtonHovered] = imgui.ImVec4_Float(0.38, 0.38, 0.38, 1.00)
	colors[imgui.ImGuiCol_ButtonActive] = imgui.ImVec4_Float(0.67, 0.67, 0.67, 0.39)
	colors[imgui.ImGuiCol_Header] = imgui.ImVec4_Float(0.22, 0.22, 0.22, 1.00)
	colors[imgui.ImGuiCol_HeaderHovered] = imgui.ImVec4_Float(0.25, 0.25, 0.25, 1.00)
	colors[imgui.ImGuiCol_HeaderActive] = imgui.ImVec4_Float(0.67, 0.67, 0.67, 0.39)
	colors[imgui.ImGuiCol_Separator] = colors[imgui.ImGuiCol_Border]
	colors[imgui.ImGuiCol_SeparatorHovered] = imgui.ImVec4_Float(0.41, 0.42, 0.44, 1.00)
	colors[imgui.ImGuiCol_SeparatorActive] = imgui.ImVec4_Float(0.26, 0.59, 0.98, 0.95)
	colors[imgui.ImGuiCol_ResizeGrip] = imgui.ImVec4_Float(0.00, 0.00, 0.00, 0.00)
	colors[imgui.ImGuiCol_ResizeGripHovered] = imgui.ImVec4_Float(0.29, 0.30, 0.31, 0.67)
	colors[imgui.ImGuiCol_ResizeGripActive] = imgui.ImVec4_Float(0.26, 0.59, 0.98, 0.95)
	colors[imgui.ImGuiCol_Tab] = imgui.ImVec4_Float(0.08, 0.08, 0.09, 0.83)
	colors[imgui.ImGuiCol_TabHovered] = imgui.ImVec4_Float(0.33, 0.34, 0.36, 0.83)
	colors[imgui.ImGuiCol_TabActive] = imgui.ImVec4_Float(0.23, 0.23, 0.24, 1.00)
	colors[imgui.ImGuiCol_TabUnfocused] = imgui.ImVec4_Float(0.08, 0.08, 0.09, 1.00)
	colors[imgui.ImGuiCol_TabUnfocusedActive] = imgui.ImVec4_Float(0.13, 0.14, 0.15, 1.00)
	colors[imgui.ImGuiCol_DockingPreview] = imgui.ImVec4_Float(0.26, 0.59, 0.98, 0.70)
	colors[imgui.ImGuiCol_DockingEmptyBg] = imgui.ImVec4_Float(0.20, 0.20, 0.20, 1.00)
	colors[imgui.ImGuiCol_PlotLines] = imgui.ImVec4_Float(0.61, 0.61, 0.61, 1.00)
	colors[imgui.ImGuiCol_PlotLinesHovered] = imgui.ImVec4_Float(1.00, 0.43, 0.35, 1.00)
	colors[imgui.ImGuiCol_PlotHistogram] = imgui.ImVec4_Float(0.90, 0.70, 0.00, 1.00)
	colors[imgui.ImGuiCol_PlotHistogramHovered] = imgui.ImVec4_Float(1.00, 0.60, 0.00, 1.00)
	colors[imgui.ImGuiCol_TextSelectedBg] = imgui.ImVec4_Float(0.26, 0.59, 0.98, 0.35)
	colors[imgui.ImGuiCol_DragDropTarget] = imgui.ImVec4_Float(0.11, 0.64, 0.92, 1.00)
	colors[imgui.ImGuiCol_NavHighlight] = imgui.ImVec4_Float(0.26, 0.59, 0.98, 1.00)
	colors[imgui.ImGuiCol_NavWindowingHighlight] = imgui.ImVec4_Float(1.00, 1.00, 1.00, 0.70)
	colors[imgui.ImGuiCol_NavWindowingDimBg] = imgui.ImVec4_Float(0.80, 0.80, 0.80, 0.20)
	colors[imgui.ImGuiCol_ModalWindowDimBg] = imgui.ImVec4_Float(0.80, 0.80, 0.80, 0.35)
	style.GrabRounding = 2.3
	style.FrameRounding = 2.3
end
