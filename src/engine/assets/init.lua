-- TODO: zip compress the asset pack?
-- Will probably create a new branch for this.
local log = require("libs.log")
local nativefs = require("libs.nativefs")

---@class engine.assets
local assets = {
	data = {
		["image"] = {},
		["audio"] = {},
		["script"] = {},
	},

	processing = true,
	mounted = false,

	path = "",
	thread = nil, ---@type love.Thread
	archive = nil,
	pack_exists = false,
}

-- Lookup table for file types.
---@type {[string]: string}
local ext_types = {
	["png"] = "image",
	["jpg"] = "image",
	["jpeg"] = "image",
	["mp3"] = "audio",
	["wav"] = "audio",
	["ogg"] = "audio",
	["shr"] = "script",
}

---@type {[string]: function}
local resource_functions = {
	["image"] = love.graphics.newImage,
}

---@param path string
---@param lazy boolean
function assets.init(path, lazy)
	assets.path = path
	assets.lazy = lazy
	assets.thread = love.thread.newThread("engine/assets/thread-zip.lua")
end

function assets.load()
	assets.processing = true
	assets.thread:start(assets.path, assets.lazy)
end

function assets.update()
	if assets.processing then
		assets.processing = love.thread.getChannel("assets_processing"):pop()
		return
	end

	if not assets.mounted then
		local success = nativefs.mount("assets.sad", "assets")

		if success then
			assets.mounted = success
			log.info("[ASSETS] Mounted pack")
		end
	end
end

---@return boolean
function assets.loaded()
	return assets.mounted
end

---@param name string
function assets.get(name)
	if not assets.loaded() then
		log.error("[ASSETS] No asset pack loaded.")
		return false
	end

	local ext = name:match("^.+%.(.+)$")
	local asset_type = ext_types[ext]

	if not assets.data[asset_type][name] then
		local fn = resource_functions[asset_type]
		assets.data[asset_type][name] = {
			resource = fn("assets/" .. name),
		}
	end

	local asset = assets.data[asset_type][name]
	return asset
end

return assets
