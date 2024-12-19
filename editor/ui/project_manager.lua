local imgui = require "engine.imgui"
local ffi = require "ffi"

local function project_list(self)
	if imgui.BeginListBox("##Projects", nil) then
		for k, v in pairs(self.projects) do
			local selected = (k == self.selected)

			if imgui.Selectable_Bool(v, selected) then
				self.selected = k
			end

			if selected then
				imgui.SetItemDefaultFocus()
			end
		end

		imgui.EndListBox()
	end
end

---@param project_manager editor.project_manager
local function display(project_manager)
	if project_manager.open[0] == false then
		project_manager.create_new = false
		return
	end

	if not imgui.Begin("Project Manager", project_manager.open, project_manager.win_flags) then
		imgui.End()
	else
		project_manager.win_size = imgui.GetWindowSize()
		local screen_w, screen_h = love.graphics.getDimensions()

		local pos_x = (screen_w - project_manager.win_size.x) / 2
		local pos_y = (screen_h - project_manager.win_size.y) / 2

		imgui.SetWindowPos_Vec2(imgui.ImVec2_Float(pos_x, pos_y))

		if imgui.Button("Open") then
			local name = project_manager.projects[project_manager.selected]
			project_manager.load(name)
			project_manager.open[0] = false
		end

		imgui.SameLine()
		if imgui.Button("Delete") then
		end

		imgui.SameLine()
		if imgui.Button("New") then
			project_manager.create_new = true
		end

		project_list(project_manager)

		if project_manager.create_new == true then
			if imgui.InputText("##project_name", project_manager.buf, 128) then
				project_manager.name = ffi.string(project_manager.buf)
			end

			if #project_manager.warning > 0 then
				imgui.Text(project_manager.warning)
			end

			if imgui.Button("Create") then
				if project_manager.create(project_manager.name) then
					project_manager.open[0] = false
				end
			end

			imgui.SameLine()
			if imgui.Button("Cancel") then
				project_manager.create_new = false
			end
		end

		imgui.End()
	end
end

return display
