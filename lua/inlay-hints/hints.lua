local ih = require("inlay-hints")

local M = {}

M.namespace = vim.api.nvim_create_namespace("textDocument/inlayHints")

local function clear_ns(bufnr)
  -- clear namespace which clears the virtual text as well
  vim.api.nvim_buf_clear_namespace(bufnr, M.namespace, 0, -1)
end

function M.set_all()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    M.cache_render(bufnr)
  end
end

-- Set inlay hints only for the current buffer
function M.set()
  M.cache_render(0)
end

-- Clear hints only for the current buffer
function M.unset()
  clear_ns(0)
end

function M.on_attach(_, bufnr)
  local opts = ih.config.options or {}

  vim.api.nvim_create_autocmd({
    "BufWritePost",
    "BufReadPost",
    "BufEnter",
    "BufWinEnter",
    "TabEnter",
    "TextChanged",
    "TextChangedI",
  }, {
    buffer = bufnr,
    callback = function()
      ih.cache()
    end,
  })

  vim.api.nvim_buf_attach(bufnr, false, {
    on_detach = function()
      ih.hint_cache:del(bufnr)
    end,
  })

  if opts.only_current_line then
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = bufnr,
      callback = function()
        ih.render()
      end,
    })
  end

  ih.cache()
end

-- Parses the result into a easily usable format
-- example:
-- {
--  ["12"] = { {
--      kind = "TypeHint",
--      label = "String"
--    } },
--  ["13"] = { {
--      kind = "TypeHint",
--      label = "usize"
--    } },
-- }
--
local function parse_hints(result)
  local map = {}

  if type(result) ~= "table" then
    return {}
  end

  for _, value in pairs(result) do
    local range = value.position
    local line = value.position.line
    local label = value.label

    local label_str = ""

    if type(label) == "string" then
      label_str = value.label
    elseif type(label) == "table" then
      for _, label_part in ipairs(label) do
        label_str = label_str .. label_part.value
      end
    end

    local kind = value.kind

    if map[line] ~= nil then
      table.insert(map[line], {
        label = label_str,
        kind = kind,
        range = range,
      })
    else
      map[line] = {
        { label = label_str, kind = kind, range = range },
      }
    end

    table.sort(map[line], function(a, b)
      return a.range.character < b.range.character
    end)
  end

  return map
end

function M.cache_render(bufnr)
  local buffer = bufnr or vim.api.nvim_get_current_buf()

  for _, client in ipairs(vim.lsp.buf_get_clients(buffer)) do
    ih.adapter.adapt_request(client, buffer, function(err, result, ctx)
      if err then
        return
      end

      ih.hint_cache:set(ctx.bufnr, parse_hints(result))

      M.render(ctx.bufnr)
    end)
  end
end

function M.render(bufnr)
  local buffer = bufnr or vim.api.nvim_get_current_buf()

  local hints = ih.hint_cache:get(buffer)

  if hints == nil then
    return
  end

  ih.renderer.render(buffer, M.namespace, hints)
end

return M
