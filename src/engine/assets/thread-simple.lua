require("love.image")
require("love.filesystem")

local log = require("libs.log")
local binser = require("libs.binser")
local nativefs = require("libs.nativefs")
local inspect = require("libs.inspect")

local root, lazy = ...

local assets = {}

-- Lookup table for file types.
---@type {[string]: table<string, boolean>}
local ext_types = {
	["image"] = { ["png"] = true, ["jpg"] = true, ["jpeg"] = true },
	["audio"] = { ["mp3"] = true, ["wav"] = true, ["ogg"] = true },
	["script"] = { ["shr"] = true },
	["shader"] = { ["glsl"] = true },
}

local processes = {
	["image"] = function(data)
		return love.data.newByteData(data)
	end,
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
local function resource_data_exists()
	if not nativefs.getInfo("resources.srd") then
		return false
	end

	return true
end

---@return table
local function resource_data_load()
	local serialized = nativefs.read("resources.srd")
	local resource_data = binser.deserialize(serialized)[1]

	return resource_data
end

---@param resource_data table
---@return boolean
local function resource_removed(resource_data)
	local removed = false

	for path, _ in pairs(resource_data) do
		if not assets[path] then
			log.info("[ASSETS] Removing '" .. path .. "' from resource data")
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

---@param archive table
---@return boolean
local function asset_added(archive)
	local added = false
	local file_count = archive:get_num_files()

	local existing = {}

	for i = 1, file_count, 1 do
		local name = archive:get_filename(i)
		existing[name] = true
	end

	for name, _ in pairs(assets) do
		if not existing[name] then
			added = true
		end
	end

	return added
end

---@param resource_data table
---@param path string
---@param type string
local function add_resource_data(resource_data, path, type)
	resource_data[path] = {}
	local data = resource_data[path]

	data.type = type

	if type == "image" then
		data.filter = "linear"
	end

	log.info("[ASSETS] Adding resource data for asset '" .. path .. "'")
end

local function add_asset(path, target, resource_data)
	local ext = path:match("^.+%.(.+)$")
	local valid, type = valid_type(ext)

	if not valid then
		return
	end

	local file_data = nativefs.read(path)
	local process = processes[type]
	local asset_data = process(file_data)

	target[path] = {
		type = type,
		data = asset_data,
	}

	log.info("[ASSETS] loading asset '" .. path .. "'")

	if not resource_data[path] then
		add_resource_data(resource_data, path, type)
	end
end

---@param path string
---@param target table
---@param resource_data table
local function index_items(path, target, resource_data)
	local items = nativefs.getDirectoryItems(path)

	for _, name in pairs(items) do
		if name:sub(1, 1) == "." then
			goto continue
		end

		local item_path = path .. "/" .. name
		local item_info = nativefs.getInfo(item_path)

		if item_info.type == "file" then
			add_asset(item_path, target, resource_data)
		elseif item_info.type == "directory" then
			index_items(item_path, target, resource_data)
		end

		::continue::
	end
end

local function create_pack()
	log.info("[ASSETS] Starting process.")
	log.info("[ASSETS] Indexing items.")

	local should_write = true
	local resource_data = {}

	if resource_data_exists() then
		should_write = false
		resource_data = resource_data_load()
	end

	index_items("assets", assets, resource_data)

	should_write = resource_removed(resource_data)

	if should_write then
		local serialized = binser.serialize(resource_data)
		if not nativefs.write("resources.srd", serialized, #serialized) then
			log.error("[ASSETS] Failed to write to resources.srd")
		else
			log.info("[ASSETS] Wrote to resources.srd")
		end
	end

	love.thread.getChannel("assets_data"):push(assets)
	love.thread.getChannel("assets_resource_data"):push(resource_data)
	love.thread.getChannel("assets_processing"):push(false)
	log.info("[ASSETS] Process completed.")
end

create_pack()
