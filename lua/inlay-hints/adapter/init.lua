local tsserver = require("inlay-hints.adapter.tsserver")
local clangd = require("inlay-hints.adapter.clangd")
local default = require("inlay-hints.adapter.default")
local ih = require("inlay-hints")

local M = {}

function M.adapt_request(client, bufnr, callback)
  local opts = ih.config.options or {}
  local adapter = opts.adapter or {}

  if client.name == "tsserver" and adapter.tsserver then
    tsserver.adapt_request(client, bufnr, callback)
  elseif client.name == "clangd" then
    clangd.adapt_request(client, bufnr, callback)
  else
    default.adapt_request(client, bufnr, callback)
  end
end

return M
