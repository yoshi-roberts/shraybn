FilePanel = {
	reload_needed = true,
	selected = 0,
	tree = {
		dirs = {},
		files = {},
	},

	display = require("editor.ui.file_panel"),
}

local filetypes = {
	["spd"] = "project",
	["scd"] = "scene",
	["png"] = "image",
	["jpg"] = "image",
	["jpeg"] = "image",
}

---@alias SceneData {data: Scene, saved: boolean}

function FilePanel:open_file(file)
	local ext = file:match("^.+%.([^.]+)$")

	if ext == "scd" then
		if not Editor.scenes.open[file] then
			local scene = Scene.load(file)

			Editor.scenes.open[file] = {
				data = scene,
				saved = true,
			}
		end

		Editor.scenes.current = Editor.scenes.open[file]
	elseif ext == "png" then
		local key = Util.path_to_key(file)
		print(key)
		Inspector:inspect("image", Assets:get("image", key))
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
