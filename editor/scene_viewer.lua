SceneViewer = {}

local win_flags = Imgui.love.WindowFlags("NoTitleBar", "NoMove", "NoCollapse")

function SceneViewer:display()
	Imgui.SetNextWindowDockID(Imgui.GetID_Str("Dockspace"), Imgui.ImGuiCond_FirstUseEver)

	Imgui.Begin("Viewport", nil, nil)

	-- if Imgui.BeginTabBar("##scene_tabs") then
	-- 	if not Editor.current_scene then
	-- 		if Imgui.BeginTabItem("[empty]") then
	-- 			Imgui.EndTabItem()
	-- 		end
	-- 	end
	--
	-- 	for k, scene in pairs(Editor.open_scenes) do
	-- 		if Imgui.BeginTabItem(scene.name) then
	-- 			Imgui.EndTabItem()
	-- 		end
	-- 	end
	--
	-- 	Imgui.EndTabBar()
	-- end

	Imgui.End()
end
