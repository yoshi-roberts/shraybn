local engine = require("engine")
local Scene = require("engine.scene")
local Layer = require("engine.layer")
local window = require("engine.window")

local theme = require("editor.ui.theme")

function engine.init()
	window.init(1280, 720)

	local default_scene = engine.add_scene(Scene:new("default_scene"))
	default_scene:add_layer(Layer:new(require("ui_layer")))

	engine.set_scene("default_scene")

	theme.apply()
end
