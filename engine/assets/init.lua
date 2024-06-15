local pprint = require("libs.pprint")
local binser = require("libs.binser")

Assets = {

	data = nil,
	processing = false,

	path = "",
	thread = nil,
	pack_exists = false,
}

function Assets:init(path)
	self.path = path
	self.thread = love.thread.newThread("engine/assets/thread.lua")
end

function Assets:load()
	self.processing = true
	self.thread:start(self.path)
end

function Assets:update()
	if not self.data then
		self.data = love.thread.getChannel("asset_data"):pop()
	end
	if self.data and self.processing then
		self.processing = love.thread.getChannel("assets_processing"):pop()
	end
end

function Assets:loaded()
	return self.data ~= nil
end

function Assets:get(type, name)
	if not self:loaded() then
		Log.error("[ASSETS] No asset pack loaded. Can not load asset '" .. name .. "'")
		return false
	end

	if not self.data[type][name] then
		Log.error("[ASSETS] Asset '" .. name .. "' does not exist.")
		return false
	end

	local asset = self.data[type][name]

	if not asset.resource then
		if asset.type == "image" then
			asset.resource = love.graphics.newImage(asset.data)
		end
		asset.data = nil
	end

	return asset.resource
end

return true
