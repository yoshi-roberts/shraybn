local lover_context = os.getenv("LOVER_CONTEXT")
local build_target = os.getenv("BUILD_TARGET")
local path = ""

local target = ""
if lover_context == "run" then
	target = arg[2]
elseif lover_context == "build" then
	target = arg[1]
end

if target == "runtime" then
	path = path .. "runtime"
elseif target == "editor" then
	path = path .. "editor"
end

require(path)
