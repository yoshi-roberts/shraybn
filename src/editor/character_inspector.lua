-- local character = require("engine.character")
local editor = require("editor")
local font_icon = require("editor.font_icons")
local widgets = require("editor.widgets")
local imgui = require("engine.imgui")
local ffi = require("ffi")

---@class editor.character_inspector
local character_inspector = {
	-- win_flags = imgui.love.WindowFlags(),
	buf = ffi.new("char[?]", 128, ""),
	selected_character = nil, ---@type editor.CharacterData
	renaming_node = -1,
}

function character_inspector.display()
	local character_data = editor.characters.current

	imgui.Begin("Character", nil, nil)

	if not character_data then
		imgui.End()
		return
	end

	imgui.Text("Name: " .. character_data.character.name)
	imgui.Separator()

	for id, portrait in pairs(character_data.character.portraits) do
		---@cast portrait engine.Portrait

		widgets.resource(portrait, "asset_path", portrait.mood)
	end

	imgui.End()
end

return character_inspector
