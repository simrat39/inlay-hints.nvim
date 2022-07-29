local tsserver = require("inlay-hints.adapter.tsserver")
local default = require("inlay-hints.adapter.default")

local M = {}

function M.adapt_request(client, bufnr, callback)
  if client.name == "tsserver" then
    tsserver.adapt_request(client, bufnr, callback)
  else
    default.adapt_request(client, bufnr, callback)
  end
end

return M
