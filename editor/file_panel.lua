FilePanel = {
	selected = 0,
	tree = {
		dirs = {},
		files = {},
	},
}

function FilePanel:create_tree(path, branch)
	local items = Nativefs.getDirectoryItems(path)

	for _, item in pairs(items) do
		local item_path = path .. "/" .. item
		local info = Nativefs.getInfo(item_path)

		if info.type == "directory" then
			branch.dirs[item] = { dirs = {}, files = {} }
			self:create_tree(item_path, branch.dirs[item])
		elseif info.type == "file" then
			table.insert(branch.files, item)
		end
	end
end

function FilePanel:display_tree(branch)
	for k, item in pairs(branch.dirs) do
		if Imgui.TreeNode_Str(k) then
			self:display_tree(item)
			Imgui.TreePop()
		end
	end

	for k, item in pairs(branch.files) do
		if Imgui.Selectable_Bool(item, self.selected == k) then
			self.selected = k
		end
	end
end

function FilePanel:display()
	Imgui.Begin("Files", nil)
	self:display_tree(self.tree)
	Imgui.End()
end
