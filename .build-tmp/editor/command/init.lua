local nativefs = require("engine.nativefs")
local files = nativefs.getDirectoryItems("editor/command/commands")

local commands = {}

for _, file in pairs(files) do
	local name = file:match("(.+)%..+")
	if name ~= "init" then
		local class_name = name:gsub("_([a-z])", function(c)
			return c:upper()
		end)
		print(class_name)

		commands[class_name] = require("editor.command.commands." .. name)
	end
end

return commands
