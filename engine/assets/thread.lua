-- Code the asset system runs in a seperate thread.
require("love.image")
require("love.filesystem")

local log = require("libs.log")
local binser = require("libs.binser")
local nativefs = require("libs.nativefs")

local root, lazy = ...

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
---
local ext_types = {
	["image"] = { ["png"] = true, ["jpg"] = true, ["jpeg"] = true },
	["audio"] = { ["mp3"] = true, ["wav"] = true, ["ogg"] = true },
	["script"] = { ["lua"] = true },
	["shader"] = { ["glsl"] = true },
}

local asset_types = {
	["image"] = 1,
	["audio"] = 2,
	["script"] = 3,
	["shader"] = 4,
}

---@type {[string]: function}
local processes = {
	---@param data string
	---@return love.ImageData
	["image"] = function(data)
		-- local byte_data = love.data.newByteData(data)
		-- return love.image.newImageData(byte_data)
		return love.image.newImageData(data)
	end,
}

---@param path string
---@return string?
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
local function valid_type(ext)
	for type, extensions in pairs(ext_types) do
		if extensions[ext] then
			return true, type
		end
	end

	return false, nil
end

---@param path string
---@param dest table
local function index_items(path, dest)
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
				dest[type][item_path] = {
					type = type,
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
		for path, item in pairs(items) do
			if not item.data then
				item.data = file_read(path)
			end
		end
	end
end

local function load_pack()
	log.info("[ASSETS] Loading pack.")

	local serialized = file_read(root .. "/assets.sad")
	local deserialized = binser.deserialize(serialized)
	assets = deserialized[1]
end

local function process_data()
	log.info("[ASSETS] Processing data.")

	for type, items in pairs(assets) do
		for _, item in pairs(items) do
			local byte_data = love.data.newByteData(item.data)

			if lazy then
				item.data = byte_data
			else
				local fn = processes[type]
				item.data = fn(byte_data --[[@as string]])
			end
		end
	end
end

local function pack_exists()
	local info = nativefs.getInfo(root .. "/assets.sad")
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
	index_items(root .. "/assets", assets)

	local write = false
	if not pack_exists() then
		log.info("[ASSETS] No pack exists.")
		load_file_data()
		write = true
	else
		log.info("[ASSETS] Pack exists.")
		load_pack()

		index_items(root .. "/assets", temp_index)
		write = asset_removed() or asset_update()
		temp_index = nil
	end

	if write then
		log.info("[ASSETS] Writing pack.")
		local serialized = binser.serialize(assets)
		-- local compressed = love.data.compress("string", "lz4", serialized, 9)
		file_write(root .. "/assets.sad", serialized --[[@as string]])
	end

	process_data()
end

create_pack()

love.thread.getChannel("asset_data"):push(assets)
love.thread.getChannel("assets_processing"):push(false)
log.info("[ASSETS] Process completed.")
