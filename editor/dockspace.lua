local menubar = require("editor.menubar")

local window_flags = Imgui.love.WindowFlags(
	"MenuBar",
	"NoDocking",
	"NoTitleBar",
	"NoCollapse",
	"NoResize",
	"NoMove",
	"NoBringToFrontOnFocus",
	"NoNavFocus"
)

local function dockspace()
	local viewport = Imgui.GetMainViewport()
	Imgui.SetNextWindowPos(viewport.WorkPos)
	Imgui.SetNextWindowSize(viewport.WorkSize)
	Imgui.SetNextWindowViewport(viewport.ID)

	Imgui.PushStyleVar_Float(Imgui.ImGuiStyleVar_WindowRounding, 0.0)
	Imgui.PushStyleVar_Float(Imgui.ImGuiStyleVar_WindowBorderSize, 0.0)

	Imgui.PushStyleVar_Vec2(Imgui.ImGuiStyleVar_WindowPadding, Imgui.ImVec2_Float(0.0, 0.0))

	Imgui.Begin("##dockspace", nil, window_flags)

	Imgui.PopStyleVar()
	Imgui.PopStyleVar(2)

	-- Tabs of all the open scenes.
	if Imgui.BeginTabBar("##scene_tabs") then
		if not Editor.current_scene then
			if Imgui.BeginTabItem("[empty]") then
				Imgui.EndTabItem()
			end
		end

		for k, scene in pairs(Editor.open_scenes) do
			if Imgui.BeginTabItem(scene.name) then
				Imgui.EndTabItem()
			end
		end

		Imgui.EndTabBar()
	end

	local dockspace_id = Imgui.GetID_Str("Dockspace")
	Imgui.DockSpace(dockspace_id, Imgui.ImVec2_Float(0.0, 0.0), Imgui.ImGuiDockNodeFlags_PassthruCentralNode)

	menubar()

	Imgui.End()
end

return dockspace
