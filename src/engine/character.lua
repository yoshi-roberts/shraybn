local Class = require("libs.class")
local binser = require("libs.binser")
local nativefs = require("libs.nativefs")
local log = require("libs.log")

---@class engine.Character: Class
local Character = Class:extend()

function Character:init(name)
	self.name = name ---@type string
	self.portraits = {} ---@type engine.Sprite[]
end

function Character:update() end

function Character:draw() end

---@param path string
function Character:save(path)
	local serialized = binser.serialize(self)

	if not nativefs.write(path, serialized, #serialized) then
		log.error("Character data could not be written.")
	end
end

return Character
