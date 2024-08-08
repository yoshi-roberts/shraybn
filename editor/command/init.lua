local files = Nativefs.getDirectoryItems("editor/command/commands")

require("editor.command.command")
require("editor.command.command_history")

for _, file in pairs(files) do
	local name = file:match("(.+)%..+")
	if name ~= "init" then
		require("editor.command.commands." .. name)
	end
end
