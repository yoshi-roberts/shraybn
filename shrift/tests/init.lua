local lust = require("libs.lust")
local describe = lust.describe

describe("Shrift", function()
	require("shrift.tests.splitlines")
	require("shrift.tests.getlinetype")
	require("shrift.tests.parsedialogue")
	require("shrift.tests.parsechoice")
	require("shrift.tests.parsecondition")
	require("shrift.tests.parseerrors")
end)
