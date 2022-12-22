local M = {}

---Return current bufnr if given bufnr is 0 or nil otherwise given bufnr
---@param bufnr number
---@return number
function M.parse_buf(bufnr)
    if bufnr == 0 or bufnr == nil then
        return vim.api.nvim_get_current_buf()
    end

    return bufnr
end

return M
