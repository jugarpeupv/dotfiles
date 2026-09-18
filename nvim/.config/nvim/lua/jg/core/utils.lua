local M = {}

function M.opencode_snapshot_picker()
  local snap_git_dir = require("opencode.config_file").get_workspace_snapshot_path():wait()
  if not snap_git_dir or snap_git_dir == "" then
    vim.notify("No opencode snapshot path for this workspace", vim.log.levels.ERROR)
    return
  end

  local state = require("opencode.state")
  if not state.active_session then
    vim.notify("No active opencode session", vim.log.levels.WARN)
    return
  end

  local session = require("opencode.session")
  local seen = {}
  local items = {}

  for _, msg in ipairs(state.messages or {}) do
    local snapshots = session.get_message_snapshot_ids(msg)
    if snapshots then
      local created = msg.info and msg.info.time and msg.info.time.created
      if created and created > 1e10 then
        created = created / 1000
      end
      local time_str = created and os.date("%Y-%m-%d %H:%M:%S", created) or "?"
      local role = (msg.info and msg.info.role) or "unknown"
      for _, hash in ipairs(snapshots) do
        if not seen[hash] then
          seen[hash] = true
          local r = vim.system({
            "git",
            "--git-dir",
            snap_git_dir,
            "cat-file",
            "-t",
            hash,
          }, { text = true }):wait()
          if r.code == 0 then
            table.insert(items, {
              hash = hash,
              time = created or 0,
              time_str = time_str,
              role = role,
              display = string.format("%s  %s  %s", hash:sub(1, 8), time_str, role),
            })
          end
        end
      end
    end
  end

  if #items == 0 then
    vim.notify("No valid snapshots found", vim.log.levels.WARN)
    return
  end

  table.sort(items, function(a, b)
    return a.time > b.time
  end)

  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values

  pickers
    .new({}, {
      prompt_title = "Snapshots",
      finder = finders.new_table({
        results = items,
        entry_maker = function(item)
          return {
            value = item,
            display = item.display,
            ordinal = item.time_str .. " " .. item.hash,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection then
            local cmd = 'DiffviewOpen "-C=' .. snap_git_dir .. '"' .. " " .. selection.value.hash
            print("cmd: ", cmd)
            vim.cmd(cmd)
          end
        end)
        return true
      end,
    })
    :find()
end


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
