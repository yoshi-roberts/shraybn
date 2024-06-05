local pprint = require("libs.pprint")
local binser = require("libs.binser")

Assets = {

	data = nil,

	path = "",
	thread = nil,
	pack_exists = false,
}

function Assets:init(path)
	-- Get the games root dir and mount it if needed.
	if love.filesystem.isFused() then
		local base_dir = love.filesystem.getSourceBaseDirectory()
		local success = love.filesystem.mount(base_dir, "root")

		if not success then
			Log.error("Assets failed to mount directory.")
			return false
		end

		self.path = "root/"
	else
		self.path = ""
	end

	self.thread = love.thread.newThread("engine/assets/thread.lua")
end

function Assets:load(path)
	self.thread:start(self.path .. path)
end

function Assets:update()
	if not self.data then
		self.data = love.thread.getChannel("asset_data"):pop()
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
	-- pprint(asset)

	-- if asset.type == "image" and not asset.data:getData() then
	-- 	asset.data = love.graphics.newImage(asset.data)
	-- end
	--
	-- return asset.data
end

return true
