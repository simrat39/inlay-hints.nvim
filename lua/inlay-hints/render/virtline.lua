local ih = require("inlay-hints")
local ui_utils = require("inlay-hints.utils.ui")
local t_utils = require("inlay-hints.utils.table")
local InlayHintKind = ih.kind

local M = {}

function M.render_line(line, line_hints, bufnr, ns)
  local opts = ih.config.options or {}

  local parameter_opts = opts.hints.parameter
  local type_opts = opts.hints.type

  local indent = string.match(vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1] or '', '^%s*') or ''
  local indent_len = string.len(indent)
  local virt_text = ""
  local virt_texts = {{indent, ''}}

  for _, hint in ipairs(line_hints) do
    local spaces = hint.range.character - indent_len - string.len(virt_text)
    if spaces < 1 then
      spaces = 1
    end

    local hint_text = string.rep(" ", spaces) .. hint.label
    table.insert(virt_texts, {
      hint_text,
      hint.kind == InlayHintKind.Type and type_opts.highlight
        or parameter_opts.highlight,
    })
    virt_text = virt_text .. hint_text
  end
  virt_text = indent .. virt_text

  local last_virt_text = ""
  local old = line_hints.old
  if old and old.virt_lines then
    if old.virt_lines then
      goto skip
    end
    local last = old.virt_lines[1]

    for _, value in ipairs(last) do
      last_virt_text = last_virt_text .. value[1]
    end
    ::skip::
  end

  -- Should clear if old had virt_text
  if virt_text == last_virt_text then
    return
  end

  ui_utils.clear_ns(bufnr, ns, line, line + 1)
  vim.api.nvim_buf_set_extmark(bufnr, ns, line, 0, {
    virt_lines = {
      virt_texts,
    },
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
