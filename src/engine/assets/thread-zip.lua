require("love.image")
require("love.filesystem")

local log = require("libs.log")
local miniz = require("miniz")
local nativefs = require("libs.nativefs")

local root, lazy = ...

log.info("[ASSETS] Starting process.")

local assets = {}

-- Lookup table for file types.
---@type {[string]: table<string, boolean>}
local ext_types = {
	["image"] = { ["png"] = true, ["jpg"] = true, ["jpeg"] = true },
	["audio"] = { ["mp3"] = true, ["wav"] = true, ["ogg"] = true },
	["script"] = { ["shr"] = true },
	["shader"] = { ["glsl"] = true },
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
	if not nativefs.getInfo("assets.sad") then
		return false
	end

	return true
end

---@return table
local function pack_load()
	local archive = miniz.zip_read_file("assets.sad")
	return archive
end

---@param archive table
---@return boolean
local function asset_removed(archive)
	local removed = false
	local file_count = archive:get_num_files()

	for i = 1, file_count, 1 do
		local name = archive:get_filename(i)

		if not assets[name] then
			log.info("[ASSETS] Removing '" .. name .. "' from pack")
			removed = true
		end
	end

	return removed
end

---@param archive table
---@return boolean
local function asset_modified(archive)
	local modified = false
	local file_count = archive:get_num_files()

	for i = 1, file_count, 1 do
		local name = archive:get_filename(i)
		local stat = archive:stat(i)
		local info = nativefs.getInfo(name)

		-- The modtimes will sometimes differ by a single digit,
		-- even when they should be the same.
		-- So we remove the last digit.
		local modtime = math.floor(info.modtime / 10)
		local time = math.floor(stat.time / 10)

		if modtime > time then
			modified = true
			log.info("[ASSETS] Asset '" .. name .. "' has been modified")
		end
	end

	return modified
end

---@param path string
local function index_items(path)
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
				assets[item_path] = true
			end
		elseif item_info.type == "directory" then
			index_items(item_path)
		end

		::continue::
	end
end

local function create_pack()
	log.info("[ASSETS] Indexing items.")

	local archive = nil
	local success, err

	index_items("assets")

	local should_write = true

	if pack_exists() then
		should_write = false
		archive = pack_load()
		should_write = asset_removed(archive)
		should_write = asset_modified(archive)
	end

	if should_write then
		archive = miniz.zip_write_file("assets.sad")

		for asset, _ in pairs(assets) do
			archive:add_file(asset)
		end

		success, err = archive:finalize()
	end

	success, err = archive:close()

	if not success then
		log.error("[ASSETS] " .. err)
	end

	love.thread.getChannel("assets_processing"):push(false)
	log.info("[ASSETS] Process completed.")
end

create_pack()
