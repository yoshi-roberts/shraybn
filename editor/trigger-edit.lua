---@class trigger
local trigger = {}

---@param t Trigger
function trigger:draw_points(t)
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.push()
	love.graphics.translate(t.position.x, t.position.y)

	for i = 1, #t.verticies, 2 do
		local x = t.verticies[i]
		local y = t.verticies[i + 1]
		love.graphics.circle("fill", x, y, 8)
	end
	love.graphics.pop()
end

return trigger
