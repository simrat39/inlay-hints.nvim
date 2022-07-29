local M = {}

local function get_params(bufnr)
  ---@diagnostic disable-next-line: missing-parameter
  local params = vim.lsp.util.make_given_range_params()

  params["range"]["start"]["line"] = 0
  params["range"]["end"]["line"] = vim.api.nvim_buf_line_count(bufnr) - 1

  return params
end

function M.adapt_request(client, bufnr, callback)
  client.request("textDocument/inlayHint", get_params(bufnr), callback, bufnr)
end

return M
