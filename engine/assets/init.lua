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
			print(item_path)
			branch[name] = {}
			create_tree(item_path, branch[name])
		elseif info.type == "file" then
			table.insert(branch, name)
		end

		::continue::
	end
end

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

	create_tree(self.path .. "/test-assets", self.file_tree)
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
