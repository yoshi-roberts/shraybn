-- Code the asset system runs in a seperate thread.
require("love.image")
require("love.filesystem")

local log = require("libs.log")
local pprint = require("libs.pprint")
local binser = require("libs.binser")

local root = ...

log.info("[ASSETS] Starting process.")

---@type {[string]: table}
---
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
---
local types = {
	["image"] = { ["png"] = true, ["jpg"] = true, ["jpeg"] = true },
	["audio"] = { ["mp3"] = true, ["wav"] = true, ["ogg"] = true },
	["script"] = { ["lua"] = true },
	["shader"] = { ["glsl"] = true },
}

---@type {[string]: function}
local processes = {
	---@param name string
	---@param data string
	---@return love.ImageData
	["image"] = function(name, data)
		local file_data = love.filesystem.newFileData(data, name)
		return love.image.newImageData(file_data)
	end,
}

---@param path string
---@return string?
---
local function file_read(path)
	local file = io.open(path, "rb")

	if not file then
		log.error("[ASSETS] Could not open file '" .. path .. "'")
		return nil
	end

	local str = file:read("*a")
	file:close()
	return str
end

---@param path string
---@param contents string
---@return boolean
---
local function file_write(path, contents)
	local file = io.open(path, "wb")

	if not file then
		log.error("[ASSETS] Could not open file '" .. path .. "'")
		return false
	end

	file:write(contents)
	file:close()
	return true
end

-- Check if a file extension is one we care about.
---@param ext string
---@return boolean
---@return string?
---
local function valid_type(ext)
	for type, extensions in pairs(types) do
		if extensions[ext] then
			return true, type
		end
	end

	return false, nil
end

---@param path string
---@param dest table
local function index_items(path, dest)
	local items = love.filesystem.getDirectoryItems(path)

	for _, name in pairs(items) do
		if name:sub(1, 1) == "." then
			goto continue
		end

		local item_path = path .. "/" .. name
		local item_info = love.filesystem.getInfo(item_path)

		if item_info.type == "file" then
			local ext = item_path:match("^.+%.(.+)$")
			local valid, type = valid_type(ext)

			if valid then
				dest[type][name] = {
					type = type,
					path = item_path,
				}
			end
		elseif item_info.type == "directory" then
			index_items(item_path, dest)
		end

		::continue::
	end
end

local function load_file_data()
	for _, items in pairs(assets) do
		for _, item in pairs(items) do
			if not item.data then
				item.data = file_read(item.path)
			end
		end
	end
end

local function load_pack()
	log.info("[ASSETS] Loading pack.")

	local compressed = file_read("assets.sap")
	local decompressed = love.data.decompress("string", "lz4", compressed --[[@as string]])
	local deserialized = binser.deserialize(decompressed)
	assets = deserialized[1]
end

local function process_data()
	log.info("[ASSETS] Processing data.")
	for type, items in pairs(assets) do
		for name, item in pairs(items) do
			local fn = processes[type]
			item.data = fn(name, item.data --[[@as string]])
		end
	end
end

local function pack_exists()
	local info = love.filesystem.getInfo("assets.sap")
	return info ~= nil
end

---@return boolean
local function asset_removed()
	local found = false

	for type, items in pairs(assets) do
		for name, _ in pairs(items) do
			if not temp_index[type][name] then
				log.info("[ASSETS] Removing asset '" .. name .. "'")
				assets[type][name] = nil
				found = true
			end
		end
	end

	return found
end

---@return boolean
local function asset_update()
	local update = false

	for type, items in pairs(temp_index) do
		for name, item in pairs(items) do
			if not assets[type][name] then
				log.info("[ASSETS] Adding new asset '" .. name .. "'")
				assets[type][name] = {
					type = item.type,
					path = item.path,
				}
				update = true
			end
		end
	end

	load_file_data()

	return update
end

local function create_pack()
	log.info("[ASSETS] Indexing items.")
	index_items("test-assets", assets)

	local write = false
	if not pack_exists() then
		load_file_data()
		write = true
	else
		load_pack()

		index_items("test-assets", temp_index)
		write = asset_removed() or asset_update()
		temp_index = nil
	end

	if write then
		log.info("[ASSETS] Writing pack.")
		local serialized = binser.serialize(assets)
		local compressed = love.data.compress("string", "lz4", serialized, 9)
		file_write("assets.sap", compressed --[[@as string]])
	end

	process_data()
end

create_pack()
love.thread.getChannel("asset_data"):push(assets)
log.info("[ASSETS] Process completed.")
