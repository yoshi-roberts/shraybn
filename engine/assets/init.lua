local log = require("libs.log")

---@class engine.assets
local assets = {
	data = nil,
	processing = false,

	path = "",
	thread = nil, ---@type love.Thread
	pack_exists = false,
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

---@param type string
---| "image"
---| "sound"
---@param name string
function assets.get(type, name)
	if not assets:loaded() then
		log.error("[ASSETS] No asset pack loaded. Can not load asset '" .. name .. "'")
		return false
	end

	if not assets.data[type][name] then
		log.error("[ASSETS] Asset '" .. name .. "' does not exist.")
		return nil
	end

	local asset = assets.data[type][name]

	if not asset.resource then
		if asset.type == "image" then
			asset.resource = love.graphics.newImage(asset.data)
		end
		asset.data = nil
	end

	return asset
end

return assets
