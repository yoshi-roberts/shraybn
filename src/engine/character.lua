local nativefs = require("libs.nativefs")
local binser = require("libs.binser")
local Class = require("libs.class")
local log = require("libs.log")

---@alias engine.Portrait {mood: string, asset_path: string}

---@class engine.Character: Class
local Character = Class:extend()

function Character:init(name)
	self.name = name
	self.mood = "neutral"
	self.portraits = {} ---@type engine.Portrait[]
	self.portrait_ids = {}
	self.path = nil

	self:add_portrait("neutral")
	self:add_portrait("happy")
	self:add_portrait("sad")
	self:add_portrait("angry")
end

---@param mood string
---@param asset_path string?
function Character:add_portrait(mood, asset_path)
	local id = #self.portraits + 1

	table.insert(self.portraits, {
		mood = mood,
		asset_path = asset_path,
	})
	self.portrait_ids[mood] = id
end

---@param path string
function Character:save(path)
	local serialized = binser.serialize(self)

	if not nativefs.write(path, serialized, #serialized) then
		log.error("Character data could not be written.")
	end
end

---@param path string
---@return engine.Character?
function Character.load(path)
	-- .chd is character data file.

	local exists = nativefs.getInfo(path)

	if not exists then
		log.error("[CHARACTER] Could not load character data '" .. path .. "'")
		return
	end

	local contents = nativefs.read(path)
	local deserialized = binser.deserialize(contents)

	log.info("[CHARACTER] Loaded character data")
	return deserialized[1]
end

---@private
function Character:__tostring()
	return "Character"
end

return Character
