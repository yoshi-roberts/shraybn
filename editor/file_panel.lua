local pprint = require("libs.pprint")

FilePanel = {
	reload_needed = true,
	selected = 0,
	tree = {
		dirs = {},
		files = {},
	},
}

local filetypes = {
	["spd"] = "project",
	["scd"] = "scene",
	["png"] = "image",
	["jpg"] = "image",
	["jpeg"] = "image",
}

---@param path string
---@return string
local function path_to_key(path)
	local parts = {}
	-- Seperate the path by the backslashes.
	for str in string.gmatch(path, "([^/]+)") do
		table.insert(parts, str)
	end

	-- Remove the first two parts.
	table.remove(parts, 1)
	table.remove(parts, 1)

	-- Concat the parts park into a string seperated by "." instead of "/"
	return table.concat(parts, ".")
end

local function open_file(file)
	local ext = file:match("^.+%.([^.]+)$")

	if ext == "scd" then
		if not Editor.open_scenes[file] then
			Editor.open_scenes[file] = SceneData.load(file)
		end

		Editor.current_scene = Editor.open_scenes[file]
	elseif ext == "png" then
		local key = path_to_key(file)
		print(key)
		Inspector.viewer_image = Assets:get("image", key)
	end
end

function FilePanel:create_tree(path, branch)
	local items = Nativefs.getDirectoryItems(path)

	for _, name in pairs(items) do
		-- Skip hidden files.
		if name:sub(1, 1) == "." then
			goto continue
		end

		local item_path = path .. "/" .. name
		local info = Nativefs.getInfo(item_path)

		if info.type == "directory" then
			branch.dirs[name] = { dirs = {}, files = {} }
			self:create_tree(item_path, branch.dirs[name])
		elseif info.type == "file" then
			local ext = name:match("^.+%.([^.]+)$")
			local type = filetypes[ext]

			if type and not branch.files[name] then
				branch.files[name] = item_path
			end
		end

		::continue::
	end
end

function FilePanel:update()
	if not Editor.loaded_project or Assets.processing then
		return
	end

	if self.reload_needed == true then
		self.reload_needed = false
		Log.info("[EDITOR] Rebuilding file tree.")
		self:create_tree(Editor.loaded_project.name, self.tree)
	end
end

function FilePanel:display_tree(branch)
	for name, item in pairs(branch.dirs) do
		if Imgui.TreeNode_Str(string.format("%s %s", FONT_ICONS.ICON_FOLDER, name)) then
			self:display_tree(item)
			Imgui.TreePop()
		end
	end

	for name, item in pairs(branch.files) do
		Imgui.Selectable_Bool(FONT_ICONS.ICON_FILE .. " " .. name, self.selected == item)

		-- Double click item to open.
		if Imgui.IsItemHovered() and Imgui.IsMouseDoubleClicked_Nil(0) then
			self.selected = item
			open_file(self.selected)
		end
	end
end

function FilePanel:display()
	Imgui.Begin("Files", nil)
	self:display_tree(self.tree)
	Imgui.End()
end
