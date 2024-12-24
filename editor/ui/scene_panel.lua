local AddEntity = require("editor.command.add_entity")
local RemoveEntity = require("editor.command.remove_entity")
local AddLayer = require("editor.command.add_layer")
local RemoveLayer = require("editor.command.remove_layer")
local Sprite = require("engine.sprite")
local Layer = require("engine.layer")

local editor = require("editor")
local font_icon = require("editor.font_icons")
local imgui = require("engine.imgui")

---@param scene_data editor.SceneData
---@param layer engine.Layer
---@param index integer
local function layer_context_menu(scene_data, layer, index)
	if imgui.BeginPopupContextItem() then
		if imgui.BeginMenu(font_icon.ICON_PLUS .. "Add") then
			if imgui.MenuItem_Bool(font_icon.ICON_PICTURE_O .. " Sprite") then
				editor.history:add(AddEntity:new(scene_data, layer, Sprite:new()))
			end

			if imgui.MenuItem_Bool(font_icon.ICON_MOUSE_POINTER .. " Trigger") then
				local points = { 0, 0, 64, 0, 64, 64, 0, 64 }
				-- TODO: Add trigger.
			end

			imgui.EndMenu()
		end

		if imgui.MenuItem_Bool(font_icon.ICON_TRASH .. " Delete") then
			editor.history:add(RemoveLayer:new(scene_data, index))
		end

		imgui.EndPopup()
	end
end

---@param scene_data editor.SceneData
---@param layer engine.Layer
local function layer_list_entities(scene_data, layer)
	for j, entity in pairs(scene_data.scene.entities) do
		if entity.layer ~= layer then
			break
		end

		if imgui.Selectable_Bool(entity.name) then
			editor.selected_entity = entity
			-- inspector.inspect("entity", entity)
		end

		if imgui.BeginPopupContextItem() then
			if imgui.MenuItem_Bool(font_icon.ICON_TRASH .. " Delete") then
				editor.history:add(RemoveEntity:new(scene_data, j))
			end

			imgui.EndPopup()
		end
	end
end

local function display()
	imgui.Begin("Scene", nil)

	if not editor.scenes.current then
		imgui.End()
		return
	end

	local scene_data = editor.scenes.current

	local btn_width = imgui.GetContentRegionAvail().x
	if imgui.Button(font_icon.ICON_PLUS .. " New Layer", imgui.ImVec2_Float(btn_width, 0)) then
		editor.history:add(AddLayer:new(scene_data, Layer:new()))
	end

	for k, layer in pairs(scene_data.scene.layers) do
		local node_flags = { "OpenOnArrow", "OpenOnDoubleClick" }

		if editor.selected_layer == layer then
			table.insert(node_flags, "Selected")
		end

		local eye = layer.active and font_icon.ICON_EYE or font_icon.ICON_EYE_SLASH

		if imgui.Button(eye .. "##" .. layer.name) then
			-- TODO: SceneData should handle this.
			-- layer.active = not layer.active
			-- scene_data.saved = false
		end

		imgui.SameLine()
		local tree_node_flags = imgui.love.TreeNodeFlags(unpack(node_flags))
		local node_open = imgui.TreeNodeEx_Str(layer.name, tree_node_flags)

		layer_context_menu(scene_data, layer, k)

		if node_open then
			layer_list_entities(scene_data, layer)
			imgui.TreePop()
		end

		if imgui.IsItemClicked() then
			editor.selected_layer = layer
			-- Inspector:inspect("layer", editor.selected_layer)
		end
	end

	imgui.End()
end

return display
