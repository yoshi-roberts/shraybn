require("love.image")
require("love.sound")
require("love.filesystem")

local log = require("libs.log")
local binser = require("libs.binser")
local nativefs = require("libs.nativefs")
local inspect = require("libs.inspect")

local root, lazy = ...

local assets = {}
local should_write = true

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
		-- return love.data.newByteData(data)
		return data
	end,
	["audio"] = function(data)
		-- local file_data = nativefs.newFileData(data)
		-- print(file_data)
		return data
	end,
	["script"] = function(data)
		return data
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

---@param path string
---@return boolean
local function resource_data_exists(path)
	if not nativefs.getInfo(path .. ".srd") then
		return false
	end

	return true
end

---@param resources table
---@param path string
local function resource_data_load(resources, path)
	local serialized = nativefs.read(path .. ".srd")
	local res_data = binser.deserialize(serialized)[1]

	resources[path] = res_data

	log.info(" [ASSETS] Loaded resource data for '" .. path .. "'")
end

---@param resources table
local function asset_removed(resources)
	log.info("[ASSETS] Checking for removed assets")

	for path, _ in pairs(resources) do
		if not assets[path] then
			log.info(" !!! [ASSETS] Removing '" .. path .. "' from resource data")
			resources[path] = nil
			nativefs.remove(path .. ".srd")
		end
	end
end

---@param resources table
---@param path string
---@param type string
local function add_resource_data(resources, path, type)
	resources[path] = {}
	local data = resources[path]

	data.type = type
	data.path = path

	if type == "image" then
		data.filter = "linear"
	end

	log.info("[ASSETS] Adding resource data for asset '" .. path .. "'")

	local serialized = binser.serialize(data)
	if not nativefs.write(path .. ".srd", serialized, #serialized) then
		log.error("[ASSETS] Failed to write to '" .. path .. ".srd'")
	else
		log.info("[ASSETS] Wrote to '" .. path .. ".srd'")
	end
end

local function add_asset(path, target, resources)
	local ext = path:match("^.+%.(.+)$")
	local valid, type = valid_type(ext)

	if not valid then
		return
	end

	-- local file_data = nativefs.read(path)
	local file_data = nativefs.newFileData(path)
	local process = processes[type]
	local asset_data = process(file_data)

	target[path] = {
		type = type,
		data = asset_data,
		path = path,
	}

	log.info("[ASSETS] Loading asset '" .. path .. "'")

	if not resource_data_exists(path) then
		add_resource_data(resources, path, type)
	else
		resource_data_load(resources, path)
	end
end

---@param path string
---@param target table
---@param resources table
local function index_items(path, target, resources)
	local items = nativefs.getDirectoryItems(path)

	for _, name in pairs(items) do
		if name:sub(1, 1) == "." then
			goto continue
		end

		local item_path = path .. "/" .. name
		local item_info = nativefs.getInfo(item_path)

		if item_info.type == "file" then
			add_asset(item_path, target, resources)
		elseif item_info.type == "directory" then
			index_items(item_path, target, resources)
		end

		::continue::
	end
end

local function create_pack()
	log.info("[ASSETS] Starting process.")
	log.info("[ASSETS] Indexing items.")

	local should_write = true
	local resources = {}

	index_items("assets", assets, resources)

	asset_removed(resources)

	love.thread.getChannel("assets_data"):push(assets)
	love.thread.getChannel("assets_resource_data"):push(resources)
	love.thread.getChannel("assets_processing"):push(false)
	log.info("[ASSETS] Process completed.")
end

create_pack()
