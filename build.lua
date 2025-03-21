local platform = "linux"
local target = arg[1]

if arg[2] then
	platform = arg[2]
else
	local sep = package.config:sub(1, 1)
	if sep == "\\" then
		platform = "win64"
	end
end

print(target, platform)

local cp_dir_cmd = ""
local rm_dir_cmd = ""
local mv_cmd = ""
local rm_cmd = ""
if platform == "linux" then
	cp_dir_cmd = "cp -r"
	rm_dir_cmd = "rm -r"
	mv_cmd = "mv"
	rm_cmd = "rm"
elseif platform == "win64" then
	cp_dir_cmd = "copy"
end

os.execute(mv_cmd .. " lover.toml lover.toml.bk")
os.execute(mv_cmd .. " lover_build.toml lover.toml")
os.execute(cp_dir_cmd .. " src/ temp/")

if target == "editor" then
	os.execute("cd temp/ && " .. rm_dir_cmd .. " runtime/")
elseif target == "runtime" then
	os.execute("cd temp/ && " .. rm_dir_cmd .. " editor/")
end

os.execute("lover build " .. platform)

os.execute(mv_cmd .. " lover.toml lover_build.toml")
os.execute(mv_cmd .. " lover.toml.bk lover.toml")
os.execute(rm_dir_cmd .. " temp/")

if platform == "linux" then
	os.execute("cp cimgui.so build/")
	os.execute("cd build/ && chmod +x Shraybn.AppImage && ./Shraybn.AppImage " .. target)
elseif platform == "win64" then
end
