local target = ""

if arg[1] == "runtime" then
	target = target .. "runtime"
elseif arg[1] == "editor" then
	target = target .. "editor"
else
	print("Options are 'runtime' or 'editor'")
end

if target == "runtime" then
	os.execute("cp build-runtime.toml lover.toml")
elseif target == "editor" then
	os.execute("cp run-editor.toml lover.toml")
end

os.execute("lover run " .. target)
os.execute("rm lover.toml")
