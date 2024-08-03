---@class Sprite
---@field super Object
Sprite = Entity:extend()

---@param asset string
function Sprite:new(name, asset)
	Sprite.super.new(self, name)

	if asset then
		self.asset = Assets:get("image", asset)
	else
		self.asset = nil
	end
end

---@param position vector
---@param scale vector
function Sprite:draw(position, scale)
	love.graphics.setColor(1, 1, 1, 1)

	if not scale then
		scale = Vec2(1, 1)
	end

	love.graphics.draw(self.asset, position:unpack(), scale:unpack())
end

function Sprite:__tostring()
	return "Sprite"
end
