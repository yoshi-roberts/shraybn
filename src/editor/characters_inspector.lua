local character = require("engine.character")
local font_icon = require("editor.font_icons")
local imgui = require("engine.imgui")
local ffi = require("ffi")

local characters_inspector = {
	buf = ffi.new("char[?]", 128, ""),
	selected_character = nil,
	renaming_node = -1,
}

local function context_menu()
	if imgui.BeginPopupContextItem() then
		if imgui.MenuItem_Bool(font_icon.ICON_PLUS .. " New") then
			-- editor.history:add(RemoveLayer:new(scene_data, index))
		end

		if imgui.MenuItem_Bool(font_icon.ICON_I_CURSOR .. " Rename") then
			-- editor.history:add(RemoveLayer:new(scene_data, index))
		end

		if imgui.MenuItem_Bool(font_icon.ICON_I_CURSOR .. " Delete") then
			-- editor.history:add(RemoveLayer:new(scene_data, index))
		end

		imgui.EndPopup()
	end
end

---@param inspector editor.inspector
local function display(inspector)
	local characters = inspector.item ---@type engine.character.Character[]

	if imgui.Button("New") then
		character.add("Test")
	end

	for k, char in pairs(characters) do
		local node_flags = { "OpenOnArrow", "OpenOnDoubleClick" }

		if characters_inspector.selected_character == char then
			table.insert(node_flags, "Selected")
		end

		local tree_node_flags = imgui.love.TreeNodeFlags(unpack(node_flags))
		local node_open = imgui.TreeNodeEx_Str("##character_node" .. k, tree_node_flags)

		imgui.SameLine()
		if characters_inspector.renaming_node == char then
			if imgui.InputText("##character_rename", characters_inspector.buf, 128) then
				characters_inspector.renaming_node = -1
			end
			if not imgui.IsItemActive() and imgui.IsMouseClicked_Bool(0) then
				characters_inspector.renaming_node = -1
			end
		else
			imgui.TextUnformatted(char.name)
			if imgui.IsItemHovered() and imgui.IsMouseDoubleClicked_Nil(0) then
				characters_inspector.renaming_node = char
			end
		end

		-- context_menu()

		if node_open then
			-- for _, portrait in pairs(char.portraits) do
			-- 	---@cast portrait engine.character.Portrait
			-- 	local title = portrait.mood:sub(1, 1):upper()
			-- 		.. portrait.mood:sub(2, #portrait.mood):lower()
			-- 	imgui.Text(title)
			-- 	imgui.SameLine()
			-- 	inspector.resource(char.portraits[k], "asset_path")
			-- end
			imgui.TreePop()
		end

		-- if imgui.IsItemClicked() then
		-- 	inspector.selected_character = char
		-- end
	end
end

return display
