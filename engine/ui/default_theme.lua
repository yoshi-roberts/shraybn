local colors = {
	white = { 1, 1, 1, 1 },
	black = { 0, 0, 0, 1 },
}
local materialTheme = {
	background = {
		color = colors.black, -- Light gray background
	},
	text = {
		color = colors.white, -- Dark text for contrast
		font = love.graphics.newFont("libs/luis/themes/fonts/Roboto-Regular.ttf", 32),
		align = "left",
	},
	button = {
		color = colors.black, -- Material Blue
		hoverColor = colors.white,
		pressedColor = colors.white,
		textColor = colors.white,
		align = "center",
		cornerRadius = 0,
		elevation = 2,
		elevationHover = 4,
		elevationPressed = 8,
		transitionDuration = 0.2,
	},
	slider = {
		trackColor = colors.white,
		knobColor = colors.white,
		grabColor = colors.white,
		knobRadius = 14,
	},
	switch = {
		offColor = { 0.7, 0.7, 0.7 },
		onColor = { 0.2, 0.6, 0.9 },
		knobColor = { 1, 1, 1 },
	},
	checkbox = {
		boxColor = { 0.7, 0.7, 0.7 },
		checkColor = { 0.2, 0.6, 0.9 },
		cornerRadius = 2,
	},
	radiobutton = {
		circleColor = { 0.7, 0.7, 0.7 },
		dotColor = { 0.2, 0.6, 0.9 },
	},
	grid = {
		color = { 0.5, 0.5, 0.5, 0.3 },
	},
	progressbar = {
		backgroundColor = { 0.2, 0.6, 0.9, 1 },
		fillColor = { 0.25, 0.65, 0.95, 1 },
		borderColor = { 0.15, 0.55, 0.85, 1 },
	},
	icon = {
		color = { 1, 1, 1, 1 },
	},
	dropdown = {
		backgroundColor = { 0.2, 0.6, 0.9, 1 },
		textColor = { 1, 1, 1, 1 },
		align = "center",
		hoverColor = { 0.35, 0.75, 0.95, 1 },
		borderColor = { 0.15, 0.55, 0.85, 1 },
		arrowColor = { 1, 1, 1, 1 },
		scrollBarColor = { 0.5, 0.5, 0.5 },
		scrollBarWidth = 10,
	},
	textinput = {
		backgroundColor = { 0.2, 0.6, 0.9, 1 },
		textColor = { 1, 1, 1, 1 },
		cursorColor = { 1, 1, 1, 1 },
		selectionColor = { 0.25, 0.65, 0.95, 1 },
		borderColor = { 0.15, 0.55, 0.85, 1 },
		borderWidth = 2,
		padding = 5,
	},
	flexContainer = {
		backgroundColor = colors.black,
		borderColor = colors.white,
		borderWidth = 2,
		padding = 10,
		handleSize = 10,
		handleColor = colors.white,
		cornerRadius = 1,
	},
}

return materialTheme
