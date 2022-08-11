local M = {}

local function get_params(client, bufnr)
  local params = {
    textDocument = vim.lsp.util.make_text_document_params(bufnr),
    range = {
      start = {
        line = 0,
        character = 0,
      },
      ["end"] = {
        line = 0,
        character = 0,
      },
    },
  }

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
