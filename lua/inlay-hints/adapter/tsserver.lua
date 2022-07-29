local ih = require("inlay-hints")
local InlayHintKind = ih.kind
local M = {}

local function get_params(bufnr)
  ---@diagnostic disable-next-line: missing-parameter
  local params = vim.lsp.util.make_given_range_params()

  params["range"]["start"]["line"] = 0
  params["range"]["end"]["line"] = vim.api.nvim_buf_line_count(bufnr) - 1

  return params
end

function M.adapt_request(client, bufnr, callback)
  client.request(
    "typescript/inlayHints",
    get_params(bufnr),
    function(err, result, ctx)
      if err then
        return
      end

      local new_res = result.inlayHints

      for _, hint in ipairs(new_res) do
        if hint.kind == "Parameter" then
          hint.kind = InlayHintKind.Parameter
        else
          hint.kind = InlayHintKind.Type
        end

        hint.label = hint.text

        hint.paddingLeft = hint.whitespaceBefore
        hint.paddingRight = hint.whitespaceAfter
      end

      callback(err, new_res, ctx)
    end,
    bufnr
  )
end

return M
