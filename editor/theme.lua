local function apply_theme()
	print("applying theme")

	local style = Imgui.GetStyle()
	local colors = style.Colors

	style.Alpha = 1.0
	style.DisabledAlpha = 1.0
	style.WindowPadding = Imgui.ImVec2_Float(12.0, 12.0)
	style.WindowRounding = 11.5
	style.WindowBorderSize = 0.0
	style.WindowMinSize = Imgui.ImVec2_Float(20.0, 20.0)
	style.WindowTitleAlign = Imgui.ImVec2_Float(0.5, 0.5)
	style.WindowMenuButtonPosition = Imgui.ImGuiDir_Right
	style.ChildRounding = 0.0
	style.ChildBorderSize = 1.0
	style.PopupRounding = 0.0
	style.PopupBorderSize = 1.0
	style.FramePadding = Imgui.ImVec2_Float(20.0, 3.400000095367432)
	style.FrameRounding = 11.89999961853027
	style.FrameBorderSize = 0.0
	style.ItemSpacing = Imgui.ImVec2_Float(4.300000190734863, 5.5)
	style.ItemInnerSpacing = Imgui.ImVec2_Float(7.099999904632568, 1.799999952316284)
	style.CellPadding = Imgui.ImVec2_Float(12.10000038146973, 9.199999809265137)
	style.IndentSpacing = 0.0
	style.ColumnsMinSpacing = 4.900000095367432
	style.ScrollbarSize = 11.60000038146973
	style.ScrollbarRounding = 15.89999961853027
	style.GrabMinSize = 3.700000047683716
	style.GrabRounding = 20.0
	style.TabRounding = 0.0
	style.TabBorderSize = 0.0
	style.TabMinWidthForCloseButton = 0.0
	style.ColorButtonPosition = Imgui.ImGuiDir_Right
	style.ButtonTextAlign = Imgui.ImVec2_Float(0.5, 0.5)
	style.SelectableTextAlign = Imgui.ImVec2_Float(0.0, 0.0)

	colors[Imgui.ImGuiCol_Text] = Imgui.ImVec4_Float(1.0, 1.0, 1.0, 1.0)
	colors[Imgui.ImGuiCol_TextDisabled] =
		Imgui.ImVec4_Float(0.2745098173618317, 0.3176470696926117, 0.4509803950786591, 1.0)
	colors[Imgui.ImGuiCol_WindowBg] =
		Imgui.ImVec4_Float(0.0784313753247261, 0.08627451211214066, 0.1019607856869698, 1.0)
	colors[Imgui.ImGuiCol_ChildBg] =
		Imgui.ImVec4_Float(0.09411764889955521, 0.1019607856869698, 0.1176470592617989, 1.0)
	colors[Imgui.ImGuiCol_PopupBg] =
		Imgui.ImVec4_Float(0.0784313753247261, 0.08627451211214066, 0.1019607856869698, 1.0)
	colors[Imgui.ImGuiCol_Border] = Imgui.ImVec4_Float(0.1568627506494522, 0.168627455830574, 0.1921568661928177, 1.0)
	colors[Imgui.ImGuiCol_BorderShadow] =
		Imgui.ImVec4_Float(0.0784313753247261, 0.08627451211214066, 0.1019607856869698, 1.0)
	colors[Imgui.ImGuiCol_FrameBg] = Imgui.ImVec4_Float(0.1137254908680916, 0.125490203499794, 0.1529411822557449, 1.0)
	colors[Imgui.ImGuiCol_FrameBgHovered] =
		Imgui.ImVec4_Float(0.1568627506494522, 0.168627455830574, 0.1921568661928177, 1.0)
	colors[Imgui.ImGuiCol_FrameBgActive] =
		Imgui.ImVec4_Float(0.1568627506494522, 0.168627455830574, 0.1921568661928177, 1.0)
	colors[Imgui.ImGuiCol_TitleBg] =
		Imgui.ImVec4_Float(0.0470588244497776, 0.05490196123719215, 0.07058823853731155, 1.0)
	colors[Imgui.ImGuiCol_TitleBgActive] =
		Imgui.ImVec4_Float(0.0470588244497776, 0.05490196123719215, 0.07058823853731155, 1.0)
	colors[Imgui.ImGuiCol_TitleBgCollapsed] =
		Imgui.ImVec4_Float(0.0784313753247261, 0.08627451211214066, 0.1019607856869698, 1.0)
	colors[Imgui.ImGuiCol_MenuBarBg] =
		Imgui.ImVec4_Float(0.09803921729326248, 0.105882354080677, 0.1215686276555061, 1.0)
	colors[Imgui.ImGuiCol_ScrollbarBg] =
		Imgui.ImVec4_Float(0.0470588244497776, 0.05490196123719215, 0.07058823853731155, 1.0)
	colors[Imgui.ImGuiCol_ScrollbarGrab] =
		Imgui.ImVec4_Float(0.1176470592617989, 0.1333333402872086, 0.1490196138620377, 1.0)
	colors[Imgui.ImGuiCol_ScrollbarGrabHovered] =
		Imgui.ImVec4_Float(0.1568627506494522, 0.168627455830574, 0.1921568661928177, 1.0)
	colors[Imgui.ImGuiCol_ScrollbarGrabActive] =
		Imgui.ImVec4_Float(0.1176470592617989, 0.1333333402872086, 0.1490196138620377, 1.0)
	colors[Imgui.ImGuiCol_CheckMark] = Imgui.ImVec4_Float(0.9725490212440491, 1.0, 0.4980392158031464, 1.0)
	colors[Imgui.ImGuiCol_SliderGrab] = Imgui.ImVec4_Float(0.9725490212440491, 1.0, 0.4980392158031464, 1.0)
	colors[Imgui.ImGuiCol_SliderGrabActive] = Imgui.ImVec4_Float(1.0, 0.7960784435272217, 0.4980392158031464, 1.0)
	colors[Imgui.ImGuiCol_Button] = Imgui.ImVec4_Float(0.1176470592617989, 0.1333333402872086, 0.1490196138620377, 1.0)
	colors[Imgui.ImGuiCol_ButtonHovered] =
		Imgui.ImVec4_Float(0.1803921610116959, 0.1882352977991104, 0.196078434586525, 1.0)
	colors[Imgui.ImGuiCol_ButtonActive] =
		Imgui.ImVec4_Float(0.1529411822557449, 0.1529411822557449, 0.1529411822557449, 1.0)
	colors[Imgui.ImGuiCol_Header] = Imgui.ImVec4_Float(0.1411764770746231, 0.1647058874368668, 0.2078431397676468, 1.0)
	colors[Imgui.ImGuiCol_HeaderHovered] =
		Imgui.ImVec4_Float(0.105882354080677, 0.105882354080677, 0.105882354080677, 1.0)
	colors[Imgui.ImGuiCol_HeaderActive] =
		Imgui.ImVec4_Float(0.0784313753247261, 0.08627451211214066, 0.1019607856869698, 1.0)
	colors[Imgui.ImGuiCol_Separator] =
		Imgui.ImVec4_Float(0.1294117718935013, 0.1490196138620377, 0.1921568661928177, 1.0)
	colors[Imgui.ImGuiCol_SeparatorHovered] =
		Imgui.ImVec4_Float(0.1568627506494522, 0.1843137294054031, 0.250980406999588, 1.0)
	colors[Imgui.ImGuiCol_SeparatorActive] =
		Imgui.ImVec4_Float(0.1568627506494522, 0.1843137294054031, 0.250980406999588, 1.0)
	colors[Imgui.ImGuiCol_ResizeGrip] =
		Imgui.ImVec4_Float(0.1450980454683304, 0.1450980454683304, 0.1450980454683304, 1.0)
	colors[Imgui.ImGuiCol_ResizeGripHovered] = Imgui.ImVec4_Float(0.9725490212440491, 1.0, 0.4980392158031464, 1.0)
	colors[Imgui.ImGuiCol_ResizeGripActive] = Imgui.ImVec4_Float(1.0, 1.0, 1.0, 1.0)
	colors[Imgui.ImGuiCol_Tab] = Imgui.ImVec4_Float(0.0784313753247261, 0.08627451211214066, 0.1019607856869698, 1.0)
	colors[Imgui.ImGuiCol_TabHovered] =
		Imgui.ImVec4_Float(0.1176470592617989, 0.1333333402872086, 0.1490196138620377, 1.0)
	colors[Imgui.ImGuiCol_TabActive] =
		Imgui.ImVec4_Float(0.1176470592617989, 0.1333333402872086, 0.1490196138620377, 1.0)
	colors[Imgui.ImGuiCol_TabUnfocused] =
		Imgui.ImVec4_Float(0.0784313753247261, 0.08627451211214066, 0.1019607856869698, 1.0)
	colors[Imgui.ImGuiCol_TabUnfocusedActive] =
		Imgui.ImVec4_Float(0.125490203499794, 0.2745098173618317, 0.572549045085907, 1.0)
	colors[Imgui.ImGuiCol_PlotLines] =
		Imgui.ImVec4_Float(0.5215686559677124, 0.6000000238418579, 0.7019608020782471, 1.0)
	colors[Imgui.ImGuiCol_PlotLinesHovered] =
		Imgui.ImVec4_Float(0.03921568766236305, 0.9803921580314636, 0.9803921580314636, 1.0)
	colors[Imgui.ImGuiCol_PlotHistogram] =
		Imgui.ImVec4_Float(0.8823529481887817, 0.7960784435272217, 0.5607843399047852, 1.0)
	colors[Imgui.ImGuiCol_PlotHistogramHovered] =
		Imgui.ImVec4_Float(0.95686274766922, 0.95686274766922, 0.95686274766922, 1.0)
	colors[Imgui.ImGuiCol_TableHeaderBg] =
		Imgui.ImVec4_Float(0.0470588244497776, 0.05490196123719215, 0.07058823853731155, 1.0)
	colors[Imgui.ImGuiCol_TableBorderStrong] =
		Imgui.ImVec4_Float(0.0470588244497776, 0.05490196123719215, 0.07058823853731155, 1.0)
	colors[Imgui.ImGuiCol_TableBorderLight] = Imgui.ImVec4_Float(0.0, 0.0, 0.0, 1.0)
	colors[Imgui.ImGuiCol_TableRowBg] =
		Imgui.ImVec4_Float(0.1176470592617989, 0.1333333402872086, 0.1490196138620377, 1.0)
	colors[Imgui.ImGuiCol_TableRowBgAlt] =
		Imgui.ImVec4_Float(0.09803921729326248, 0.105882354080677, 0.1215686276555061, 1.0)
	colors[Imgui.ImGuiCol_TextSelectedBg] =
		Imgui.ImVec4_Float(0.9372549057006836, 0.9372549057006836, 0.9372549057006836, 1.0)
	colors[Imgui.ImGuiCol_DragDropTarget] = Imgui.ImVec4_Float(0.4980392158031464, 0.5137255191802979, 1.0, 1.0)
	colors[Imgui.ImGuiCol_NavHighlight] = Imgui.ImVec4_Float(0.2666666805744171, 0.2901960909366608, 1.0, 1.0)
	colors[Imgui.ImGuiCol_NavWindowingHighlight] = Imgui.ImVec4_Float(0.4980392158031464, 0.5137255191802979, 1.0, 1.0)
	colors[Imgui.ImGuiCol_NavWindowingDimBg] =
		Imgui.ImVec4_Float(0.196078434586525, 0.1764705926179886, 0.5450980663299561, 0.501960813999176)
	colors[Imgui.ImGuiCol_ModalWindowDimBg] =
		Imgui.ImVec4_Float(0.196078434586525, 0.1764705926179886, 0.5450980663299561, 0.501960813999176)
end

return apply_theme
