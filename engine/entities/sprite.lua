local function sprite(e, image, position, rotation)
	e:give("image", image)
	e:give("transform", position, rotation)
end

return sprite
