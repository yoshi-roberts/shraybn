local function display_tree(self, branch)
	for name, item in pairs(branch.dirs) do
		if Imgui.TreeNode_Str(string.format("%s %s", FONT_ICONS.ICON_FOLDER, name)) then
			display_tree(self, item)
			Imgui.TreePop()
		end
	end

	for name, item in pairs(branch.files) do
		Imgui.Selectable_Bool(FONT_ICONS.ICON_FILE .. " " .. name, self.selected == item)

		-- Double click item to open.
		if Imgui.IsItemHovered() and Imgui.IsMouseDoubleClicked_Nil(0) then
			self.selected = item
			self:open_file(self.selected)
		end

		if Imgui.BeginDragDropSource(Imgui.ImGuiDragDropFlags_None) then
			Imgui.SetDragDropPayload("DRAG_DROP_FILE", item, #item)
			Editor.drag_payload = item
			Imgui.Text(name)
			Imgui.EndDragDropSource()
		end
	end
end

local function display(self)
	Imgui.Begin("Files", nil)
	display_tree(self, self.tree)
	Imgui.End()
end

return display
