-- TODO: zip compress the asset pack?
-- Will probably create a new branch for this.
local log = require("libs.log")
local nativefs = require("libs.nativefs")

---@alias engine.asset {type: string, data: love.ByteData, resource: any}

---@class engine.assets
local assets = {
	data = {}, ---@type engine.asset[]

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
local data_functions = {
	["image"] = love.graphics.newImage,
	["script"] = function(data)
		return data
	end,
}

---@type {[string]: function}
local resource_functions = {
	---@param data love.Image
	["image"] = function(data, resource)
		data:setFilter(resource.filter)
	end,
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
function assets.get_resource_data(name)
	if not assets.loaded() then
		log.error("[ASSETS] Assets not loaded")
		return false
	end

	local data = assets.resource_data[name]

	if not data then
		log.error("[ASSETS] Resource data for '" .. name .. "' does not exist")
		return false
	end

	return data
end

---@param name string
function assets.import(name)
	if not assets.loaded() then
		log.error("[ASSETS] Assets not loaded")
		return false
	end

	local asset = assets.data[name]

	if not asset then
		log.error("[ASSETS] No asset '" .. name .. "'")
		return false
	end

	local res_data = assets.get_resource_data(name)
	local resource_function = resource_functions[asset.type]

	if not resource_function then
		return false
	end

	resource_function(asset.resource, res_data)
end

---@param name string
---@return engine.asset
function assets.get(name)
	if not assets.loaded() then
		log.error("[ASSETS] Assets not loaded")
		return false
	end

	local asset = assets.data[name]

	if not asset then
		log.error("[ASSETS] No asset '" .. name .. "'")
		return false
	end

	if not assets.data[name].resource then
		-- local ext = name:match("^.+%.(.+)$")
		-- local asset_type = ext_types[ext]

		local data_function = data_functions[asset.type]
		asset.resource = data_function(asset.data)
		assets.import(name)
	end

	return asset
end

return assets
