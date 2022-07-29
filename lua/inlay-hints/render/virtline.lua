local ih = require("inlay-hints")
local InlayHintKind = ih.kind

local M = {}

local function clear_ns(ns, bufnr)
  -- clear namespace which clears the virtual text as well
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

function M.render_line(line, line_hints, bufnr, ns)
  local opts = ih.config.options or {}

  local parameter_opts = opts.hints.parameter
  local type_opts = opts.hints.type

  local virt_lines = {}
  local virt_text = ""

  for _, hint in ipairs(line_hints) do
    local spaces = hint.range.character - string.len(virt_text)
    if spaces < 1 then
      spaces = 1
    end

    table.insert(virt_lines, {
      string.rep(" ", spaces) .. hint.label,
      hint.kind == InlayHintKind.Type and type_opts.highlight
        or parameter_opts.highlight,
    })
    virt_text = virt_text .. string.rep(" ", spaces) .. hint.label
  end

  vim.api.nvim_buf_set_extmark(bufnr, ns, line, 0, {
    virt_lines = {
      virt_lines,
    },
  })
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
