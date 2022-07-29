local ih = require("inlay-hints")
local InlayHintKind = ih.kind

local M = {}

---@diagnostic disable-next-line: missing-parameter
local function get_params(bufnr)
  return { textDocument = vim.lsp.util.make_text_document_params(bufnr) }
end

function M.adapt_request(client, bufnr, callback)
  client.request(
    "clangd/inlayHints",
    get_params(bufnr),
    function(err, result, ctx)
      if err then
        return
      end

      local new_res = result

      for _, hint in ipairs(new_res) do
        if hint.kind == "type" then
          hint.kind = InlayHintKind.Type
        else
          hint.kind = InlayHintKind.Parameter
        end
      end

      callback(err, new_res, ctx)
    end,
    bufnr
  )
end

return M
