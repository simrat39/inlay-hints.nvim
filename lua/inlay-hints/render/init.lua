-- local eol = require("inlay-hints.render.eol")
local virtline = require("inlay-hints.render.virtline")

local M = {}

function M.render(bufnr, ns, hints)
	virtline.render(bufnr, ns, hints)
end

return M
