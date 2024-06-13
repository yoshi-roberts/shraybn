local apply_theme = require("editor.theme")
local dockspace = require("editor.dockspace")
local scene_panel = require("editor.scene_panel")

local function ui_event(code, data)
	return ImguiEvent(code, data)
end

local function ui_attach()
	Imgui.love.Init()

	local io = Imgui.GetIO()
	io.ConfigFlags = bit.bor(io.ConfigFlags, Imgui.ImGuiConfigFlags_DockingEnable)

	-- print(apply_theme)
	apply_theme()

	Event:register_category(EVENT_CATEGORY.INPUT, ui_event)
end

local function ui_detach()
	Imgui.love.Shutdown()
end

local function ui_update(dt)
	Imgui.love.Update(dt)
	Imgui.NewFrame()
end

local function ui_draw()
	dockspace()

	scene_panel()

	FilePanel:display()

	SceneViewer:display()

	Imgui.Begin("Inspector", nil)

	-- if Assets:loaded() and selected_asset ~= 0 then
	-- 	local img = Assets:get("image", selected_asset)
	-- 	local size = Imgui.ImVec2_Float(img:getDimensions())
	-- 	Imgui.Image(img, size)
	-- end

	Imgui.End()
	ProjManager.display()

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
