local imgui = require("engine.imgui")

return function(style, colors)
	style.WindowRounding = 5.0
	style.FrameRounding = 5.0
	style.ScrollbarRounding = 5.0
	style.GrabRounding = 5.0
	style.TabRounding = 5.0
	style.WindowBorderSize = 1.0
	style.FrameBorderSize = 1.0
	style.PopupBorderSize = 1.0
	style.PopupRounding = 5.0

	colors[imgui.ImGuiCol_Text] = imgui.ImVec4_Float(0.95, 0.95, 0.95, 1.00)
	colors[imgui.ImGuiCol_TextDisabled] = imgui.ImVec4_Float(0.60, 0.60, 0.60, 1.00)
	colors[imgui.ImGuiCol_WindowBg] = imgui.ImVec4_Float(0.13, 0.13, 0.13, 1.00)
	colors[imgui.ImGuiCol_ChildBg] = imgui.ImVec4_Float(0.10, 0.10, 0.10, 1.00)
	colors[imgui.ImGuiCol_PopupBg] = imgui.ImVec4_Float(0.18, 0.18, 0.18, 1.)
	colors[imgui.ImGuiCol_Border] = imgui.ImVec4_Float(0.30, 0.30, 0.30, 1.00)
	colors[imgui.ImGuiCol_BorderShadow] = imgui.ImVec4_Float(0.00, 0.00, 0.00, 0.00)
	colors[imgui.ImGuiCol_FrameBg] = imgui.ImVec4_Float(0.20, 0.20, 0.20, 1.00)
	colors[imgui.ImGuiCol_FrameBgHovered] = imgui.ImVec4_Float(0.25, 0.25, 0.25, 1.00)
	colors[imgui.ImGuiCol_FrameBgActive] = imgui.ImVec4_Float(0.30, 0.30, 0.30, 1.00)
	colors[imgui.ImGuiCol_TitleBg] = imgui.ImVec4_Float(0.10, 0.10, 0.10, 1.00)
	colors[imgui.ImGuiCol_TitleBgActive] = imgui.ImVec4_Float(0.20, 0.20, 0.20, 1.00)
	colors[imgui.ImGuiCol_TitleBgCollapsed] = imgui.ImVec4_Float(0.10, 0.10, 0.10, 1.00)
	colors[imgui.ImGuiCol_MenuBarBg] = imgui.ImVec4_Float(0.15, 0.15, 0.15, 1.00)
	colors[imgui.ImGuiCol_ScrollbarBg] = imgui.ImVec4_Float(0.10, 0.10, 0.10, 1.00)
	colors[imgui.ImGuiCol_ScrollbarGrab] = imgui.ImVec4_Float(0.20, 0.20, 0.20, 1.00)
	colors[imgui.ImGuiCol_ScrollbarGrabHovered] = imgui.ImVec4_Float(0.25, 0.25, 0.25, 1.00)
	colors[imgui.ImGuiCol_ScrollbarGrabActive] = imgui.ImVec4_Float(0.30, 0.30, 0.30, 1.00)

	colors[imgui.ImGuiCol_CheckMark] = imgui.ImVec4_Float(0.45, 0.45, 0.45, 1.00)
	colors[imgui.ImGuiCol_SliderGrab] = imgui.ImVec4_Float(0.45, 0.45, 0.45, 1.00)
	colors[imgui.ImGuiCol_SliderGrabActive] = imgui.ImVec4_Float(0.50, 0.50, 0.50, 1.00)
	colors[imgui.ImGuiCol_Button] = imgui.ImVec4_Float(0.25, 0.25, 0.25, 1.00)
	colors[imgui.ImGuiCol_ButtonHovered] = imgui.ImVec4_Float(0.30, 0.30, 0.30, 1.00)
	colors[imgui.ImGuiCol_ButtonActive] = imgui.ImVec4_Float(0.35, 0.35, 0.35, 1.00)
	colors[imgui.ImGuiCol_Header] = imgui.ImVec4_Float(0.40, 0.40, 0.40, 1.00)
	colors[imgui.ImGuiCol_HeaderHovered] = imgui.ImVec4_Float(0.45, 0.45, 0.45, 1.00)
	colors[imgui.ImGuiCol_HeaderActive] = imgui.ImVec4_Float(0.50, 0.50, 0.50, 1.00)
	colors[imgui.ImGuiCol_Separator] = imgui.ImVec4_Float(0.30, 0.30, 0.30, 1.00)
	colors[imgui.ImGuiCol_SeparatorHovered] = imgui.ImVec4_Float(0.35, 0.35, 0.35, 1.00)
	colors[imgui.ImGuiCol_SeparatorActive] = imgui.ImVec4_Float(0.40, 0.40, 0.40, 1.00)
	colors[imgui.ImGuiCol_ResizeGrip] = imgui.ImVec4_Float(0.45, 0.45, 0.45, 1.00)
	colors[imgui.ImGuiCol_ResizeGripHovered] = imgui.ImVec4_Float(0.50, 0.50, 0.50, 1.00)
	colors[imgui.ImGuiCol_ResizeGripActive] = imgui.ImVec4_Float(0.55, 0.55, 0.55, 1.00)
	colors[imgui.ImGuiCol_Tab] = imgui.ImVec4_Float(0.18, 0.18, 0.18, 1.00)
	colors[imgui.ImGuiCol_TabHovered] = imgui.ImVec4_Float(0.40, 0.40, 0.40, 1.00)
	colors[imgui.ImGuiCol_TabActive] = imgui.ImVec4_Float(0.40, 0.40, 0.40, 1.00)
	colors[imgui.ImGuiCol_TabUnfocused] = imgui.ImVec4_Float(0.18, 0.18, 0.18, 1.00)
	colors[imgui.ImGuiCol_TabUnfocusedActive] = imgui.ImVec4_Float(0.40, 0.40, 0.40, 1.00)
	colors[imgui.ImGuiCol_DockingPreview] = imgui.ImVec4_Float(0.45, 0.45, 0.45, 1.00)
	colors[imgui.ImGuiCol_DockingEmptyBg] = imgui.ImVec4_Float(0.18, 0.18, 0.18, 1.00)

	style.FramePadding = imgui.ImVec2_Float(8.0, 4.0)
	style.ItemSpacing = imgui.ImVec2_Float(8.0, 4.0)
	style.IndentSpacing = 20.0
	style.ScrollbarSize = 16.0
end
