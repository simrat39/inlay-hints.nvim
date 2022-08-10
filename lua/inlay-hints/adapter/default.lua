local M = {}

local function get_params(client, bufnr)
  ---@diagnostic disable-next-line: missing-parameter
  local params = vim.lsp.util.make_given_range_params()
  params["range"]["start"]["line"] = 0
  params["range"]["start"]["character"] = 0

  local line_count = vim.api.nvim_buf_line_count(bufnr) - 1
  local last_line = vim.api.nvim_buf_get_lines(
    bufnr,
    line_count,
    line_count + 1,
    true
  )

  params["range"]["end"]["line"] = line_count
  params["range"]["end"]["character"] = vim.lsp.util.character_offset(
    bufnr,
    line_count,
    #last_line[1],
    client.offset_encoding
  )

  return params
end

function M.adapt_request(client, bufnr, callback)
  client.request(
    "textDocument/inlayHint",
    get_params(client, bufnr),
    callback,
    bufnr
  )
end

return M
