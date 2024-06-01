-- Code the asset system runs in a seperate thread.
require("love.image")
require("love.filesystem")

local log = require("libs.log")
local pprint = require("libs.pprint")
local binser = require("libs.binser")

local action, root = ...

log.info("[ASSETS] Starting process.")

local data = {
	["image"] = {},
	["audio"] = {},
	["script"] = {},
	["shader"] = {},
}
local deserialized = nil

-- Lookup table for file types.
local types = {
	["image"] = { ["png"] = true, ["jpg"] = true, ["jpeg"] = true },
	["audio"] = { ["mp3"] = true, ["wav"] = true, ["ogg"] = true },
	["script"] = { ["lua"] = true },
	["shader"] = { ["glsl"] = true },
}

-- Check if a file extension is one we care about.
local function valid_type(ext)
	for type, extensions in pairs(types) do
		if extensions[ext] then
			return type
		end
	end

	return false
end

local function index_items(path)
	local items = love.filesystem.getDirectoryItems(path)

	for k, name in pairs(items) do
		-- Ignore hidden files.
		if name:sub(1, 1) == "." then
			goto continue
		end

		-- Get item info
		local item_path = path .. "/" .. name
		local info = love.filesystem.getInfo(item_path)

		if info.type == "directory" then
			index_items(item_path)
		elseif info.type == "file" then
			local ext = item_path:match("^.+%.(.+)$")
			local type = valid_type(ext)

			local asset_name = name:match("(.+)%..+$")
			-- Create entry if it does not already exist.
			if type and not data[type][asset_name] then
				data[type][asset_name] = {
					type = type,
					path = item_path,
					time = info.modtime,
				}
			end
		end

		::continue::
	end
end

local function create_item_data(item)
	if item.type == "image" then
		local item_data = love.image.newImageData(item.path)
		item.data = item_data:getString()
	end
end

local function create_all_data()
	for type, items in pairs(data) do
		for k, item in pairs(items) do
			-- Create data if it does not already exist.
			if not item.data then
				create_item_data(item)
			end
		end
	end
end

local pack_loaded = false
local function load_pack()
	log.info("[ASSETS] Loading asset pack.")
	-- Read file.
	local pack = io.open("assets.pak", "rb")
	if not pack then
		Log.error("Failed to open 'assets.pak'")
		return false
	end

	local str = pack:read("*a")
	local decompressed = love.data.decompress("data", "lz4", str)
	pack:close()

	local d, l = binser.deserialize(decompressed:getString())
	deserialized = d[1]

	pack_loaded = true
	love.thread.getChannel("pack_loaded"):push(pack_loaded)
end

local function asset_added_or_changed()
	local needed = false

	for type, items in pairs(data) do
		for name, item in pairs(items) do
			-- Check if asset has been added.
			if not deserialized[type][name] then
				log.info("[ASSETS] Adding new asset '" .. name .. "'")
				create_all_data()
				needed = true
			end

			-- Check if asset has been changed.
			if item.time ~= deserialized[type][name].time then
				log.info("[ASSETS] Reloading asset '" .. name .. "'")
				create_item_data(item)
				needed = true
			end
		end
	end

	return needed
end

-- Check if asset has been removed.
local function asset_removed()
	local needed = false

	for type, items in pairs(deserialized) do
		for name, item in pairs(items) do
			if not data[type][name] then
				log.info("[ASSETS] Removing asset '" .. name .. "'")
				needed = true
			end
		end
	end

	return needed
end

local function repack_needed()
	local needed = false

	if not love.filesystem.getInfo("assets.pak") then
		-- Need to pack assets.
		return true
	else -- Pack exists, but has anything changed?
		log.info("[ASSETS] Indexing items.")
		index_items(root)
		load_pack()

		needed = asset_added_or_changed()
		needed = asset_removed()
	end

	return needed
end

local pack_created = false
local function create_pack()
	local needed = repack_needed()
	if not needed then
		log.info("[ASSETS] No assets have changed.")
		return
	end

	local serialized = binser.serialize(data)
	-- A compression level of 9 means we are using LZ4-HC.
	local compressed = love.data.compress("data", "lz4", serialized, 9)

	-- Write file.
	local pak = io.open("assets.pak", "wb")
	if not pak then
		Log.error("[ASSETS] Failed to open pack.")
		return false
	end

	---@diagnostic disable-next-line: param-type-mismatch
	pak:write(compressed:getString())
	pak:close()

	deserialized = nil
	pack_created = true
	love.thread.getChannel("pack_created"):push(pack_created)
end

if action == "pack" then
	create_pack()
elseif action == "load" then
	load_pack()
end
log.info("[ASSETS] Process completed.")
