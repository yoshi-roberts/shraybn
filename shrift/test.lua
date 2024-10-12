local lust = require("libs.lust")
local describe = lust.describe

describe("Shrift", function()
	require("shrift.tests.lexer-tests")
	require("shrift.tests.parser-tests")
end)
