local scene_tabs = require("editor.scene_tabs")
local ffi = require("ffi")

Dockspace = {
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

Dockspace.layouts = {
	default = function(id)
		Imgui.DockBuilderDockWindow("Scene", id.left_top[0])
		Imgui.DockBuilderDockWindow("Files", id.left_bottom[0])
		Imgui.DockBuilderDockWindow("Inspector", id.right[0])
		Imgui.DockBuilderDockWindow("Viewport", id.center[0])
	end,

	left = function(id)
		Imgui.DockBuilderDockWindow("Viewport", id.center[0])
		Imgui.DockBuilderDockWindow("Scene", id.left_top[0])
		Imgui.DockBuilderDockWindow("Inspector", id.left_top[0])
		Imgui.DockBuilderDockWindow("Files", id.left_top[0])
	end,

	right = function(id)
		Imgui.DockBuilderDockWindow("Viewport", id.center[0])
		Imgui.DockBuilderDockWindow("Scene", id.right[0])
		Imgui.DockBuilderDockWindow("Inspector", id.right[0])
		Imgui.DockBuilderDockWindow("Files", id.right[0])
	end,

	center = function(id)
		Imgui.DockBuilderDockWindow("Files", id.center[0])
		Imgui.DockBuilderDockWindow("Scene", id.center[0])
		Imgui.DockBuilderDockWindow("Inspector", id.center[0])
		Imgui.DockBuilderDockWindow("Viewport", id.center[0])
	end,
}

function Dockspace:layout(name)
	local viewport = Imgui.GetMainViewport()
	Imgui.DockBuilderRemoveNode(self.id)
	Imgui.DockBuilderAddNode(self.id, Imgui.ImGuiDockNodeFlags_DockSpace)
	Imgui.DockBuilderSetNodeSize(self.id, viewport.Size)

	local id = {
		left = ffi.new("ImGuiID[1]"),
		right = ffi.new("ImGuiID[1]"),
		left_top = ffi.new("ImGuiID[1]"),
		left_bottom = ffi.new("ImGuiID[1]"),
		center = ffi.new("ImGuiID[1]"),
	}

	-- local left_id = ffi.new("ImGuiID[1]")
	local right_id = ffi.new("ImGuiID[1]")
	Imgui.DockBuilderSplitNode(self.id, Imgui.ImGuiDir_Left, 0.25, id.left, right_id)

	Imgui.DockBuilderSplitNode(id.left[0], Imgui.ImGuiDir_Down, 0.50, id.left_bottom, id.left_top)

	-- Center and right-hand side nodes.
	Imgui.DockBuilderSplitNode(right_id[0], Imgui.ImGuiDir_Right, 0.25, id.right, id.center)

	local fn = self.layouts[name]
	fn(id)

	Imgui.DockBuilderFinish(self.id)
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

	Menubar:display()

	Imgui.End()
end
