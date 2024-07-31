local ffi = require("ffi")

local function project_list(self)
	if Imgui.BeginListBox("##Projects", nil) then
		for k, v in pairs(self.projects) do
			local selected = (k == self.selected)

			if Imgui.Selectable_Bool(v, selected) then
				self.selected = k
			end

			if selected then
				Imgui.SetItemDefaultFocus()
			end
		end

		Imgui.EndListBox()
	end
end

local function display(self)
	if self.open[0] == false then
		self.create_new = false
		return
	end

	if not Imgui.Begin("Project Manager", self.open, self.win_flags) then
		Imgui.End()
	else
		self.win_size = Imgui.GetWindowSize()
		local screen_w, screen_h = love.graphics.getDimensions()

		local pos_x = (screen_w - self.win_size.x) / 2
		local pos_y = (screen_h - self.win_size.y) / 2

		Imgui.SetWindowPos_Vec2(Imgui.ImVec2_Float(pos_x, pos_y))

		if Imgui.Button("Open") then
			local name = self.projects[self.selected]
			ProjectManager:load(name)
			self.open[0] = false
		end

		Imgui.SameLine()
		if Imgui.Button("Delete") then
		end

		Imgui.SameLine()
		if Imgui.Button("New") then
			self.create_new = true
		end

		project_list(self)

		if self.create_new == true then
			if Imgui.InputText("##project_name", self.buf, 128) then
				self.name = ffi.string(self.buf)
			end

			if #self.warning > 0 then
				Imgui.Text(self.warning)
			end

			if Imgui.Button("Create") then
				if ProjectManager:create(self.name) then
					self.open[0] = false
				end
			end

			Imgui.SameLine()
			if Imgui.Button("Cancel") then
				self.create_new = false
			end
		end

		Imgui.End()
	end
end

return display
