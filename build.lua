local target = ""

if arg[1] == "runtime" then
	target = target .. "runtime"
elseif arg[1] == "editor" then
	target = target .. "editor"
else
	print("Options are 'runtime' or 'editor'")
end

-- local cmd = "love src/ " .. target
-- if arg[2] then
-- 	cmd = cmd .. " " .. arg[2]
-- end
--

os.execute("mkdir .build-tmp")
os.execute("cp src/conf.lua .build-tmp")
os.execute("cp -r src/libs .build-tmp")
os.execute("cp -r src/engine .build-tmp")
os.execute("cp -r src/shrift .build-tmp")

if target == "runtime" then
	os.execute("cp -r src/runtime .build-tmp")
	os.execute("cp build-runtime.toml lover.toml")
	os.execute("echo require('runtime') > .build-tmp/main.lua")
elseif target == "editor" then
	os.execute("cp -r src/editor .build-tmp")
	os.execute("mv .build-tmp/editor/res build")
	os.execute("cp build-editor.toml lover.toml")
	os.execute("echo \"require('editor')\" > .build-tmp/main.lua")
end

os.execute("lover build linux")
os.execute("cp src/cimgui.so build")

-- os.execute("rm -r .build-tmp")
os.execute("rm lover.toml")
