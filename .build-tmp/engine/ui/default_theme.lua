local colors = {
	white = { 1, 1, 1, 1 },
	black = { 0, 0, 0, 1 },
}

return {
	bg_color = colors.black,
	fg_color = colors.white,
	outline_color = colors.white,
	padding = 4,
	button = {
		normal = {
			bg_color = colors.black,
			fg_color = colors.white,
			outline_color = colors.white,
		},
		focussed = {
			bg_color = colors.white,
			fg_color = colors.black,
			outline_color = colors.white,
		},
	},
}
