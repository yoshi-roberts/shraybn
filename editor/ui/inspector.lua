local imgui = require("engine.imgui")

---@param inspector editor.inspector
local function display(inspector)
	imgui.Begin("Inspector", nil)

	if inspector.item then
		if inspector.type == "image" then
			inspector.image(inspector.item)
		elseif inspector.type == "entity" then
			inspector.entity()
		elseif inspector.type == "layer" then
			inspector.layer()
		elseif inspector.type == "project" then
			inspector.project()
		end
	end

	imgui.End()
end

return display
