local target = ""

if arg[1] == "runtime" then
	target = target .. "runtime"
elseif arg[1] == "editor" then
	target = target .. "editor"
else
	print("Options are 'runtime' or 'editor'")
end

local cmd = "love src/ " .. target
if arg[2] then
	cmd = cmd .. " " .. arg[2]
end

print(cmd)

os.execute(cmd)
require(target)
