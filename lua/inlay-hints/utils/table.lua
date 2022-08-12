local M = {}

---Retrive all the keys in a table
---@generic T
---@param t table<T, any>
---@return T[]
function M.get_keys(t)
  local ret = {}

  for k, _ in pairs(t) do
    table.insert(ret, k)
  end

  return ret
end

return M
