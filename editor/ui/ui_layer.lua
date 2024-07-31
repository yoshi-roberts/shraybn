local apply_theme = require("editor.theme")
local scene_panel = require("editor.scene_panel")

local function ui_event(code, data)
	return ImguiEvent(code, data)
end

local function ui_attach()
	Imgui.love.Init()

	local io = Imgui.GetIO()
	io.ConfigFlags = bit.bor(io.ConfigFlags, Imgui.ImGuiConfigFlags_DockingEnable)

	apply_theme()

	Viewport:init()

	Event:register_category(EVENT_CATEGORY.INPUT, ui_event)
end

local function ui_detach()
	Imgui.love.Shutdown()
end

local function ui_update(dt)
	Imgui.love.Update(dt)
	Imgui.NewFrame()

	Viewport:update()
end

local function ui_draw()
	Dockspace:display()

	scene_panel()

	FilePanel:display()

	Viewport:display()

	Inspector:display()

	ProjectManager:display()

	-- code to render imgui
	Imgui.Render()
	Imgui.love.RenderDrawLists()
end

Layer("ui_layer", {
	attach = ui_attach,
	detach = ui_detach,
	update = ui_update,
	draw = ui_draw,
	event = ui_event,
})
