local Entity = require("engine.entity")
local assets = require("engine.assets")
local binser = require("libs.binser")

---@class engine.Sprite: engine.Entity
local Sprite = Entity:extend()

---@param path string
function Sprite:init(name, path)
	Sprite.super.new(self, name)

	self.asset_path = path
end

---@param position Vec2?
---@param scale Vec2?
function Sprite:draw(position, scale)
	if not self.asset_path then
		return
	end

	local asset = assets.get("image", self.asset_path)

	if not asset then
		return
	end

	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.draw(
		asset.resource,
		self.position.x,
		self.position.y,
		self.rotation,
		self.scale.x,
		self.scale.y
	)
end

---@private
function Sprite:__tostring()
	return "Sprite"
end

binser.register(Sprite, "Sprite")
return Sprite
