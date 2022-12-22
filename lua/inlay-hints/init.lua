local Cache = require("inlay-hints.cache")
local BufUtils = require("inlay-hints.utils.buf")

local M = {
  adapter = nil,
  set = nil,
  set_all = nil,
  unset = nil,
  cache = nil,
  clear_cache = nil,
  config = nil,
  kind = nil,
  render = nil,
  on_attach = nil,
}

function M.setup(opts)
  local config = require("inlay-hints.config")
  M.config = config
  config.setup(opts)

  local kind = require("inlay-hints.kind")
  M.kind = kind

  local adapter = require("inlay-hints.adapter")
  M.adapter = adapter

  local renderer = require("inlay-hints.render")
  M.renderer = renderer

  local hint_cache = Cache:new()
  M.hint_cache = hint_cache

  local inlay = require("inlay-hints.hints")
  M.set = function()
    inlay.set()
  end
  M.set_all = function()
    inlay.set()
  end
  M.unset = function()
    inlay.unset()
  end
  M.cache = function()
    inlay.cache_render()
  end
  M.render = function()
    inlay.render()
  end
  M.on_attach = function(client, bufnr)
    inlay.on_attach(client, bufnr)
  end
  M.enable = function(bufnr)
    inlay.enable(BufUtils.parse_buf(bufnr))
  end
  M.disable = function(bufnr)
    inlay.disable(BufUtils.parse_buf(bufnr))
  end
  M.toggle = function(bufnr)
    inlay.toggle(BufUtils.parse_buf(bufnr))
  end
end

return M
