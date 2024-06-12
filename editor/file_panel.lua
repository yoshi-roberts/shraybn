FilePanel = {
	selected = 0,
	tree = {
		dirs = {},
		files = {},
	},
}

local filetypes = {
	["sep"] = "project",
	["scd"] = "scene",
}

local function open_file(file)
	local ext = file:match("^.+%.([^.]+)$")

	Nativefs.setWorkingDirectory(Editor.loaded_project.name)

	if ext == "scd" then
		if not Editor.open_scenes[file] then
			Editor.open_scenes[file] = SceneData.load("scenes/" .. file)
		end

		Editor.current_scene = Editor.open_scenes[file]
		print(Editor.current_scene)
	end

	Nativefs.setWorkingDirectory("..")
end

function FilePanel:create_tree(path, branch)
	local items = Nativefs.getDirectoryItems(path)

	for _, item in pairs(items) do
		local item_path = path .. "/" .. item
		local info = Nativefs.getInfo(item_path)

		if info.type == "directory" then
			branch.dirs[item] = { dirs = {}, files = {} }
			self:create_tree(item_path, branch.dirs[item])
		elseif info.type == "file" then
			if not branch.files[item] then
				local ext = item:match("^.+%.([^.]+)$")
				branch.files[item] = filetypes[ext]
			end
		end
	end
end

function FilePanel:display_tree(branch)
	for name, item in pairs(branch.dirs) do
		if Imgui.TreeNode_Str(name) then
			self:display_tree(item)
			Imgui.TreePop()
		end
	end

	for name, item in pairs(branch.files) do
		Imgui.Selectable_Bool(name, self.selected == name)

		-- Double click item to open.
		if Imgui.IsItemHovered() and Imgui.IsMouseDoubleClicked(0) then
			self.selected = name
			open_file(self.selected)
		end
	end
end

function FilePanel:display()
	Imgui.Begin("Files", nil)
	self:display_tree(self.tree)
	Imgui.End()
end
