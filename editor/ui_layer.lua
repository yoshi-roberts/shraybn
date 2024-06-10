local dockspace = require("editor.dockspace")

local function ui_event(code, data)
	return ImguiEvent(code, data)
end

local function ui_attach()
	Imgui.love.Init()

	local io = Imgui.GetIO()
	io.ConfigFlags = bit.bor(io.ConfigFlags, Imgui.ImGuiConfigFlags_DockingEnable)

	Event:register_category(EVENT_CATEGORY.INPUT, ui_event)
end

local function ui_detach()
	Imgui.love.Shutdown()
end

local function ui_update(dt)
	Imgui.love.Update(dt)
	Imgui.NewFrame()
end

local selected_asset = 0
local function tree(path, branch)
	for k, item in pairs(branch) do
		if type(item) ~= "table" then
			local key = path .. item:match("(.+)%..+")
			if Imgui.Selectable_Bool(item, selected_asset == key) then
				selected_asset = key
			end
		else
			if Imgui.TreeNode_Str(k) then
				tree(path .. k .. ".", item)
				Imgui.TreePop()
			end
		end
	end
end

local function ui_draw()
	dockspace()

	Imgui.Begin("Scene", nil)
	Imgui.End()

	Imgui.Begin("Assets", nil)
	tree("", Assets.file_tree)
	Imgui.End()

	Imgui.Begin("Inspector", nil)

	if Assets:loaded() and selected_asset ~= 0 then
		local img = Assets:get("image", selected_asset)
		local size = Imgui.ImVec2_Float(img:getDimensions())
		Imgui.Image(img, size)
	end

	Imgui.End()

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
