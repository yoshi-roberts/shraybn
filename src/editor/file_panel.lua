local inspector = require("editor.inspector")
local nativefs = require("libs.nativefs")
local assets = require("engine.assets")
local signal = require("engine.signal")
local editor = require("editor")
local log = require("libs.log")

local Scene = require("engine.scene")
local SceneData = require("editor.scene_data")
local Character = require("engine.character")
local CharacterData = require("editor.character_data")

---@class editor.file_panel
local file_panel = {
	reload_needed = false,
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
	["chd"] = "character",
	["shr"] = "script",
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
	elseif file.type == "character" then
		if not editor.characters.open[file.path] then
			local character = Character.load(file.path)
			editor.characters.open[file.path] = CharacterData:new(character, file.path)
		end

		editor.characters.current = editor.characters.open[file.path]
	elseif file.type == "image" then
		inspector.inspect("image", assets.get(file.path))
	elseif file.type == "project" then
		inspector.inspect("project", editor.loaded_project)
	end
end

---@param path string
---@param branch table
function file_panel.create_tree(path, branch)
	local items = nativefs.getDirectoryItems(path)

	for _, name in pairs(items) do
		local full_path = path .. "/" .. name
		local info = nativefs.getInfo(full_path)

		if info.type == "directory" then
			table.insert(branch.dirs, { name = name, dirs = {}, files = {} })
			file_panel.create_tree(full_path, branch.dirs[#branch.dirs])
		elseif info.type == "file" then
			local ext = name:match("^.+%.([^%.]+)$")
			local type = filetypes[ext]

			if type then
				table.insert(branch.files, {
					name = name,
					type = type,
					path = full_path:sub(3, #full_path),
				})
			end
		end
	end
end

signal.register("file_panel_reload", function()
	file_panel.reload_needed = true
end)

function file_panel.update()
	if not editor.loaded_project or not assets.loaded() then
		return
	end

	if file_panel.reload_needed then
		log.info("[EDITOR] Rebuilding file tree.")

		file_panel.tree = {
			dirs = {},
			files = {},
		}

		file_panel.create_tree(".", file_panel.tree)
		file_panel.reload_needed = false
	end
end

return file_panel
