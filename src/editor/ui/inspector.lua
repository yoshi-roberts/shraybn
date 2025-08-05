local imgui = require("engine.imgui")
local widgets = require("editor.widgets")

---@param inspector editor.inspector
local function display(inspector)
	imgui.Begin("Inspector", nil)

	if inspector.item then
		if inspector.type == "image" then
			widgets.image(inspector.item)
		elseif inspector.type == "entity" then
			inspector.entity()
		elseif inspector.type == "layer" then
			inspector.layer()
		elseif inspector.type == "characters" then
			inspector.characters()
		elseif inspector.type == "project" then
			inspector.project()
		end
	end

	imgui.End()
end

return display
