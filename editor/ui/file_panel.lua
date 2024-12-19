local font_icon = require "editor.font_icons"
local imgui = require "engine.imgui"
local editor = require "editor"

---@param file_panel editor.file_panel
---@param branch table
local function display_tree(file_panel, branch)
	for name, item in pairs(branch.dirs) do
		if imgui.TreeNode_Str(string.format("%s %s", font_icon.ICON_FOLDER, name)) then
			display_tree(file_panel, item)
			imgui.TreePop()
		end
	end

	for name, item in pairs(branch.files) do
		imgui.Selectable_Bool(font_icon.ICON_FILE .. " " .. name, file_panel.selected == item)

		-- Double click item to open.
		if imgui.IsItemHovered() and imgui.IsMouseDoubleClicked_Nil(0) then
			file_panel.selected = item
			file_panel.open_file(file_panel.selected)
		end

		if imgui.BeginDragDropSource(imgui.ImGuiDragDropFlags_None) then
			imgui.SetDragDropPayload("DRAG_DROP_FILE", item, #item)
			editor.drag_payload = item
			imgui.Text(name)
			imgui.EndDragDropSource()
		end
	end
end

---@param file_panel editor.file_panel
local function display(file_panel)
	imgui.Begin("Files", nil)
	display_tree(file_panel, file_panel.tree)
	imgui.End()
end

return display
