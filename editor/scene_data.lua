---@class SceneData
SceneData = {}

local pprint = require("libs.pprint")

---@alias scene_data {unsaved: boolean, name: string, layers: table, world: table}

---@param name string
---@return boolean
---@return scene_data?
---
function SceneData.new(name)
	Nativefs.setWorkingDirectory(Editor.loaded_project.name)
	local exists = Nativefs.getInfo("scenes/" .. name .. ".scd")

	-- Check if scene already exists.
	if exists ~= nil then
		return false, nil
	end

	---@type scene_data
	local scene = {
		unsaved = false,
		name = name,
		layers = {},
		world = World(),
	}

	-- Serialize scene data and write to file.
	local serialized = Binser.serialize(scene)
	Nativefs.write("scenes/" .. name .. ".scd", serialized, #serialized)

	-- Set working directory back to projects/
	Nativefs.setWorkingDirectory("..")

	return true, scene
end

---@param file string
---@return scene_data
function SceneData.load(file)
	local contents = Nativefs.read(file)
	local deserialized = Binser.deserialize(contents)

	-- Deserialize the ECS world.
	local world = World()
	world:deserialize(deserialized[1].world)
	deserialized[1].world = world

	return deserialized[1]
end

---@param scene scene_data
function SceneData.save(scene)
	Nativefs.setWorkingDirectory(Editor.loaded_project.name)
	scene.unsaved = false

	local data = {
		unsaved = scene.unsaved,
		name = scene.name,
		layers = scene.layers,
		world = scene.world:serialize(),
	}

	local serialized = Binser.serialize(data)
	Nativefs.write("scenes/" .. scene.name .. ".scd", serialized, #serialized)

	Nativefs.setWorkingDirectory("..")
end

---@param scene scene_data
---@param type string
---| "image"
---| "trigger"
function SceneData.new_layer(scene, type)
	local name = "Layer" .. (#scene.layers + 1)
	table.insert(scene.layers, {
		name = name,
		type = type,
		visible = true,
	})

	if type == "image" then
		Editor:add_entity(Engine.entities.sprite, nil)
	end

	scene.unsaved = true
end

function SceneData.remove_layer(scene, index)
	table.remove(scene.layers, index)
	scene.unsaved = true
end

return SceneData
