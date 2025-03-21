-- TODO: zip compress the asset pack?
-- Will probably create a new branch for this.
local log = require("libs.log")

---@class engine.assets
local assets = {
	data = nil,
	processing = false,

	path = "",
	thread = nil, ---@type love.Thread
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
	assets.thread = love.thread.newThread("engine/assets/thread.lua")
end

function assets.load()
	assets.processing = true
	print(assets.path)
	assets.thread:start(assets.path, assets.lazy)
end

function assets.update()
	if not assets.data then
		assets.data = love.thread.getChannel("asset_data"):pop()
	end
	if assets.data and assets.processing then
		assets.processing = love.thread.getChannel("assets_processing"):pop()
	end
end

---@return boolean
function assets.loaded()
	return assets.data ~= nil
end

---@param name string
function assets.get(name)
	if not assets:loaded() then
		log.error("[ASSETS] No asset pack loaded. Can not load asset '" .. name .. "'")
		return false
	end

	local ext = name:match("^.+%.(.+)$")
	local asset_type = ext_types[ext]

	if not assets.data[asset_type][name] then
		log.error("[ASSETS] Asset '" .. name .. "' does not exist.")
		return nil
	end

	local asset = assets.data[asset_type][name]

	if not asset.resource then
		local fn = resource_functions[asset_type]
		asset.resource = fn(asset.data)
		asset.data = nil
	end

	return asset
end

return assets
