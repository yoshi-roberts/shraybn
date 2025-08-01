local character = require("engine.character")
local font_icon = require("editor.font_icons")
local imgui = require("engine.imgui")
local ffi = require("ffi")

---@class editor.character_inspector
local character_inspector = {
	-- win_flags = imgui.love.WindowFlags(),
	buf = ffi.new("char[?]", 128, ""),
	selected_character = nil,
	renaming_node = -1,
}

---@param inspector editor.inspector
function character_inspector.display(inspector)
	imgui.Begin("Character", nil, nil)

	imgui.End()
end

return character_inspector
