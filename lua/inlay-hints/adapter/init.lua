local default = require("inlay-hints.adapter.default")

local M = {}

function M.adapt_request(client, bufnr, callback)
  default.adapt_request(client, bufnr, callback)
end

return M
