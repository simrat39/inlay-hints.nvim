local eol = require("inlay-hints.render.eol")

local M = {}

function M.render(bufnr, ns, hints) 
    eol.render(bufnr, ns, hints)
end

return M
