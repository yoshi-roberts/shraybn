SceneData = {}

function SceneData.new(name)
	Nativefs.setWorkingDirectory("projects/" .. Editor.loaded_project.name)
	local exists = Nativefs.getInfo("scenes/" .. name .. ".scd")

	if exists ~= nil then
		return false
	end

	local scene = {
		name = name,
		layers = {},
	}

	local serialized = Binser.serialize(scene)
	Nativefs.write("scenes/" .. name .. ".scd", serialized, #serialized)

	return true, scene
end

return SceneData
