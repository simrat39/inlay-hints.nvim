local eol = require("inlay-hints.render.eol")
local virtline = require("inlay-hints.render.virtline")
local ih = require("inlay-hints")

local M = {}

local function clear_ns(ns, bufnr)
  -- clear namespace which clears the virtual text as well
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

function M.render_line(line, line_hints, bufnr, ns)
      if #line_hints > 1 then
        virtline.render_line(line, line_hints, bufnr, ns)
      else
        eol.render_line(line, line_hints, bufnr, ns)
      end
end

function M.render(bufnr, ns, hints)
  local opts = ih.config.options or {}

  clear_ns(ns, bufnr)

  if opts.only_current_line then
    local curr_line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local line_hints = hints[curr_line]
    if line_hints then
      M.render_line(curr_line, line_hints, bufnr, ns)
    end
  else
    for line, line_hints in pairs(hints) do
      M.render_line(line, line_hints, bufnr, ns)
    end
  end
end

return M
