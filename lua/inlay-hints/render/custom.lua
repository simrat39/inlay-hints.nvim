local ih = require("inlay-hints")

local M = {}

function M.render(bufnr, _, hints)
  local opts = ih.config.options or {}

  if opts.only_current_line then
    local curr_line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local line_hints = hints[curr_line]
    vim.b[bufnr].inlay_hints = line_hints
  else
    vim.b[bufnr].inlay_hints = hints
  end
end

return M
