local menubar = require("editor.menubar")
local scene_tabs = require("editor.scene_tabs")
local ffi = require("ffi")

Dockspace = {
	layout_applied = false,
	id = 0,
}

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

function Dockspace:layout()
	if self.layout_applied then
		return
	end

	local viewport = Imgui.GetMainViewport()
	Imgui.DockBuilderRemoveNode(self.id)
	Imgui.DockBuilderAddNode(self.id, Imgui.ImGuiDockNodeFlags_DockSpace)
	Imgui.DockBuilderSetNodeSize(self.id, viewport.Size)

	local left_id = ffi.new("ImGuiID[1]")
	local right_id = ffi.new("ImGuiID[1]")
	Imgui.DockBuilderSplitNode(self.id, Imgui.ImGuiDir_Left, 0.25, left_id, right_id)

	-- Left top/bottom nodes.
	local left_top_id = ffi.new("ImGuiID[1]")
	local left_bottom_id = ffi.new("ImGuiID[1]")
	Imgui.DockBuilderSplitNode(left_id[0], Imgui.ImGuiDir_Down, 0.50, left_bottom_id, left_top_id)

	-- Center and right-hand side nodes.
	local right_side_id = ffi.new("ImGuiID[1]")
	local center_id = ffi.new("ImGuiID[1]")
	Imgui.DockBuilderSplitNode(right_id[0], Imgui.ImGuiDir_Right, 0.25, right_side_id, center_id)

	-- Dock windows.
	Imgui.DockBuilderDockWindow("Scene", left_top_id[0])
	Imgui.DockBuilderDockWindow("Files", left_bottom_id[0])
	Imgui.DockBuilderDockWindow("Inspector", right_side_id[0])
	Imgui.DockBuilderDockWindow("Viewport", center_id[0])

	Imgui.DockBuilderFinish(self.id)
	self.layout_applied = true
end

function Dockspace:display()
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

	scene_tabs()

	self.id = Imgui.GetID_Str("Dockspace")
	Imgui.DockSpace(self.id, Imgui.ImVec2_Float(0.0, 0.0), Imgui.ImGuiDockNodeFlags_PassthruCentralNode)

	menubar()

	Imgui.End()
end
