local engine = require("engine")
local Scene = require("engine.scene")
local Layer = require("engine.layer")
local Project = require("engine.project")
local window = require("engine.window")
local assets = require("engine.assets")

function engine.init(args)
	window.init(1280, 720)

	-- Load the specified project.
	if args[1] then
		local proj = Project.load(args[1])

		assets.init(args[1], true)
		assets.load()

		local scn = Scene.load("projects/" .. proj.main_scene)
		local main_scene = engine.add_scene(scn)
	end

	engine.set_scene("test")
end
