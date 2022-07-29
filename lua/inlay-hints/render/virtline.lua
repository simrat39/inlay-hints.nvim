local ih = require("inlay-hints")

local M = {}

local function clear_ns(ns, bufnr)
  -- clear namespace which clears the virtual text as well
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

function M.render_line(line, line_hints, bufnr, ns)
  local opts = ih.config.options or {}
    
    local virt_text = ""

    for _, hint in ipairs(line_hints) do
      local spaces = hint.range.character - string.len(virt_text)
      if spaces < 1 then
        spaces = 1
      end

      virt_text = virt_text .. string.rep(" ", spaces) .. hint.label
    end

    if virt_text ~= "" then
      vim.api.nvim_buf_set_extmark(bufnr, ns, line, 0, {
        virt_lines = {
          { { virt_text, opts.highlight } },
        },
      })
    end
end

function M.render(bufnr, ns, hints)

  clear_ns(ns, bufnr)

  for line, line_hints in pairs(hints) do
      M.render_line(line, line_hints, bufnr, ns)
  end
end

return M
