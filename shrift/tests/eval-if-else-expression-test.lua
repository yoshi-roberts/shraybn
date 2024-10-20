local utils = require("shrift.tests.utils") --[[@as test_utils]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

it("Eval If/Else Expression", function()
	local tests = {
		{ "if (true) { 10 }", 10 },
		{ "if (false) { 10 }", nil },
		{ "if (1) { 10 }", 10 },
		{ "if (1 < 2) { 10 }", 10 },
		{ "if (1 > 2) { 10 }", nil },
		{ "if (1 > 2) { 10 } else { 20 }", 20 },
		{ "if (1 < 2) { 10 } else { 20 }", 10 },
	}

	for _, v in pairs(tests) do
		local input = v[1]
		local expected = v[2]

		local evaluated = utils.test_eval(input)

		if expected ~= nil then
			utils.test_integer_object(evaluated, expected)
		else
			utils.test_null_object(evaluated)
		end
	end
end)
