local ih = require("inlay-hints")
local ui_utils = require("inlay-hints.utils.ui")
local t_utils = require("inlay-hints.utils.table")
local InlayHintKind = ih.kind

local M = {}

function M.render_line(line, line_hints, bufnr, ns)
  local opts = ih.config.options or {}

  local eol_opts = opts.eol
  local parameter_opts = opts.hints.parameter
  local type_opts = opts.hints.type

  local virt_text = {}
  local virt_text_str = ""

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
    local text = ""
    for i, hint in ipairs(param_hints) do
      text = text .. hint.label
      if i ~= #param_hints then
        text = text .. eol_opts.parameter.separator
      end
    end
    text = eol_opts.parameter.format(text)

    virt_text_str = virt_text_str .. text
    table.insert(virt_text, { text, parameter_opts.highlight })
  end

  -- show other hints with commas and a thicc arrow
  if not vim.tbl_isempty(type_hints) then
    local text = ""
    for i, hint in ipairs(type_hints) do
      text = text .. hint.label

      if i ~= #type_hints then
        text = text .. eol_opts.type.separator
      end
    end
    text = eol_opts.type.format(text)

    virt_text_str = virt_text_str .. text
    table.insert(virt_text, { text, type_opts.highlight })
  end

  local last_virt_text = ""
  local old = line_hints.old
  if old and old.virt_text then
    if old.virt_lines then
      goto skip
    end

    local last = old.virt_text

    for _, value in ipairs(last) do
      last_virt_text = last_virt_text .. value[1]
    end

    ::skip::
  end

  if virt_text_str == last_virt_text then
    return
  end

  ui_utils.clear_ns(bufnr, ns, line, line + 1)
  vim.api.nvim_buf_set_extmark(bufnr, ns, line, 0, {
    virt_text_pos = eol_opts.right_align and "right_align" or "eol",
    virt_text = virt_text,
    hl_mode = "combine",
    priority = eol_opts.priority,
  })
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
