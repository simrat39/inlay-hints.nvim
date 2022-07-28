local M = {
	enable = nil,
	disable = nil,
	set = nil,
	unset = nil,
	cache = nil,
	config = nil,
	kind = nil,
	render = nil,
}

function M.setup(opts)
	local config = require("inlay-hints.config")
	M.config = config
	config.setup(opts)

	local kind = require("inlay-hints.kind")
	M.kind = kind

	local renderer = require("inlay-hints.render")
	M.renderer = renderer

	local inlay = require("inlay-hints.hints")
	local hints = inlay.new()
	M.enable = function()
		inlay.enable(hints)
	end
	M.disable = function()
		inlay.disable(hints)
	end
	M.set = function()
		inlay.set(hints)
	end
	M.unset = function()
		inlay.unset()
	end
	M.cache = function()
		inlay.cache_render(hints)
	end
	M.render = function()
		inlay.render(hints)
	end

	M.enable()
end

return M
