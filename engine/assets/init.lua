local pprint = require("libs.pprint")
local binser = require("libs.binser")

Assets = {

	file_tree = {},
	data = nil,

	path = "",
	thread = nil,
	pack_exists = false,
}

local function create_tree(path, branch)
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
			branch[name] = {}
			create_tree(item_path, branch[name])
		elseif info.type == "file" then
			table.insert(branch, name)
		end

		::continue::
	end
end

function Assets:init(path)
	self.path = path
	create_tree(path, self.file_tree)
	self.thread = love.thread.newThread("engine/assets/thread.lua")
end

function Assets:load()
	self.thread:start(self.path)
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

	if not asset.resource then
		if asset.type == "image" then
			asset.resource = love.graphics.newImage(asset.data)
		end
		asset.data = nil
	end

	return asset.resource
end

return true
