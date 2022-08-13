---@class Cache
---@field cache table<any, any>
local Cache = {}

---Create a new cache object
---@return Cache
function Cache:new()
  return setmetatable({ cache = {} }, { __index = Cache })
end

---Set or update the cached value
---@param key any
---@param value any
function Cache:set(key, value)
  if key == nil then
    error("Key can't be null")
  end
  self.cache[key] = value
end

---Get a cached value
---@param key any
---@return any
function Cache:get(key)
  if key == nil then
    error("Key can't be null")
  end
  return self.cache[key]
end

---Get all the cached values
---@return table<any, any>
function Cache:get_all()
  return self.cache
end

---Delete a cached value
---@param key any
function Cache:del(key)
  self.cache[key] = nil
end

return Cache
