-- vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.loaded_matchit = 1
vim.g.python3_host_prog = vim.fn.expand("~/.nvim-venv/bin/python3")

-- if vim.env.TERM == "xterm-kitty" then
-- 	-- request csi mode 2
-- 	vim.cmd([[autocmd UIEnter * call chansend(v:stderr, "\x1b[>4;2m")]])
-- 	vim.cmd([[autocmd VimLeavePre * call chansend(v:stderr, "\x1b[>4;0m")]])
-- end

-- if vim.env.TERM == "xterm-kitty" then
--   vim.api.nvim_chan_send(vim.api.nvim_get_chan(), "\27[>4;2m")
-- end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("jg.core.options")

if vim.env.DEBUG then
	vim.opt.rtp:prepend(".lazy/plugins/one-small-step-for-vimkind")
	require("osv").launch({ port = 8086, blocking = true })
end

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
		require("jg.core.autocommands")
		require("jg.core.keymaps")
	end,
})

vim.cmd("source /Users/jgarcia/.config/nvim/lua/jg/custom/proguard.vim")
