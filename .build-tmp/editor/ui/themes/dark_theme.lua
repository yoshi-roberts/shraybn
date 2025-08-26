local imgui = require("engine.imgui")

return function(style, colors)
	colors[imgui.ImGuiCol_WindowBg] = imgui.ImVec4_Float(0.1, 0.105, 0.11, 1.0)

	colors[imgui.ImGuiCol_Header] = imgui.ImVec4_Float(0.2, 0.205, 0.21, 1.0)
	colors[imgui.ImGuiCol_HeaderHovered] = imgui.ImVec4_Float(0.3, 0.305, 0.31, 1.0)
	colors[imgui.ImGuiCol_HeaderActive] = imgui.ImVec4_Float(0.15, 0.1505, 0.151, 1.0)

	colors[imgui.ImGuiCol_Button] = imgui.ImVec4_Float(0.2, 0.205, 0.21, 1.0)
	colors[imgui.ImGuiCol_ButtonHovered] = imgui.ImVec4_Float(0.3, 0.305, 0.31, 1.0)
	colors[imgui.ImGuiCol_ButtonActive] = imgui.ImVec4_Float(0.15, 0.1505, 0.151, 1.0)

	colors[imgui.ImGuiCol_FrameBg] = imgui.ImVec4_Float(0.2, 0.205, 0.21, 1.0)
	colors[imgui.ImGuiCol_FrameBgHovered] = imgui.ImVec4_Float(0.3, 0.305, 0.31, 1.0)
	colors[imgui.ImGuiCol_FrameBgActive] = imgui.ImVec4_Float(0.15, 0.1505, 0.151, 1.0)

	colors[imgui.ImGuiCol_Tab] = imgui.ImVec4_Float(0.15, 0.1505, 0.151, 1.0)
	colors[imgui.ImGuiCol_TabHovered] = imgui.ImVec4_Float(0.38, 0.3805, 0.381, 1.0)
	colors[imgui.ImGuiCol_TabActive] = imgui.ImVec4_Float(0.28, 0.2805, 0.281, 1.0)
	colors[imgui.ImGuiCol_TabUnfocused] = imgui.ImVec4_Float(0.15, 0.1505, 0.151, 1.0)
	colors[imgui.ImGuiCol_TabUnfocusedActive] = imgui.ImVec4_Float(0.2, 0.205, 0.21, 1.0)

	colors[imgui.ImGuiCol_TitleBg] = imgui.ImVec4_Float(0.15, 0.1505, 0.151, 1.0)
	colors[imgui.ImGuiCol_TitleBgActive] = imgui.ImVec4_Float(0.15, 0.1505, 0.151, 1.0)
	colors[imgui.ImGuiCol_TitleBgCollapsed] = imgui.ImVec4_Float(0.15, 0.1505, 0.151, 1.0)
end
