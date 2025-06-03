require("love.image")
require("love.filesystem")

local log = require("libs.log")
local miniz = require("miniz")
local binser = require("libs.binser")
local nativefs = require("libs.nativefs")

local root, lazy = ...
print(root)

log.info("[ASSETS] Starting process.")

---@type {[string]: table}
local assets = {
	["image"] = {},
	["audio"] = {},
	["script"] = {},
	["shader"] = {},
}

local temp_index = {
	["image"] = {},
	["audio"] = {},
	["script"] = {},
	["shader"] = {},
}

-- Lookup table for file types.
---@type {[string]: table<string, boolean>}
local ext_types = {
	["image"] = { ["png"] = true, ["jpg"] = true, ["jpeg"] = true },
	["audio"] = { ["mp3"] = true, ["wav"] = true, ["ogg"] = true },
	["script"] = { ["shr"] = true },
	["shader"] = { ["glsl"] = true },
}

local asset_types = {
	["image"] = 1,
	["audio"] = 2,
	["script"] = 3,
	["shader"] = 4,
}

-- Check if a file extension is one we care about.
---@param ext string
---@return boolean
---@return string?
local function valid_type(ext)
	for type, extensions in pairs(ext_types) do
		if extensions[ext] then
			return true, type
		end
	end

	return false, nil
end

---@return boolean
local function pack_exists()
	if not nativefs.getInfo(root .. "/assets.sad") then
		return false
	end

	return true
end

---@param path string
---@param archive table
local function index_items(path, archive)
	local items = nativefs.getDirectoryItems(path)

	for _, name in pairs(items) do
		if name:sub(1, 1) == "." then
			goto continue
		end

		local item_path = path .. "/" .. name
		local item_info = nativefs.getInfo(item_path)

		if item_info.type == "file" then
			local ext = item_path:match("^.+%.(.+)$")
			local valid, type = valid_type(ext)

			if valid then
				-- local item_key = path:match(".*/([^/]+)/*$") .. "/" .. name
				-- local file_data = nativefs.read(item_path)

				archive:add_file(item_path)
			end
		elseif item_info.type == "directory" then
			index_items(item_path, archive)
		end

		::continue::
	end
end

local function create_pack()
	log.info("[ASSETS] Indexing items.")

	local orig_work_dir = nativefs.getWorkingDirectory()
	local proj_dir = orig_work_dir .. "/" .. root

	local archive = miniz.zip_write_file(root .. "/assets.sad")
	nativefs.setWorkingDirectory(proj_dir .. "/assets")

	print(nativefs.getWorkingDirectory())

	local items = nativefs.getDirectoryItems(nativefs.getWorkingDirectory())
	for _, name in pairs(items) do
		local item_info = nativefs.getInfo(name)
		if item_info.type == "directory" then
			index_items(name, archive)
		end
	end

	local success, err
	success, err = archive:finalize()
	success, err = archive:close()

	if not success then
		log.error("[ASSETS] " .. err)
	end

	nativefs.setWorkingDirectory(orig_work_dir)
end

create_pack()

love.thread.getChannel("asset_data"):push(assets)
love.thread.getChannel("assets_processing"):push(false)
log.info("[ASSETS] Process completed.")
