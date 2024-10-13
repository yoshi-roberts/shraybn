local lust = require("libs.lust")
local expect = lust.expect

local utils = {}

---@param parser Parser
function utils.check_parse_errors(parser)
	if #parser.errors == 0 then
		return
	end

	print(string.format("Parser has %d errors.", #parser.errors))
	for _, msg in pairs(parser.errors) do
		print("Parser error: " .. msg)
	end

	-- Fail if we have any errors.
	expect(#parser.errors).to.equal(0)
end

return utils
