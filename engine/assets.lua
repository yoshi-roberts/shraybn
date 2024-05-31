Assets = {}

local types = {
	["image"] = { ".png", ".jpg", ".jpeg" },
}

function Assets:index()
	local root = ""

	-- Get the games root dir and mount it if needed.
	if love.filesystem.isFused() then
		root = love.filesystem.getSourceBaseDirectory()
		local success = love.filesystem.mount(root, "root")
	else
		root = love.filesystem.getSource()
	end
	print(root)
end

return true
