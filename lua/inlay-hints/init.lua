local M = {
  adapter = nil,
  set = nil,
  set_all = nil,
  unset = nil,
  cache = nil,
  config = nil,
  kind = nil,
  render = nil,
  on_attach = nil,
}

function M.setup(opts)
  local config = require("inlay-hints.config")
  M.config = config
  config.setup(opts)

  local adapter = require("inlay-hints.adapter")
  M.adapter = adapter

  local kind = require("inlay-hints.kind")
  M.kind = kind

  local renderer = require("inlay-hints.render")
  M.renderer = renderer

  local inlay = require("inlay-hints.hints")
  local hints = inlay.new()
  M.set = function()
    inlay.set(hints)
  end
  M.set_all = function()
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
  M.on_attach = function(client, bufnr)
    inlay.on_attach(client, bufnr)
  end
end

return M
