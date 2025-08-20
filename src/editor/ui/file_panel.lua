local font_icon = require "editor.font_icons"
local imgui = require "engine.imgui"
local editor = require "editor"
local signal = require("engine.signal")

local file_icons = {
	["image"] = font_icon.ICON_FILE_IMAGE_O,
	["audio"] = font_icon.ICON_MUSIC,
	["project"] = font_icon.ICON_FILE,
	["scene"] = font_icon.ICON_FILM .. " ",
	["character"] = font_icon.ICON_USER,
	["script"] = font_icon.ICON_FILE_TEXT_O,
}

---@param file_panel editor.file_panel
---@param branch table
local function display_tree(file_panel, branch)
	for _, item in pairs(branch.dirs) do
		if imgui.TreeNode_Str(string.format("%s %s", font_icon.ICON_FOLDER, item.name)) then
			display_tree(file_panel, item)
			imgui.TreePop()
		end
	end

	for _, item in pairs(branch.files) do
		local icon = file_icons[item.type]
		imgui.Selectable_Bool(icon .. " " .. item.name, file_panel.selected == item)

		-- Double click item to open.
		if imgui.IsItemHovered() and imgui.IsMouseDoubleClicked_Nil(0) then
			file_panel.selected = item
			file_panel.open_file(file_panel.selected)
		end

		if imgui.BeginDragDropSource(imgui.ImGuiDragDropFlags_None) then
			imgui.SetDragDropPayload("DRAG_DROP_FILE", nil, 0)
			signal.emit("editor_file_drag", item)
			imgui.Text(font_icon.ICON_FILE .. " " .. item.name)
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
