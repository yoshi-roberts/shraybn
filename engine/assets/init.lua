local pprint = require("libs.pprint")
local binser = require("libs.binser")

Assets = {
	data = {
		["image"] = {},
		["audio"] = {},
		["script"] = {},
		["shader"] = {},
	},
}

-- Lookup table for file types.
local types = {
	["image"] = { ["png"] = true, ["jpg"] = true, ["jpeg"] = true },
	["audio"] = { ["mp3"] = true, ["wav"] = true, ["ogg"] = true },
	["script"] = { ["lua"] = true },
	["shader"] = { ["glsl"] = true },
}

local function valid_type(ext)
	for type, extensions in pairs(types) do
		if extensions[ext] then
			return type
		end
	end

	return false
end

function Assets:pack()
	local data = binser.serialize(self.data)
	local compressed = love.data.compress("data", "lz4", data, -1)

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

function Assets:unpack()
	-- Load .pak file.
end

function Assets:index(path)
	local base_dir = ""
	local root = ""

	-- Get the games root dir and mount it if needed.
	if love.filesystem.isFused() then
		base_dir = love.filesystem.getSourceBaseDirectory()
		local success = love.filesystem.mount(base_dir, "root")

		if not success then
			Log.error("Assets failed to mount directory.")
			return false
		end

		root = "root/"
	else
		base_dir = love.filesystem.getSource()
		root = ""
	end

	local full = root .. path

	local thread = love.thread.newThread("engine/assets/thread.lua")
	thread:start(full)

	-- build_tree(full)
end

return true
