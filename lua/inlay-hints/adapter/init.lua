local tsserver = require("inlay-hints.adapter.tsserver")
local clangd = require("inlay-hints.adapter.clangd")
local default = require("inlay-hints.adapter.default")
local ih = require("inlay-hints")

local M = {}

--- Checks the user configuration for adapting the current LSP calls for inlay hints
--- given the following criteria:
--- - force: use adapter always depending on the custom implementation of the server (previous behavior)
--- - disable: never adapt requests, using the default support for inlays in LSP
--- - auto: checks whether the current server provides this capability as a standard LSP one or adapts the request otherwise
--- Returns true to adapt the request, false to use the standard method
--- @return boolean
local function should_apply_tsserver_adapter(client)
  local mode = ih.config.options.adapter.tsserver

  if mode == 'force' then
    return true
  elseif mode == 'auto' then
    -- as per current implementation of the typescript-language-server and protocol spec
    -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_inlayHint
    return not client.server_capabilities.inlayHintProvider
  else -- assume 'disable'
    return false
  end
end

function M.adapt_request(client, bufnr, callback)
  if client.name == "tsserver" and should_apply_tsserver_adapter(client) then
    tsserver.adapt_request(client, bufnr, callback)
  elseif client.name == "clangd" then
    clangd.adapt_request(client, bufnr, callback)
  else
    default.adapt_request(client, bufnr, callback)
  end
end

return M
