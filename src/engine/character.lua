local binser = require("libs.binser")
local nativefs = require("libs.nativefs")
local log = require("libs.log")

---@alias engine.character.Portrait {mood: string, asset_path: string}
---@alias engine.character.Character {id: integer, name: string, mood: string, portraits: engine.character.Portrait[]}

---@class engine.character
local character = {}

character.characters = {} ---@type engine.character.Character[]
character.ids = {}

function character.add(name)
	local id = #character.characters + 1

	table.insert(character.characters, {
		id = id,
		name = name,
		mood = "neutral",
		portraits = {},
	})

	character.ids[name] = id

	character.add_portrait(name, "neutral")
	character.add_portrait(name, "happy")
	character.add_portrait(name, "sad")
	character.add_portrait(name, "angry")
end

---@param name string
---@param mood string
---@param asset_path string?
function character.add_portrait(name, mood, asset_path)
	local id = character.ids[name]
	local char = character.characters[id]
	table.insert(char.portraits, {
		mood = mood,
		asset_path = asset_path,
	})
end

---@param path string
function character.load(path)
	-- .chd is character data file.

	path = path .. "/characters.chd"
	local exists = nativefs.getInfo(path)

	if not exists then
		log.error("[CHARACTER] Could not load character data '" .. path .. "'")
		return
	end

	local contents = nativefs.read(path)
	local deserialized = binser.deserialize(contents)

	character.characters = deserialized

	for _, char in pairs(character.characters) do
		---@cast char engine.character.Character
		character.ids[char.name] = char.id
	end

	log.info("[CHARACTER] Loaded character data")
end

---@param path string
function character:save(path)
	local serialized = binser.serialize(character.characters)

	if not nativefs.write(path .. "/characters.chd", serialized, #serialized) then
		log.error("Character data could not be written.")
	end
end

return character
