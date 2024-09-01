local M = {}

---Ensure that the table path is a table in `t`.
---@param t table
---@param table_path string|string[] Either a `.` separated string of table keys, or a list.
function M.tbl_ensure(t, table_path)
  local keys = type(table_path) == "table"
  and table_path
  or vim.split(table_path, ".", { plain = true })

  if not M.tbl_access(t, keys) then
    M.tbl_set(t, keys, {})
  end
end

---Try property access.
---@param t table
---@param table_path string|string[] Either a `.` separated string of table keys, or a list.
---@return any?
function M.tbl_access(t, table_path)
  local keys = type(table_path) == "table"
  and table_path
  or vim.split(table_path, ".", { plain = true })

  local cur = t

  for _, k in ipairs(keys) do
    cur = cur[k]
    if not cur then
      return nil
    end
  end

  return cur
end

---Set a value in a table, creating all missing intermediate tables in the
---table path.
---@param t table
---@param table_path string|string[] Either a `.` separated string of table keys, or a list.
---@param value any
function M.tbl_set(t, table_path, value)
  local keys = type(table_path) == "table"
  and table_path
  or vim.split(table_path, ".", { plain = true })

  local cur = t

  for i = 1, #keys - 1 do
    local k = keys[i]

    if not cur[k] then
      cur[k] = {}
    end

    cur = cur[k]
  end

  cur[keys[#keys]] = value
end

function M.tbl_clone(t)
  local clone = {}

  for k, v in pairs(t) do
    clone[k] = v
  end

  return clone
end

---Get the result of the union of the given vectors.
---@param ... vector
---@return vector
function M.vec_union(...)
  local result = {}
  local args = {...}
  local seen = {}

  for i = 1, select("#", ...) do
    if type(args[i]) ~= "nil" then
      if type(args[i]) ~= "table" and not seen[args[i]] then
        seen[args[i]] = true
        result[#result+1] = args[i]
      else
        for _, v in ipairs(args[i]) do
          if not seen[v] then
            seen[v] = true
            result[#result+1] = v
          end
        end
      end
    end
  end

  return result
end

---Deep extend a table, and also perform a union on all sub-tables.
---@param t table
---@param ... table
---@return table
function M.tbl_union_extend(t, ...)
  local res = M.tbl_clone(t)

  local function recurse(ours, theirs)
    -- Get the union of the two tables
    local sub = M.vec_union(ours, theirs)

    for k, v in pairs(ours) do
      if type(k) ~= "number" then
        sub[k] = v
      end
    end

    for k, v in pairs(theirs) do
      if type(k) ~= "number" then
        if type(v) == "table" then
          sub[k] = recurse(sub[k] or {}, v)
        else
          sub[k] = v
        end
      end
    end

    return sub
  end

  for _, theirs in ipairs({ ... }) do
    res = recurse(res, theirs)
  end

  return res
end

return M
