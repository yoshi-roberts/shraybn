local Class = require("libs.class")
local binser = require("libs.binser")
local nativefs = require("libs.nativefs")
local log = require("libs.log")

---@alias CharacterPortrait {name: string, asset_path: string}

---@class engine.Character: Class
local Character = Class:extend()

function Character:init(name)
	self.name = name ---@type string
	self.portraits = {} ---@type engine.Sprite[]

	self:add_portrait("neutral")
	self:add_portrait("happy")
	self:add_portrait("sad")
	self:add_portrait("angry")
	self:add_portrait("confused")
end

function Character:update() end

function Character:draw() end

---@param name string
---@param asset_path string?
function Character:add_portrait(name, asset_path)
	table.insert(self.portraits, {
		name = name,
		asset_path = asset_path,
	})
end

---@param path string
---@return engine.Character
function Character.load(path)
	-- .chd are character data files.

	local exists = nativefs.getInfo(path)

	if not exists then
		log.error("[CHARACTER] Could not load character '" .. path .. "'")
		return Character:new("character_load_error")
	end

	local contents = nativefs.read(path)
	local deserialized = binser.deserialize(contents)

	return deserialized[1]
end

---@param path string
function Character:save(path)
	local serialized = binser.serialize(self)

	if not nativefs.write(path, serialized, #serialized) then
		log.error("Character data could not be written.")
	end
end

return Character
