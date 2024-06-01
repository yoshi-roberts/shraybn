-- Code the asset system runs in a seperate thread.
require("love.image")
local pprint = require("libs.pprint")
local binser = require("libs.binser")

local root = ...

local data = {
	["image"] = {},
	["audio"] = {},
	["script"] = {},
	["shader"] = {},
}

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

			if type then
				data[type][name:match("(.+)%..+$")] = {
					type = type,
					path = item_path,
					data = nil,
				}
			end
		end

		::continue::
	end
end

local function create_data()
	for type, items in pairs(data) do
		for k, item in pairs(items) do
			if type == "image" then
				local item_data = love.image.newImageData(item.path)
				print(item_data)
				item.data = item_data:getString()
			end
		end
	end
end

local function create_pak()
	local serialized = binser.serialize(data)
	-- A compression level of 9 means we are using LZ4-HC.
	local compressed = love.data.compress("data", "lz4", serialized, 9)

	-- Write file.
	local pak = io.open("assets.pak", "wb")
	if not pak then
		Log.error("Failed to open 'assets.pak'")
		return false
	end

	---@diagnostic disable-next-line: param-type-mismatch
	pak:write(compressed:getString())
	pak:close()
end

index_items(root)
create_data()
create_pak()

print("Assets finished!")
