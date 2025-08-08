local imgui = require("engine.imgui")
local editor = require("editor")
local signal = require("engine.signal")
local ffi = require("ffi")

local ChangeField = require("editor.command.change_field")

---@class editor.widgets
local widgets = {
	payload = nil, ---@type table

	check_bool = ffi.new("bool[1]", 0),
	temp_int = ffi.new("int[1]", 0),
	temp_float = ffi.new("float[1]", 0),

	current_combo_item = nil,

	viewer_width = 256,
	viewer_height = 384,
	viewer_image = nil,

	bk_grid = love.graphics.newImage("editor/resources/bk_grid.png"),
}

signal.register("editor_file_drag", function(payload)
	if not widgets.payload then
		widgets.payload = payload
	end
end)

function widgets.bool(label, target)
	widgets.check_bool[0] = target

	local tag = label .. "##" .. label .. "_CHECKBOX_BOOL"

	if imgui.Checkbox(tag, widgets.check_bool) then
		-- editor.scenes.current.saved = false
		return widgets.check_bool[0]
	end

	return target
end

---@param label string
function widgets.combo(label, target, items)
	if imgui.BeginCombo(label, widgets.current_combo_item) then
		for k, item in pairs(items) do
			local is_selected = (widgets.current_combo_item == k)

			if imgui.Selectable_Bool(k, is_selected) then
				inspector.current_combo_item = k
				trigger.action = action:new()
			end

			if is_selected then
				imgui.SetItemDefaultFocus()
			end
		end
	end
end

---@param target table
---@param field string
---@param label string
---@param is_int boolean?
function widgets.property_number(target, field, label, is_int)
	local id = string.format("%p", target) .. "_" .. field

	local total_width = imgui.GetContentRegionAvail().x
	local height = imgui.GetTextLineHeightWithSpacing()
	local pos = imgui.ImVec2_Float(total_width * 0.5, height)

	imgui.SetNextItemWidth(total_width * 0.5)
	imgui.BeginChild_Str(id .. "_text_child", pos, false)
	imgui.Text(label)
	imgui.EndChild()

	imgui.SameLine()

	local available_width = imgui.GetContentRegionAvail().x
	imgui.SetNextItemWidth(available_width)

	if is_int then
		widgets.temp_int[0] = target[field]
		if imgui.DragInt("##" .. id .. "_input", widgets.temp_int) then
			editor.history:add(ChangeField:new(target, field, widgets.temp_int[0], true))
		end

		return
	end

	widgets.temp_float[0] = target[field]
	if imgui.DragFloat("##" .. id .. "_input", widgets.temp_float, 0.01) then
		editor.history:add(ChangeField:new(target, field, widgets.temp_float[0], true))
	end
end

---@param target table
---@param field string
---@param label string?
function widgets.resource(target, field, label)
	local text = target[field] or "No Resource"

	if label then
		text = label .. ": " .. text
	end

	imgui.Text(text)

	if imgui.BeginDragDropTarget() then
		imgui.AcceptDragDropPayload("DRAG_DROP_FILE")

		if imgui.IsMouseReleased_Nil(0) and widgets.payload then
			editor.history:add(ChangeField:new(target, field, widgets.payload.path))

			widgets.payload = nil
		end

		imgui.EndDragDropTarget()
	end
end

---@param view_height number
function widgets.image(image, view_height)
	local win_width = imgui.GetContentRegionAvail().x

	local view_width = win_width
	view_height = view_height or 384

	local tile_size = 32
	local xtiles = math.floor(view_width / tile_size)
	local ytiles = math.floor(view_height / tile_size)

	local child_size = imgui.ImVec2_Float(view_width, view_height)
	local flags = imgui.love.WindowFlags("NoScrollbar", "NoScrollWithMouse")

	imgui.BeginChild_Str("inspector_image_view_" .. tostring(image), child_size, false, flags)

	local startx = imgui.GetCursorPosX()
	local starty = imgui.GetCursorPosY()

	local tex_size = imgui.ImVec2_Float(tile_size, tile_size)

	-- Draw the grid.
	for x = 0, xtiles do
		for y = 0, ytiles do
			local xp = startx + (x * tile_size)
			local yp = starty + (y * tile_size)
			imgui.SetCursorPos(imgui.ImVec2_Float(xp, yp))
			imgui.Image(widgets.bk_grid, tex_size)
		end
	end

	-- Calculate image scaling and position.
	local img_width = image.resource:getWidth()
	local img_height = image.resource:getHeight()
	local sx = view_width / img_width
	local sy = view_height / img_height
	local scale = math.min(sx, sy)
	local image_size = imgui.ImVec2_Float(img_width * scale, img_height * scale)

	local xpos = (startx + (view_width / 2)) - ((img_width * scale) / 2)
	local ypos = (starty + (view_height / 2)) - ((img_height * scale) / 2)

	-- Draw the image.
	imgui.SetCursorPos(imgui.ImVec2_Float(xpos, ypos))
	imgui.Image(image.resource, image_size)

	imgui.EndChild()
end

return widgets
