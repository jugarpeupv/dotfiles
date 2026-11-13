--- Async git status for lualine, backed by the `gitmux` binary.
---
--- The status line is rendered by gitmux itself, using the same config as the
--- tmux status bar, so symbols, colours, divergence and flags match tmux
--- exactly.  gitmux runs in a background job (never on the UI thread) and the
--- result is cached per working directory, refreshed on common events and at
--- most every `ttl` milliseconds.
---
--- Usage:
---   require("jg.custom.gitmux").setup({ ... })  -- optional
---   -- in a lualine section:
---   function() return require("jg.custom.gitmux").get() end

local uv = vim.uv or vim.loop

local M = {}

local defaults = {
  binary = "gitmux",
  config = vim.fn.expand("~/.config/tmux/gitmux.conf"),
  -- Passed to gitmux so a slow/hung git call can never pile up jobs.
  timeout = "2s",
  -- Refresh the cached status at most this often (ms). 0 = only on events.
  -- tmux uses `status-interval 1` (1s), so keep this just below lualine's 1s
  -- statusline refresh to match tmux's update latency.
  ttl = 900,
  -- tmux colour names -> colours used for the generated highlight groups.
  -- Hex values and `colourN` values from gitmux.conf are used as-is.
  colors = {
    black = "#000000",
    red = "#F38BA8",
    green = "#94E2D5",
    yellow = "#F9E2AF",
    blue = "#b4beff",
    magenta = "#CBA6F7",
    cyan = "#99ecfd",
    white = "#CAD3F5",
    default = nil,
  },
}

local opts = vim.deepcopy(defaults)

local state = {
  cwd = nil, -- cwd the cached value belongs to
  value = "", -- rendered statusline string
  dirty = true,
  job = nil, -- in-flight vim.system handle
  job_cwd = nil,
  last_run = 0, -- uv.now() of the last completed run
  styles = {}, -- tmux style string -> highlight group
  style_id = 0,
}

---@param value string|nil
---@return string|integer|nil
local function resolve_color(value)
  if not value or value == "default" then
    return nil
  end
  if value:match("^#%x%x%x%x%x%x$") or value:match("^#%x%x%x$") then
    return value
  end
  if opts.colors[value] then
    return opts.colors[value]
  end
  if value:match("^colour%d+$") then
    return nil
  end
  -- Fall back to Neovim's named colours (e.g. "brightred").
  local ok, color = pcall(vim.api.nvim_get_color_by_name, value)
  if ok and color and color >= 0 then
    return color
  end
  return nil
end

---Turn a tmux style string (`fg=blue,nobold`) into a highlight group.
---@param style string
---@return string
local function hl_for_style(style)
  local cached = state.styles[style]
  if cached then
    return cached
  end

  local hl = {}
  for attr in style:gmatch("[^,]+") do
    local key, value = attr:match("^([%w_]+)=(.*)$")
    if key == "fg" then
      hl.fg = resolve_color(value)
    elseif key == "bg" then
      hl.bg = resolve_color(value)
    elseif attr == "bold" then
      hl.bold = true
    elseif attr == "dim" then
      hl.dim = true
    elseif attr == "italics" then
      hl.italic = true
    elseif attr == "underscore" then
      hl.underline = true
    elseif attr == "reverse" then
      hl.reverse = true
    end
  end

  state.style_id = state.style_id + 1
  local group = ("JgGitmux%d"):format(state.style_id)
  vim.api.nvim_set_hl(0, group, hl)
  state.styles[style] = group
  return group
end

---Convert gitmux's tmux format string into a statusline string with inline
---highlight groups, preserving the exact text/layout produced by gitmux.
---@param output string|nil
---@return string
local function render(output)
  if not output or output == "" then
    return ""
  end

  local parts = {}
  local style = nil
  local i = 1
  local len = #output

  while i <= len do
    local start, finish, new_style = output:find("#%[(.-)%]", i)
    local text = start and output:sub(i, start - 1) or output:sub(i)

    if text ~= "" then
      -- tmux escapes a literal '#' as '##'; '%' must be escaped for the
      -- statusline to not interpret it as a statusline item.
      text = text:gsub("##", "#"):gsub("%%", "%%%%")
      local is_reset = style == nil
        or style == "none"
        or style == "default"
        or style == "fg=default"
        or style == "fg=default,bg=default"
      if is_reset then
        parts[#parts + 1] = text
      else
        parts[#parts + 1] = "%#" .. hl_for_style(style) .. "#" .. text
      end
    end

    if not start then
      break
    end
    style = new_style
    i = finish + 1
  end

  return table.concat(parts)
end

local function config_exists()
  local stat = uv.fs_stat(opts.config)
  return stat ~= nil and stat.type == "file"
end

---@param cwd string
---@return string[]
local function command(cwd)
  local cmd = { opts.binary }
  if opts.config and config_exists() then
    vim.list_extend(cmd, { "-cfg", opts.config })
  end
  if opts.timeout and opts.timeout ~= "" then
    vim.list_extend(cmd, { "-timeout", opts.timeout })
  end
  cmd[#cmd + 1] = cwd
  return cmd
end

---@param cwd string
local function start_job(cwd)
  if state.job then
    return
  end
  state.job_cwd = cwd

  local ok, job = pcall(vim.system, command(cwd), { text = true, cwd = cwd }, function(result)
    -- vim.system callbacks run in a fast event context.
    vim.schedule(function()
      local finished_cwd = state.job_cwd
      state.job = nil
      state.job_cwd = nil
      state.last_run = uv.now()

      if finished_cwd then
        state.cwd = finished_cwd
        if result.code == 0 and result.stdout then
          state.value = render(result.stdout)
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

---Force the next `get()` to recompute the status.
function M.invalidate()
  state.dirty = true
  vim.schedule(function()
    pcall(vim.cmd, "redrawstatus!")
  end)
end

---Value for the current lualine component. Never blocks: the first call for a
---directory starts a background job and returns "", later calls return the
---cached status while a refresh may be running.
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
  state.styles = {}
  state.style_id = 0
  state.dirty = true

  local group = vim.api.nvim_create_augroup("JgGitmux", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWritePost", "FocusGained", "ShellCmdPost", "DirChanged" }, {
    group = group,
    callback = M.invalidate,
    desc = "Refresh async gitmux status",
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
