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

	Imgui.Begin("Dockspace", nil, window_flags)

	Imgui.PopStyleVar()
	Imgui.PopStyleVar(2)

	local dockspace_id = Imgui.GetID_Str("Dockspace")
	Imgui.DockSpace(dockspace_id, Imgui.ImVec2_Float(0.0, 0.0), nil)

	if Imgui.BeginMenuBar() then
		if Imgui.BeginMenu("File") then
			Imgui.MenuItem_Bool("New", nil, nil)
			Imgui.MenuItem_Bool("Open", nil, nil)
			Imgui.MenuItem_Bool("Save", nil, nil)
			Imgui.MenuItem_Bool("Quit", nil, nil)
			Imgui.EndMenu()
		end
		Imgui.EndMenuBar()
	end

	Imgui.End()
end

return dockspace
