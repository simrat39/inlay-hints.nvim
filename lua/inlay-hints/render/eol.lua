local ih = require("inlay-hints")
local InlayHintKind = ih.kind

local M = {}

local function clear_ns(ns, bufnr)
  -- clear namespace which clears the virtual text as well
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

function M.render_line(line, line_hints, bufnr, ns)
  local opts = ih.config.options or {}

  local eol_opts = opts.eol
  local parameter_opts = opts.hints.parameter
  local type_opts = opts.hints.type

  local virt_text = {}

  local type_hints = {}
  local param_hints = {}

  -- segregate paramter hints and other hints
  for _, hint in ipairs(line_hints) do
    if hint.kind == InlayHintKind.Type then
      table.insert(type_hints, hint)
    elseif hint.kind == InlayHintKind.Parameter then
      table.insert(param_hints, hint)
    end
  end

  -- show parameter hints inside brackets with commas and a thin arrow
  if not vim.tbl_isempty(param_hints) and parameter_opts.show then
    for i, hint in ipairs(param_hints) do
      local text = hint.label
      if i ~= #param_hints then
        text = text .. ", "
      end
      table.insert(virt_text, { text, parameter_opts.highlight })
    end
  end

  -- show other hints with commas and a thicc arrow
  if not vim.tbl_isempty(type_hints) then
    for i, hint in ipairs(type_hints) do
      local text = hint.label

      if i ~= #type_hints then
        text = text .. ", "
      end
      table.insert(virt_text, { text, type_opts.highlight })
    end
  end

  vim.api.nvim_buf_set_extmark(bufnr, ns, line, 0, {
    virt_text_pos = eol_opts.right_align and "right_align" or "eol",
    virt_text = virt_text,
    hl_mode = "combine",
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
