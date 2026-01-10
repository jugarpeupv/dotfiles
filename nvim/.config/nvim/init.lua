vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.loaded_matchit = 1
-- vim.g.python3_host_prog = vim.fn.expand("~/.nvim-venv/bin/python3")

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


-- require("jg.core.autocommands")
-- require("jg.core.keymaps")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		-- require("config.autocmds")
		-- require("config.keymaps")
		-- require("jg.core.autocommands")
		require("jg.core.autocommands")
		require("jg.core.keymaps")
	end,
})

-- vim.cmd("source /Users/jgarcia/.config/nvim/lua/jg/custom/proguard.vim")

-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	group = vim.api.nvim_create_augroup("vim-enter-worktree-group", { clear = true }),
-- 	callback = function()
-- 		if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 then
-- 			return
-- 		end
--
-- 		if vim.list_contains(vim.v.argv, "-R") then
-- 			return
-- 		end
--
-- 		vim.schedule(function()
-- 			local cwd = vim.loop.cwd()
-- 			if not cwd or cwd == "" then
-- 				return
-- 			end
--
-- 			local has_wt_utils, wt_utils = pcall(require, "jg.custom.worktree-utils")
-- 			if not has_wt_utils or not wt_utils.has_worktrees(cwd) then
-- 				return
-- 			end
--
-- 			local has_file_utils, file_utils = pcall(require, "jg.custom.file-utils")
-- 			if not has_file_utils then
-- 				return
-- 			end
--
-- 			local key = vim.fn.fnamemodify(cwd, ":p")
-- 			local bps_path = file_utils.get_bps_path(key)
-- 			local data = file_utils.load_bps(bps_path)
--
-- 			local function open_fyler(dir)
-- 				local ok, fyler = pcall(require, "fyler")
-- 				if ok then
-- 					fyler.open({ dir = dir })
-- 				else
-- 					pcall(vim.cmd, "Fyler")
-- 				end
-- 			end
--
-- 			if not data or next(data) == nil or not data.last_active_wt then
-- 				-- open_fyler(cwd)
-- 				require("oil").open(cwd)
-- 				return
-- 			end
--
-- 			local last_active_wt = data.last_active_wt
-- 			local escaped = vim.fn.fnameescape(last_active_wt)
-- 			-- vim.cmd(("Explore %s"):format(escaped))
--
-- 			vim.cmd(("cd %s"):format(escaped))
-- 			-- open_fyler(last_active_wt)
-- 			-- require("oil").open(last_active_wt)
-- 			local api_nvimtree = require("nvim-tree.api")
-- 			api_nvimtree.tree.change_root(last_active_wt)
-- 		end)
-- 	end,
-- })


local function should_restore_worktree()
	if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 then
		return false
	end
	if vim.list_contains(vim.v.argv, "-R") then
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
		vim.schedule(function()
			require("oil").open(cwd)
      -- require("fyler").open(cwd)
		end)
		return
	end
	local last_active_wt = data.last_active_wt
	vim.schedule(function()
		vim.cmd.cd(last_active_wt)
		require("oil").open(last_active_wt)
    -- require("fyler").open(last_active_wt)
	end)
end

if should_restore_worktree() then
	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		once = true,
		callback = restore_last_worktree,
	})
end
