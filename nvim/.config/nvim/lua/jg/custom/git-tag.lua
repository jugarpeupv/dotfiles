--- Async tag name for lualine.
---
--- Mirrors the tmux status-left snippet:
---   if cd <cwd> && git rev-parse --abbrev-ref --symbolic-full-name HEAD | grep -q HEAD
---   then echo " 🏷 $(git describe --tags)"; fi
---
--- i.e. show the tag only when HEAD is detached (as it is after checking out a
--- tag).  The git commands run in a background job, never on the UI thread,
--- and the result is cached per working directory.
---
--- Usage:
---   require("jg.custom.git-tag").setup({ ... })  -- optional
---   -- in a lualine section, before the branch/gitmux component:
---   function() return require("jg.custom.git-tag").get() end

local uv = vim.uv or vim.loop

local M = {}

local defaults = {
  -- Refresh the cached tag at most this often (ms). 0 = only on events.
  ttl = 650,
  icon = "🏷 ",
  script = table.concat({
    'branch=$(git rev-parse --abbrev-ref --symbolic-full-name HEAD 2>/dev/null) || exit 0',
    'if [ "$branch" = "HEAD" ]; then',
    '  git describe --tags 2>/dev/null',
    'fi',
  }, "\n"),
}

local opts = vim.deepcopy(defaults)

local state = {
  cwd = nil, -- cwd the cached value belongs to
  value = "", -- rendered tag (with icon) or ""
  dirty = true,
  job = nil, -- in-flight vim.system handle
  job_cwd = nil,
  last_run = 0, -- uv.now() of the last completed run
}

---@param cwd string
local function start_job(cwd)
  if state.job then
    return
  end
  state.job_cwd = cwd

  local cmd = { "/bin/sh", "-c", opts.script }
  local ok, job = pcall(vim.system, cmd, { text = true, cwd = cwd }, function(result)
    -- vim.system callbacks run in a fast event context.
    vim.schedule(function()
      local finished_cwd = state.job_cwd
      state.job = nil
      state.job_cwd = nil
      state.last_run = uv.now()

      if finished_cwd then
        state.cwd = finished_cwd
        local tag = result.code == 0 and result.stdout and vim.trim(result.stdout) or ""
        if tag ~= "" then
          -- lualine function components don't escape statusline markers.
          state.value = (opts.icon .. tag):gsub("%%", "%%%%")
        else
          state.value = ""
        end
        state.dirty = false
      end

      pcall(vim.cmd, "redrawstatus!")
    end)
  end)

  if not ok or not job then
    state.job = nil
    state.job_cwd = nil
    state.cwd = cwd
    state.value = ""
    state.dirty = false
    state.last_run = uv.now()
    return
  end

  state.job = job
end

---Force the next `get()` to recompute the tag.
function M.invalidate()
  state.dirty = true
  vim.schedule(function()
    pcall(vim.cmd, "redrawstatus!")
  end)
end

---Value for the current lualine component. Never blocks: the first call for a
---directory starts a background job and returns "", later calls return the
---cached tag while a refresh may be running.
---@return string
function M.get()
  local cwd = vim.fn.getcwd()

  if state.cwd ~= cwd then
    if not state.job then
      start_job(cwd)
    end
    return ""
  end

  local stale = state.dirty
  if not stale and opts.ttl and opts.ttl > 0 then
    stale = (uv.now() - state.last_run) >= opts.ttl
  end
  if stale and not state.job then
    start_job(cwd)
  end

  return state.value
end

---@param user_opts table|nil
function M.setup(user_opts)
  opts = vim.tbl_deep_extend("force", vim.deepcopy(defaults), user_opts or {})
  state.dirty = true

  local group = vim.api.nvim_create_augroup("JgGitTag", { clear = true })
  vim.api.nvim_create_autocmd({ "FocusGained", "ShellCmdPost", "DirChanged" }, {
    group = group,
    callback = M.invalidate,
    desc = "Refresh async git tag",
  })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      if state.job then
        pcall(state.job.kill, state.job, 9)
      end
    end,
  })
end

return M
