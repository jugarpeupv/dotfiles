return {
	"ibhagwan/fzf-lua",
  enabled = false,
	dependencies = {
		"folke/snacks.nvim",
		{
			"elanmed/fzf-lua-frecency.nvim",
			config = function()
				require("fzf-lua-frecency").setup({
					debug = false,
					db_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "fzf-lua-frecency"),
					-- Display files from the cwd only
					cwd_only = true,
					-- Populate non-scored files in cwd?
					-- defaults to `true` if `cwd_only=true`, else `false`
					all_files = true,
					-- Test for a scored file's existence in the file system before displaying it in the picker
					stat_file = false,
					-- Prefix the fzf entry with its frecency score
					display_score = true,
				})
			end,
		},
	},
	cmd = {
		"FzfLua",
		"FzfLuaFiles",
		"FzfLuaBuffers",
		"FzfLuaGrep",
		"FzfLuaLiveGrep",
		"FzfLuaOldfiles",
	},
	opts = {
		keymap = {
			fzf = {
				true,
				-- Use <c-q> to select all items and add them to the quickfix list
				["ctrl-q"] = "select+accept",
			},
		},
		winopts = {
			-- Use **only one** of the below options
			-- split = "aboveleft new"   -- open in split above current window
			-- split = "belowright new"  -- open in split below current window
			-- split = "aboveleft vnew"  -- open in split left of current window
			-- split = "belowright vnew" -- open in split right of current window
			-- split = "topleft new"   -- open in a full-width split on top
			split = "botright new", -- open in a full-width split on the bottom
			-- split = "topleft vnew"  -- open in a full-height split on the far left
			-- split = "botright vnew" -- open in a full-height split on the far right
			preview = {
				-- default     = 'bat',           -- override the default previewer?
				-- default uses the 'builtin' previewer
				border = "rounded", -- preview border: accepts both `nvim_open_win`
				-- and fzf values (e.g. "border-top", "none")
				-- native fzf previewers (bat/cat/git/etc)
				-- can also be set to `fun(winopts, metadata)`
				wrap = false, -- preview line wrap (fzf's 'wrap|nowrap')
				hidden = false, -- start preview hidden
				vertical = "down:45%", -- up|down:size
				horizontal = "right:30%", -- right|left:size
				layout = "flex", -- horizontal|vertical|flex
				flip_columns = 100, -- #cols to switch to horizontal on flex
				-- Only used with the builtin previewer:
				title = true, -- preview border title (file/buf)?
				title_pos = "center", -- left|center|right, title alignment
				scrollbar = "float", -- `false` or string:'float|border'
				-- float:  in-window floating border
				-- border: in-border "block" marker
				scrolloff = -1, -- float scrollbar offset from right
				-- applies only when scrollbar = 'float'
				delay = 20, -- delay(ms) displaying the preview
				-- prevents lag on fast scrolling
				winopts = { -- builtin previewer window options
					number = true,
					relativenumber = false,
					cursorline = true,
					cursorlineopt = "both",
					cursorcolumn = false,
					signcolumn = "no",
					list = false,
					foldenable = false,
					foldmethod = "manual",
				},
			},
		},
		oldfiles = {
			-- In Telescope, when I used <leader>fr, it would load old buffers.
			-- fzf lua does the same, but by default buffers visited in the current
			-- session are not included. I use <leader>fr all the time to switch
			-- back to buffers I was just in. If you missed this from Telescope,
			-- give it a try.
			include_current_session = true,
		},
		previewers = {
			builtin = {
				-- fzf-lua is very fast, but it really struggled to preview a couple files
				-- in a repo. Those files were very big JavaScript files (1MB, minified, all on a single line).
				-- It turns out it was Treesitter having trouble parsing the files.
				-- With this change, the previewer will not add syntax highlighting to files larger than 100KB
				-- (Yes, I know you shouldn't have 100KB minified files in source control.)
				syntax_limit_b = 1024 * 100, -- 100KB
			},
		},
		grep = {
			-- One thing I missed from Telescope was the ability to live_grep and the
			-- run a filter on the filenames.
			-- Ex: Find all occurrences of "enable" but only in the "plugins" directory.
			-- With this change, I can sort of get the same behaviour in live_grep.
			-- ex: > enable --*/plugins/*
			-- I still find this a bit cumbersome. There's probably a better way of doing this.
			rg_glob = true, -- enable glob parsing
			glob_flag = "--iglob", -- case insensitive globs
			glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
		},
	},
}
