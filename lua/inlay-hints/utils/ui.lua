local M = {}

---Clear namespace for all lines except given exceptions
---@param bufnr number
---@param ns number
---@param exceptions number[]
function M.clear_ns_except(bufnr, ns, exceptions)
  if #exceptions == 0 then
    return
  end

  local last = 0
  for _, line in ipairs(exceptions) do
    vim.api.nvim_buf_clear_namespace(bufnr, ns, last, line)
    last = line + 1
  end

  local last_exception = exceptions[#exceptions] + 1
  vim.api.nvim_buf_clear_namespace(bufnr, ns, last_exception, -1)
end

---Clear the entire namespace
---@param bufnr number
---@param ns number
---@param from number?
---@param to number?
function M.clear_ns(bufnr, ns, from, to)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, from or 0, to or -1)
end

return M
