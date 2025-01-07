local engine = require("engine")
local Project = require("engine.project")
local window = require("engine.window")

function engine.init(args)
	window.init(1280, 720)

	-- Load the specified project.
	if args[1] then
		engine.set_project(Project.load(args[1]))
	end
end
