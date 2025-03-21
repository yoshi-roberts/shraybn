local scene_tabs = require "editor.scene_tabs"
local imgui = require "engine.imgui"
local ffi = require "ffi"

---@class editor.dockspace
local dockspace = {
	id = 0,
}

local window_flags = imgui.love.WindowFlags(
	"MenuBar",
	"NoDocking",
	"NoTitleBar",
	"NoCollapse",
	"NoResize",
	"NoMove",
	"NoBringToFrontOnFocus",
	"NoNavFocus"
)

dockspace.layouts = {
	default = function(id)
		imgui.DockBuilderDockWindow("Scene", id.left_top[0])
		imgui.DockBuilderDockWindow("Files", id.left_bottom[0])
		imgui.DockBuilderDockWindow("Inspector", id.right[0])
		imgui.DockBuilderDockWindow("Viewport", id.center[0])
	end,

	left = function(id)
		imgui.DockBuilderDockWindow("Viewport", id.center[0])
		imgui.DockBuilderDockWindow("Scene", id.left_top[0])
		imgui.DockBuilderDockWindow("Inspector", id.left_top[0])
		imgui.DockBuilderDockWindow("Files", id.left_top[0])
	end,

	right = function(id)
		imgui.DockBuilderDockWindow("Viewport", id.center[0])
		imgui.DockBuilderDockWindow("Scene", id.right[0])
		imgui.DockBuilderDockWindow("Inspector", id.right[0])
		imgui.DockBuilderDockWindow("Files", id.right[0])
	end,

	center = function(id)
		imgui.DockBuilderDockWindow("Files", id.center[0])
		imgui.DockBuilderDockWindow("Scene", id.center[0])
		imgui.DockBuilderDockWindow("Inspector", id.center[0])
		imgui.DockBuilderDockWindow("Viewport", id.center[0])
	end,
}

function dockspace.layout(name)
	local viewport = imgui.GetMainViewport()
	imgui.DockBuilderRemoveNode(dockspace.id)
	imgui.DockBuilderAddNode(dockspace.id, imgui.ImGuiDockNodeFlags_DockSpace)
	imgui.DockBuilderSetNodeSize(dockspace.id, viewport.Size)

	local id = {
		left = ffi.new("ImGuiID[1]"),
		right = ffi.new("ImGuiID[1]"),
		left_top = ffi.new("ImGuiID[1]"),
		left_bottom = ffi.new("ImGuiID[1]"),
		center = ffi.new("ImGuiID[1]"),
	}

	-- local left_id = ffi.new("ImGuiID[1]")
	local right_id = ffi.new("ImGuiID[1]")
	imgui.DockBuilderSplitNode(dockspace.id, imgui.ImGuiDir_Left, 0.25, id.left, right_id)

	imgui.DockBuilderSplitNode(
		id.left[0],
		imgui.ImGuiDir_Down,
		0.50,
		id.left_bottom,
		id.left_top
	)

	-- Center and right-hand side nodes.
	imgui.DockBuilderSplitNode(right_id[0], imgui.ImGuiDir_Right, 0.25, id.right, id.center)

	local fn = dockspace.layouts[name]
	fn(id)

	imgui.DockBuilderFinish(dockspace.id)
end

function dockspace.display()
	local viewport = imgui.GetMainViewport()
	imgui.SetNextWindowPos(viewport.WorkPos)
	imgui.SetNextWindowSize(viewport.WorkSize)
	imgui.SetNextWindowViewport(viewport.ID)

	imgui.PushStyleVar_Float(imgui.ImGuiStyleVar_WindowRounding, 0.0)
	imgui.PushStyleVar_Float(imgui.ImGuiStyleVar_WindowBorderSize, 0.0)

	imgui.PushStyleVar_Vec2(imgui.ImGuiStyleVar_WindowPadding, imgui.ImVec2_Float(0.0, 0.0))

	imgui.Begin("##dockspace", nil, window_flags)

	imgui.PopStyleVar()
	imgui.PopStyleVar(2)

	scene_tabs()

	dockspace.id = imgui.GetID_Str("Dockspace")
	imgui.DockSpace(
		dockspace.id,
		imgui.ImVec2_Float(0.0, 0.0),
		imgui.ImGuiDockNodeFlags_PassthruCentralNode
	)
end

function dockspace.finish()
	imgui.End()
end

return dockspace
