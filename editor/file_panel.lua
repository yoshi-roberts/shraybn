local inspector = require("editor.inspector")
local nativefs = require("libs.nativefs")
local assets = require("engine.assets")
local editor = require("editor")
local log = require("libs.log")

local Scene = require("engine.scene")
local SceneData = require("editor.scene_data")

---@class editor.file_panel
local file_panel = {
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

function file_panel.open_file(file)
	if file.type == "scene" then
		if not editor.scenes.open[file.path] then
			local scene = Scene.load(file.path)
			editor.scenes.open[file.path] = SceneData:new(scene, file.path)
		end

		editor.scenes.current = editor.scenes.open[file.path]
	elseif file.type == "image" then
		inspector.inspect("image", assets.get(file.path))
	end
end

function file_panel.create_tree(path, branch)
	local items = nativefs.getDirectoryItems(path)

	for _, name in pairs(items) do
		-- Skip hidden files.
		if name:sub(1, 1) == "." then
			goto continue
		end

		local item_path = path .. "/" .. name
		local info = nativefs.getInfo(item_path)

		if info.type == "directory" then
			table.insert(branch.dirs, { name = name, dirs = {}, files = {} })
			file_panel.create_tree(item_path, table.back(branch.dirs))
		elseif info.type == "file" then
			-- Get the file extension and type.
			local ext = name:match("^.+%.([^.]+)$")
			local file_type = filetypes[ext]

			if file_type then
				local data = { name = name, path = item_path, type = file_type }
				table.insert(branch.files, data)
			end
		end

		::continue::
	end
end

function file_panel.update()
	if not editor.loaded_project or assets.processing then
		return
	end

	if file_panel.reload_needed == true then
		file_panel.reload_needed = false
		log.info("[EDITOR] Rebuilding file tree.")
		file_panel.create_tree(editor.loaded_project.name, file_panel.tree)
	end
end

return file_panel
