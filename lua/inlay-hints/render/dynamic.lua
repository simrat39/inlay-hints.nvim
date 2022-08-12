local eol = require("inlay-hints.render.eol")
local virtline = require("inlay-hints.render.virtline")
local ui_utils = require("inlay-hints.utils.ui")
local t_utils = require("inlay-hints.utils.table")
local ih = require("inlay-hints")

local M = {}

function M.render_line(line, line_hints, bufnr, ns)
  if #line_hints > 1 then
    virtline.render_line(line, line_hints, bufnr, ns)
  else
    eol.render_line(line, line_hints, bufnr, ns)
  end
end

function M.render(bufnr, ns, hints)
  local opts = ih.config.options or {}

  if opts.only_current_line then
    local curr_line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local line_hints = hints[curr_line]
      ui_utils.clear_ns_except(bufnr, ns, { curr_line })
    if line_hints then
      M.render_line(curr_line, line_hints, bufnr, ns)
    end
  else
    local lines = t_utils.get_keys(hints)
    table.sort(lines, function(a, b)
      return a < b
    end)

    ui_utils.clear_ns_except(bufnr, ns, lines)

    local marks = vim.api.nvim_buf_get_extmarks(
      bufnr,
      ns,
      0,
      -1,
      { details = true }
    )

    for _, mark in ipairs(marks) do
      local mark_line = mark[2]
      if hints[mark_line] then
        hints[mark_line].old = mark[4]
      end
    end

    for line, line_hints in pairs(hints) do
      M.render_line(line, line_hints, bufnr, ns)
    end
  end
end

return M
