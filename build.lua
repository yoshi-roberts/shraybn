local platform = "linux"

if arg[1] then
	platform = arg[1]
else
	local sep = package.config:sub(1, 1)
	if sep == "\\" then
		platform = "win64"
	end
end

os.execute("lover build " .. platform)

if platform == "linux" then
	os.execute("cp cimgui.so build/")
	os.execute("cd build/ && sudo chmod +x Shraybn.AppImage && ./Shraybn.AppImage")
end
