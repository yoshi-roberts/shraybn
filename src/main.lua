local lover_context = os.getenv("LOVER_CONTEXT")

if lover_context == "build" then
	require("editor")
else
	require("src.editor")
end
