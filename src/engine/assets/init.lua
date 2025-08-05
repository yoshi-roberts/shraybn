-- TODO: zip compress the asset pack?
-- Will probably create a new branch for this.
local log = require("libs.log")
local nativefs = require("libs.nativefs")

---@class engine.assets
local assets = {
	data = {},

	resource_data = nil,

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
	["script"] = love.filesystem.read,
}

---@param path string
---@param lazy boolean
function assets.init(path, lazy)
	assets.path = path
	assets.lazy = lazy
	assets.thread = love.thread.newThread("engine/assets/thread-simple.lua")
end

function assets.load()
	assets.processing = true
	assets.thread:start(assets.path, assets.lazy)
end

function assets.update()
	if assets.processing then
		assets.processing = love.thread.getChannel("assets_processing"):pop()
	end

	if not assets.processing and not assets.resource_data then
		assets.data = love.thread.getChannel("assets_data"):pop()
		assets.resource_data = love.thread.getChannel("assets_resource_data"):pop()
	end
end

---@return boolean
function assets.loaded()
	if assets.resource_data then
		return true
	end

	return false
end

---@param name string
function assets.get(name)
	if not assets.loaded() then
		log.error("[ASSETS] Assets not loaded.")
		return false
	end

	local ext = name:match("^.+%.(.+)$")
	local asset_type = ext_types[ext]

	if not assets.data[name].resource then
		local fn = resource_functions[asset_type]
		assets.data[name].resource = fn(assets.data[name].data)
	end

	local asset = assets.data[name]
	return asset
end

return assets
