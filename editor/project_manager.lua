local ffi = require("ffi")
local pprint = require("libs.pprint")

local win_flags = Imgui.love.WindowFlags(
	"NoDocking",
	"NoCollapse",
	"NoResize",
	"NoMove",
	-- "NoBringToFrontOnFocus",
	"NoSavedSettings",
	"AlwaysAutoResize"
	-- "NoFocusOnAppearing"
)

local proj_manager = {
	projects = Nativefs.getDirectoryItems("projects"),
	open = ffi.new("bool[1]", false),
	selected = 1,
	warning = "",
	create_new = false,
	name = "New Project",
	buf = ffi.new("char[?]", 128, "New Project"),
}

local win_size = Imgui.ImVec2_Float(0.0, 0.0)

local function create_project(name)
	local proj_exists = Nativefs.getInfo(name)
	if proj_exists then
		print("Exists!")
		proj_manager.warning = "Project '" .. name .. "' already exists."
		return false
	end

	Nativefs.createDirectory(name)
	Nativefs.setWorkingDirectory(name)

	Nativefs.createDirectory("assets")
	Nativefs.createDirectory("scenes")

	local proj = Project.new(name)
	local serialized = Binser.serialize(proj)
	Nativefs.write("proj.sep", serialized, #serialized)

	-- Update project list.
	Nativefs.setWorkingDirectory("..")
	proj_manager.projects = Nativefs.getDirectoryItems("./")

	return true
end

local function open_project(name)
	local proj = Project.load(name)
	Editor.loaded_project = proj

	-- Nativefs.setWorkingDirectory("..")
	FilePanel:create_tree(name, FilePanel.tree)
end

function proj_manager.display()
	if proj_manager.open[0] == false then
		proj_manager.create_new = false
		return
	end

	if not Imgui.Begin("Project Manager", proj_manager.open, win_flags) then
		Imgui.End()
	else
		win_size = Imgui.GetWindowSize()
		local screen_w, screen_h = love.graphics.getDimensions()

		local pos_x = (screen_w - win_size.x) / 2
		local pos_y = (screen_h - win_size.y) / 2

		Imgui.SetWindowPos_Vec2(Imgui.ImVec2_Float(pos_x, pos_y))

		if Imgui.Button("Open") then
			local name = proj_manager.projects[proj_manager.selected]
			open_project(name)
			proj_manager.open[0] = false
		end

		Imgui.SameLine()
		if Imgui.Button("Delete") then
		end

		Imgui.SameLine()
		if Imgui.Button("New") then
			proj_manager.create_new = true
		end

		if Imgui.BeginListBox("##Projects", nil) then
			for k, v in pairs(proj_manager.projects) do
				local selected = (k == proj_manager.selected)

				if Imgui.Selectable_Bool(v, selected) then
					proj_manager.selected = k
				end

				if selected then
					Imgui.SetItemDefaultFocus()
				end
			end

			Imgui.EndListBox()
		end

		if proj_manager.create_new == true then
			if Imgui.InputText("##project_name", proj_manager.buf, 128) then
				proj_manager.name = ffi.string(proj_manager.buf) -- Update inputText if the user has edited the text
			end

			if #proj_manager.warning > 0 then
				Imgui.Text(proj_manager.warning)
			end

			if Imgui.Button("Create") then
				if create_project(proj_manager.name) then
					proj_manager.open[0] = false
				end
			end

			Imgui.SameLine()
			if Imgui.Button("Cancel") then
				proj_manager.create_new = false
			end
		end

		Imgui.End()
	end
end

return proj_manager
