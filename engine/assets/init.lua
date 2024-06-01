local pprint = require("libs.pprint")
local binser = require("libs.binser")

Assets = {
	data = {
		["image"] = {},
		["audio"] = {},
		["script"] = {},
		["shader"] = {},
	},

	path = "",
	thread = nil,
	pack_created = false,
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

function Assets:pack(path)
	self.thread:start("pack", self.path .. path)
end

function Assets:is_pack_created()
	local created = nil
	created = love.thread.getChannel("pack_created"):pop()
	self.pack_created = created or self.pack_created
	print(self.pack_created)
end

return true
