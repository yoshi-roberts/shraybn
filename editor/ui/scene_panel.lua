local AddEntity, RemoveEntity = require("editor.command.commands.entity")
local Sprite = require("engine.sprite")

local editor = require("editor")
local font_icon = require("editor.font_icons")
local imgui = require("engine.imgui")

---@param scene editor.SceneData
---@param layer engine.Layer
---@param index integer
local function layer_context_menu(scene, layer, index)
	if imgui.BeginPopupContextItem() then
		if imgui.BeginMenu(font_icon.ICON_PLUS .. "Add") then
			if imgui.MenuItem_Bool(font_icon.ICON_PICTURE_O .. " Sprite") then
				editor.history:add(AddEntity:new(scene, layer, Sprite:new()))
			end

			if imgui.MenuItem_Bool(font_icon.ICON_MOUSE_POINTER .. " Trigger") then
				local points = { 0, 0, 64, 0, 64, 64, 0, 64 }
				editor.history:add(AddEntity(scene, layer, Trigger(points)))
			end

			imgui.EndMenu()
		end

		if imgui.MenuItem_Bool(font_icon.ICON_TRASH .. " Delete") then
			editor.history:add(RemoveLayer(scene, index))
		end

		imgui.EndPopup()
	end
end

---@param scene SceneData
---@param layer Layer
local function layer_list_entities(scene, layer)
	for j, entity in pairs(scene.data.entities) do
		if entity.layer ~= layer then
			break
		end

		if imgui.Selectable_Bool(entity.name) then
			editor.selected_entity = entity
			Inspector:inspect("entity", entity)
		end

		if imgui.BeginPopupContextItem() then
			if imgui.MenuItem_Bool(font_icon.ICON_TRASH .. " Delete") then
				editor.history:add(RemoveEntity(scene, j))
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

	-- The scene data the editor is interactibg with.
	---@type SceneData
	local scene = editor.scenes.current

	local btn_width = imgui.GetContentRegionAvail().x
	if imgui.Button(font_icon.ICON_PLUS .. " New Layer", imgui.ImVec2_Float(btn_width, 0)) then
		editor.history:add(AddLayer(scene, Layer({})))
	end

	for k, layer in pairs(scene.data.layers) do
		local node_flags = { "OpenOnArrow", "OpenOnDoubleClick" }

		if editor.selected_layer == layer then
			table.insert(node_flags, "Selected")
		end

		local eye = layer.active and font_icon.ICON_EYE or font_icon.ICON_EYE_SLASH

		if imgui.Button(eye .. "##" .. layer.name) then
			layer.active = not layer.active
			scene.saved = false
		end

		imgui.SameLine()
		local tree_node_flags = imgui.love.TreeNodeFlags(unpack(node_flags))
		local node_open = imgui.TreeNodeEx_Str(layer.name, tree_node_flags)

		layer_context_menu(scene, layer, k)

		if node_open then
			layer_list_entities(scene, layer)
			imgui.TreePop()
		end

		if imgui.IsItemClicked() then
			editor.selected_layer = layer
			Inspector:inspect("layer", editor.selected_layer)
		end
	end

	imgui.End()
end

return display
