---@class engine.signal
local signal = {}
local signals = {}

---@param name string
---@param callback function
function signal.register(name, callback)
	if not signals[name] then
		signals[name] = {}
	end

	table.insert(signals[name], callback)
end

---@param name string
---@param callback function
function signal.unregister(name, callback)
	if not signals[name] then
		return
	end

	for i = 1, #signals[name] do
		if signals[name][i] == callback then
			table.remove(signals[name], i)
		end
	end
end

---@param name string
function signal.clear(name)
	signals[name] = nil
end

---@param name string
function signal.emit(name, ...)
	if not signals[name] then
		return
	end

	for _, callback in pairs(signals[name]) do
		---@cast callback function
		callback(...)
	end
end

return signal
