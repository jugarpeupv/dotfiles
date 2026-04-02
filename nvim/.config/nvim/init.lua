vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.loaded_matchit = 1
-- vim.g.python3_host_prog = vim.fn.expand("~/.nvim-venv/bin/python3")

-- if vim.fn.has("nvim-0.12") == 1 then
--   require("vim._core.ui2").enable({
--     enable = true,           -- set false to detach/disable ui2
--   })
-- end

if vim.env.TERM == "xterm-kitty" then
	-- request csi mode 2
	vim.cmd([[autocmd UIEnter * call chansend(v:stderr, "\x1b[>4;2m")]])
	vim.cmd([[autocmd VimLeavePre * call chansend(v:stderr, "\x1b[>4;0m")]])
end

-- if vim.env.TERM == "xterm-kitty" then
--   vim.api.nvim_chan_send(vim.api.nvim_get_chan(), "\27[>4;2m")
-- end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

if vim.env.DEBUG then
	vim.opt.rtp:prepend(".lazy/plugins/one-small-step-for-vimkind")
	require("osv").launch({ port = 8086, blocking = true })
end

require("jg.core.options")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", {
	-- require("lazy").setup({}, {
	defaults = {
		lazy = true,
		version = false,
	},
	change_detection = { notify = false },

	-- rocks = { enabled = false },
	rocks = {
		hererocks = true, -- recommended if you do not have global installation of Lua 5.1.
	},
	-- rocks = {  enabled = true, hererocks = nil },
	dev = {
		path = "~/projects",
		patterns = {},
		fallback = true,
	},
	ui = {
		backdrop = 100,
		border = "rounded",
		icons = {
			ft = "",
			lazy = "󰂠 ",
			loaded = "",
			not_loaded = "",
		},
	},

	performance = {
		cache = {
			enabled = true,
			path = vim.fn.stdpath("state") .. "/lazy/cache",
		},
		rtp = {

			disabled_plugins = {
				"2html_plugin",
				"tohtml",
				"getscript",
				"getscriptPlugin",
				"gzip",
				"logipat",
				"netrw",
				"netrwPlugin",
				"netrwSettings",
				"netrwFileHandlers",
				"matchit",
				"tar",
				"tarPlugin",
				"rrhelper",
				"spellfile_plugin",
				"vimball",
				"vimballPlugin",
				"zip",
				"zipPlugin",
				"tutor",
				"rplugin",
				"syntax",
				"synmenu",
				"optwin",
				"compiler",
				"bugreport",
				"ftplugin",
			},
		},
	},
})

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("jg.core.autocommands")
		require("jg.core.keymaps")
	end,
})

local function should_restore_session()
	-- Returns true when nvim is opened without a specific readable file argument.
	-- Mirrors the guard in utilities.lua persistence init.
	local argc = vim.fn.argc()
	local arg = argc == 1 and tostring(vim.fn.argv(0)) or ""
	local is_file = arg ~= "" and vim.fn.isdirectory(arg) == 0 and vim.fn.filereadable(arg) == 1
	return not is_file
end

local function should_restore_worktree()
	if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 then
		return false
	end
	if vim.list_contains(vim.v.argv, "-R") then
		return false
	end

	if not vim.list_contains(vim.v.argv, ".") then
		return false
	end

	-- C-x C-e
	-- { "nvim", "--embed", "-c", "normal! 19go", "--", "/tmp/zshBXRabd.zsh" }
	if vim.list_contains(vim.v.argv, "--") then
		return false
	end

	local cwd = vim.loop.cwd()
	if not cwd or cwd == "" then
		return false
	end
	local has_wt_utils, wt_utils = pcall(require, "jg.custom.worktree-utils")
	if not has_wt_utils or not wt_utils.has_worktrees(cwd) then
		return false
	end
	return true
end

local function find_buffer_by_path(target_path)
	-- Normalize the target path
	local normalized = vim.fn.fnamemodify(target_path, ":p")

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		-- Only consider loaded/valid buffers
		if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			if vim.fn.fnamemodify(bufname, ":p") == normalized then
				return bufnr
			end
		end
	end

	return nil
end

local function restore_last_worktree()
	local cwd = vim.loop.cwd()
	if not cwd then
		return
	end
	local has_file_utils, file_utils = pcall(require, "jg.custom.file-utils")
	if not has_file_utils then
		return
	end
	local key = vim.fn.fnamemodify(cwd, ":p")
	local bps_path = file_utils.get_bps_path(key)
	local data = file_utils.load_bps(bps_path)
	if not data or next(data) == nil or not data.last_active_wt then
		-- require("oil").open(cwd)
    print('No worktree data, opening cwd in fyler')

    require("fyler").open({ dir = cwd })

    local cwd_buffer_nr = find_buffer_by_path(vim.loop.cwd():gsub("/$", ""))
    local win = vim.fn.bufwinid(cwd_buffer_nr)
    if win ~= -1 and #vim.api.nvim_tabpage_list_wins(0) > 1 then
      vim.api.nvim_win_close(win, true)
    end
    -- Then wipe the buffer
    if not cwd_buffer_nr then
      return
    end
    pcall(vim.api.nvim_buf_delete, cwd_buffer_nr, { force = true })

		return
	end
	local last_active_wt = data.last_active_wt

	-- vim.cmd("bwipeout " .. cwd_buffer_nr)
	pcall(vim.cmd.cd, last_active_wt)

	-- require("oil").open(last_active_wt)
	require("fyler").open({ dir = last_active_wt, kind = "replace" })
	-- pcall(require("fyler").open, { dir = last_active_wt })
  local cwd_buffer_nr = find_buffer_by_path(vim.loop.cwd():gsub("/$", ""))
  if not cwd_buffer_nr then
    return
  end
	local win = vim.fn.bufwinid(cwd_buffer_nr)
	if win ~= -1 and #vim.api.nvim_tabpage_list_wins(0) > 1 then
		vim.api.nvim_win_close(win, true)
	end
	-- Then wipe the buffer
	pcall(vim.api.nvim_buf_delete, cwd_buffer_nr, { force = true })
  -- pcall(vim.api.nvim_buf_delete, cwd_buffer_nr)
	-- vim.api.nvim_buf_delete(cwd_buffer_nr, { force = true })
end

-- if should_restore_worktree() then
-- 	restore_last_worktree()
-- end

-- Load the persistence session after any worktree cd has settled.
-- We schedule so that lazy.nvim has finished its setup and persistence is available.
-- if false and should_restore_session() then
-- 	vim.schedule(function()
-- 		require("persistence").load()
-- 	end)
-- end

if should_restore_worktree() then
	restore_last_worktree()
	-- vim.api.nvim_create_autocmd("User", {
	-- 	pattern = "VeryLazy",
	-- 	once = true,
	-- 	callback = restore_last_worktree,
	-- })
else
	vim.schedule(function()
		local path = vim.v.argv[3]
		if not path then
			return
		end

		if vim.fn.isdirectory(path) == 1 then
			local fyler = require("fyler")
			-- fyler.open({ dir = path, kind = "replace" })
			fyler.open({ dir = path })
			local cwd_buffer_nr = find_buffer_by_path(vim.loop.cwd():gsub("/$", ""))
			local win = vim.fn.bufwinid(cwd_buffer_nr)
			if win ~= -1 then
				vim.api.nvim_win_close(win, true)
			end
			-- Then wipe the buffer
			if not cwd_buffer_nr then
				return
			end
			vim.api.nvim_buf_delete(cwd_buffer_nr, { force = true })
		else
			return
		end
	end)
end
