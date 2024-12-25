local nativefs = require("libs.nativefs")
local log = require("libs.log")
local assets = require("engine.assets")
local inspector = require("editor.inspector")
local editor = require("editor")

local Scene = require "engine.scene"
local SceneData = require "editor.scene_data"

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
	local ext = file:match("^.+%.([^.]+)$")

	if ext == "scd" then
		if not editor.scenes.open[file] then
			local scene = Scene.load(file)

			editor.scenes.open[file] = SceneData:new(scene, file)
		end

		editor.scenes.current = editor.scenes.open[file]
	elseif ext == "png" then
		inspector.inspect("image", assets.get("image", file))
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
			branch.dirs[name] = { dirs = {}, files = {} }
			file_panel.create_tree(item_path, branch.dirs[name])
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
