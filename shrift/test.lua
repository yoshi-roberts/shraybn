local lust = require("libs.lust")
local describe = lust.describe

describe("Shrift", function()
	require("shrift.tests.lexer-test")
	require("shrift.tests.ast-test")
	require("shrift.tests.parser-let-statement-test")
	require("shrift.tests.parser-return-statement-test")
end)
