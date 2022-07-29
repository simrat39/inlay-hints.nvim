local ih = require("inlay-hints")

local M = {}

local function get_renderer()
  if M.renderer == nil then
    M.renderer = require(ih.config.options.renderer)
  end
  return M.renderer
end

function M.render(bufnr, ns, hints)
  local renderer = get_renderer()
  renderer.render(bufnr, ns, hints)
end

return M
