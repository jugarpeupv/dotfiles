return {
	{
		"esmuellert/vscode-diff.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
    enabled = false,
		cmd = "CodeDiff",
		config = function()
			require("vscode-diff").setup({
				-- Diff view behavior
				diff = {
					disable_inlay_hints = true, -- Disable inlay hints in diff windows for cleaner view
					max_computation_time_ms = 5000, -- Maximum time for diff computation (VSCode default)
				},

				-- Explorer panel configuration
				explorer = {
					position = "left", -- "left" or "bottom"
					width = 35, -- Width when position is "left" (columns)
					height = 15, -- Height when position is "bottom" (lines)
					indent_markers = true, -- Show indent markers in tree view (│, ├, └)
					icons = {
						folder_closed = "", -- Nerd Font folder icon (customize as needed)
						folder_open = "", -- Nerd Font folder-open icon
					},
					view_mode = "tree", -- "list" or "tree"
					file_filter = {
						ignore = {}, -- Glob patterns to hide (e.g., {"*.lock", "dist/*"})
					},
				},

				-- Keymaps in diff view
				keymaps = {
					view = {
						quit = "q", -- Close diff tab
						toggle_explorer = "<leader>b", -- Toggle explorer visibility (explorer mode only)
						next_hunk = "]c", -- Jump to next change
						prev_hunk = "[c", -- Jump to previous change
						next_file = "<tab>", -- Next file in explorer mode
						prev_file = "<s-tab>", -- Previous file in explorer mode
						diff_get = "do", -- Get change from other buffer (like vimdiff)
						diff_put = "dp", -- Put change to other buffer (like vimdiff)
					},
					explorer = {
						select = "<CR>", -- Open diff for selected file
						hover = "K", -- Show file diff preview
						refresh = "R", -- Refresh git status
						toggle_view_mode = "i", -- Toggle between 'list' and 'tree' views
					},
				},
			})
		end,
	},
	{
		"https://codeberg.org/trevorhauter/gitportal.nvim",
		enabled = false,
		lazy = false,
		opts = {},
		-- keys = {
		-- 	{ mode = { "n" }, "<leader>ol", require("gitportal").open_file_in_browser() },
		-- 	{ mode = { "n" }, "<leader>oL", require("gitportal").open_file_in_neovim() },
		-- 	{ mode = { "n" }, "<leader>oy", require("gitportal").copy_link_to_clipboard() },
		-- },
	},
	{
		"akinsho/git-conflict.nvim",
		dependencies = { "sindrets/diffview.nvim" },
		lazy = true,
		branch = "main",

		config = function()
			require("git-conflict").setup({
				default_mappings = false,
				list_opener = "copen",
				debug = false,
				disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
				highlights = {
					incoming = "DiffText",
					current = "DiffAdd",
				},
			})
		end,
	},
	{
		"NeogitOrg/neogit",
		enabled = false,
		cmd = { "Neogit" },
		keys = {
			{
				"<leader>ni",
				"<cmd>Neogit<cr>",
			},
		},
		dependencies = {
			"junegunn/fzf",
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration
			-- Only one of these is needed.
			"nvim-telescope/telescope.nvim", -- optional
			-- "ibhagwan/fzf-lua",           -- optional
			-- "echasnovski/mini.pick",      -- optional
		},
		config = function()
			local neogit = require("neogit")
			neogit.setup({
				kind = "replace",
				graph_style = "kitty",
				process_spinner = true,
				integrations = {
					diffview = true,
				},
			})
		end,
	},
	{
		"sindrets/diffview.nvim",
		-- event = "VeryLazy",
		cmd = { "DiffviewOpen" },
		-- event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"junegunn/fzf",
			"nvim-telescope/telescope.nvim",
			"akinsho/git-conflict.nvim",
		},
		keys = {
			{ "<leader>gd", mode = "n", "<cmd>DiffviewOpen<cr>" },
			-- { "<leader>gd", mode = "n", "<cmd>DiffviewOpen -- :!package-lock.json<cr>" },
			{ "<leader>cc", mode = "n", "<cmd>DiffviewClose<cr>" },
			{ "<leader>gv", mode = { "v" }, ":<C-u>'<,'>DiffviewFileHistory<CR>" },
			{ "<leader>gv", mode = { "n" }, "<cmd>DiffviewFileHistory %<cr>" },
			{ "<leader>ll", mode = "n", "<CMD>DiffviewFileHistory --range=HEAD<CR>" },
			{ "<leader>l5", mode = "n", "<CMD>DiffviewFileHistory --range=HEAD~50..HEAD<CR>" },
			{ "<leader>l0", mode = "n", "<CMD>DiffviewFileHistory --range=HEAD~10..HEAD<CR>" },
		},
		config = function()
			-- vim.cmd([[hi StatusLine guifg=#cdd6f5 guibg=#292e42]])
			-- Lua
			local actions = require("diffview.actions")

			require("diffview").setup({
				diff_binaries = false, -- Show diffs for binaries
				enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
				git_cmd = { "git" }, -- The git executable followed by default args.
				use_icons = true, -- Requires nvim-web-devicons
				watch_index = true, -- Update views and index buffers when the git index changes.
				icons = { -- Only applies when use_icons is true.
					folder_closed = "",
					folder_open = "",
				},
				signs = {
					-- fold_closed = "",
					-- fold_open = "",
					done = "✓",
					folder_closed = "",
					folder_open = "",
					-- folder_closed = "",
					-- folder_open = "",
				},
				view = {
					default = {
						layout = "diff2_horizontal",
					},
					merge_tool = {
						layout = "diff1_plain",
						disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
					},
					file_history = {
						-- Config for changed files in file history views.
						layout = "diff2_horizontal",
					},
				},
				file_panel = {
					listing_style = "tree", -- One of 'list' or 'tree'
					tree_options = { -- Only applies when listing_style is 'tree'
						flatten_dirs = true, -- Flatten dirs that only contain one single dir
						folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
					},
					-- win_config = {                      -- See ':h diffview-config-win_config'
					--   position = "left",
					--   width = 35,
					--   win_opts = {}
					-- },
					win_config = { -- See ':h diffview-config-win_config'
						position = "left",
						-- height = 7,
						win_opts = {},
					},
				},
				file_history_panel = {
					win_config = { -- See ':h diffview-config-win_config'
						position = "bottom",
						height = 16,
						win_opts = {},
					},
				},
				commit_log_panel = {
					win_config = { -- See ':h diffview-config-win_config'
						win_opts = {},
					},
				},
				default_args = { -- Default args prepended to the arg-list for the listed commands
					DiffviewOpen = {},
					DiffviewFileHistory = {},
				},
				hooks = {
					diff_buf_read = function()
						vim.opt_local.wrap = false
					end,
					---@param view StandardView
					view_opened = function(view)
						local utils = require("jg.core.utils")
						require("barbecue.ui").toggle(false)
						require("treesitter-context").disable()
						local function post_layout()
							utils.tbl_ensure(view, "winopts.diff2.a")
							utils.tbl_ensure(view, "winopts.diff2.b")
							-- left
							view.winopts.diff2.a = utils.tbl_union_extend(view.winopts.diff2.a, {
								winhl = {
									"DiffChange:DiffAddAsDelete",
									"DiffText:DiffDeleteText",
								},
							})
							-- right
							view.winopts.diff2.b = utils.tbl_union_extend(view.winopts.diff2.b, {
								winhl = {
									"DiffChange:DiffAdd",
									"DiffText:DiffAddText",
								},
							})
						end
						vim.cmd("hi DiffviewDiffAddAsDelete guifg=none")
						view.emitter:on("post_layout", post_layout)
						post_layout()
					end,
					view_closed = function()
						require("barbecue.ui").toggle(true)
						require("treesitter-context").enable()
					end,
				}, -- See ':h diffview-config-hooks'
				keymaps = {
					disable_defaults = true, -- Disable the default keymaps
					view = {
						-- The `view` bindings are active in the diff buffers, only when the current
						-- tabpage is a Diffview.
						["<tab>"] = actions.select_next_entry, -- Open the diff for the next file
						["<s-tab>"] = actions.select_prev_entry, -- Open the diff for the previous file
						["gf"] = actions.goto_file, -- Open the file in a new split in the previous tabpage
						["<C-w><C-f>"] = actions.goto_file_split, -- Open the file in a new split
						["<C-w>gf"] = actions.goto_file_tab, -- Open the file in a new tabpage
						["<M-k>"] = actions.focus_files, -- Bring focus to the file panel
						["<M-j>"] = actions.toggle_files, -- Toggle the file panel.
						["<BS>"] = actions.cycle_layout,
						["[x"] = actions.prev_conflict, -- In the merge_tool: jump to the previous conflict
						["]x"] = actions.next_conflict, -- In the merge_tool: jump to the next conflict
						["X"] = actions.restore_entry, -- Restore entry to the state on the left side.
						["-"] = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
						["<leader>ck"] = actions.prev_conflict, -- In the merge_tool: jump to the previous conflict
						["<leader>cj"] = actions.next_conflict, -- In the merge_tool: jump to the next conflict
						["<leader>co"] = actions.conflict_choose("ours"), -- Choose the OURS version of a conflict
						["<leader>ct"] = actions.conflict_choose("theirs"), -- Choose the THEIRS version of a conflict
						["<leader>cb"] = actions.conflict_choose("base"), -- Choose the BASE version of a conflict
						["<leader>ca"] = actions.conflict_choose("all"), -- Choose all the versions of a conflict
						["dx"] = actions.conflict_choose("none"), -- Delete the conflict region
					},
					diff1 = { --[[ Mappings in single window diff layouts ]]
					},
					diff2 = { --[[ Mappings in 2-way diff layouts ]]
					},
					diff3 = {
						-- Mappings in 3-way diff layouts
						{ { "n", "x" }, "2do", actions.diffget("ours") }, -- Obtain the diff hunk from the OURS version of the file
						{ { "n", "x" }, "3do", actions.diffget("theirs") }, -- Obtain the diff hunk from the THEIRS version of the file
					},
					diff4 = {
						-- Mappings in 4-way diff layouts
						{ { "n", "x" }, "1do", actions.diffget("base") }, -- Obtain the diff hunk from the BASE version of the file
						{ { "n", "x" }, "2do", actions.diffget("ours") }, -- Obtain the diff hunk from the OURS version of the file
						{ { "n", "x" }, "3do", actions.diffget("theirs") }, -- Obtain the diff hunk from the THEIRS version of the file
					},
					file_panel = {
						["j"] = actions.next_entry, -- Bring the cursor to the next file entry
						["<down>"] = actions.next_entry,
						["k"] = actions.prev_entry, -- Bring the cursor to the previous file entry.
						["<up>"] = actions.prev_entry,
						["h"] = actions.prev_entry,
						["<cr>"] = actions.select_entry, -- Open the diff for the selected entry.
						["o"] = actions.select_entry,
						["<2-LeftMouse>"] = actions.select_entry,
						["-"] = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
						["T"] = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
						["S"] = actions.stage_all, -- Stage all entries.
						["U"] = actions.unstage_all, -- Unstage all entries.
						["X"] = actions.restore_entry, -- Restore entry to the state on the left side.
						["L"] = actions.open_commit_log, -- Open the commit log panel.
						["<c-b>"] = actions.scroll_view(-0.25), -- Scroll the view up
						["<c-f>"] = actions.scroll_view(0.25), -- Scroll the view down
						["<tab>"] = actions.select_next_entry,
						["<s-tab>"] = actions.select_prev_entry,
						["gf"] = actions.goto_file,
						["<C-w><C-f>"] = actions.goto_file_split,
						["<C-w>gf"] = actions.goto_file_tab,
						["i"] = actions.listing_style, -- Toggle between 'list' and 'tree' views
						["f"] = actions.toggle_flatten_dirs, -- Flatten empty subdirectories in tree listing style.
						["R"] = actions.refresh_files, -- Update stats and entries in the file list.
						["<M-k>"] = actions.focus_files, -- Bring focus to the file panel
						["<M-j>"] = actions.toggle_files, -- Toggle the file panel.
						["<BS>"] = actions.cycle_layout,
						["[x"] = actions.prev_conflict,
						["]x"] = actions.next_conflict,
					},
					file_history_panel = {
						["g!"] = actions.options, -- Open the option panel
						["<C-A-d>"] = actions.open_in_diffview, -- Open the entry under the cursor in a diffview
						["y"] = actions.copy_hash, -- Copy the commit hash of the entry under the cursor
						["L"] = actions.open_commit_log,
						["zR"] = actions.open_all_folds,
						["zM"] = actions.close_all_folds,
						["j"] = actions.next_entry,
						["<down>"] = actions.next_entry,
						["k"] = actions.prev_entry,
						["<up>"] = actions.prev_entry,
						["<cr>"] = actions.select_entry,
						["o"] = actions.select_entry,
						["<2-LeftMouse>"] = actions.select_entry,
						["<c-b>"] = actions.scroll_view(-0.25),
						["<c-f>"] = actions.scroll_view(0.25),
						["<tab>"] = actions.select_next_entry,
						["<s-tab>"] = actions.select_prev_entry,
						["gf"] = actions.goto_file,
						["<C-w><C-f>"] = actions.goto_file_split,
						["<C-w>gf"] = actions.goto_file_tab,
						["<M-k>"] = actions.focus_files, -- Bring focus to the file panel
						["<M-j>"] = actions.toggle_files, -- Toggle the file panel.
						["<BS>"] = actions.cycle_layout,
					},
					option_panel = {
						["<tab>"] = actions.select_entry,
						["q"] = actions.close,
					},
				},
			})
		end,
	},
	{
		"isakbm/gitgraph.nvim",
		dependencies = { "sindrets/diffview.nvim" },
		enabled = false,
		keys = {
			{
				"<leader>gL",
				function()
					local cmd = 'lua require("gitgraph").draw({}, { all = true, max_count = 5000 })'
					-- require("gitgraph").draw({}, { all = true, max_count = 5000 })
					vim.api.nvim_feedkeys(":" .. cmd, "n", false)
				end,
				desc = "GitGraph - Draw",
			},
			{
				"<leader>gg",
				function()
					local current_branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("%s+", "")
					local default_branch = vim.fn
						.system("git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'")
						:gsub("%s+", "")
					local revision_range = current_branch .. "..." .. default_branch
					local cmd = 'lua require("gitgraph").draw({}, { revision_range = "'
						.. revision_range
						.. '", max_count = 5000 })'
					vim.api.nvim_feedkeys(":" .. cmd, "n", false)
				end,
				desc = "GitGraph - Draw",
			},
		},
		opts = {
			hooks = {
				on_select_commit = function(commit)
					vim.notify("DiffviewOpen " .. commit.hash .. "^!")
					vim.cmd(":DiffviewOpen " .. commit.hash .. "^!")
				end,
				on_select_range_commit = function(from, to)
					vim.notify("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
					vim.cmd(":DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
				end,
			},
		},
	},
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "G", "Gitdiff", "Gedit" },
		keys = {
			{ mode = { "n" }, "<leader>ge", "<cmd>Gedit stash<cr>" },
		},
		config = function()
			vim.cmd([[let g:nremap = {'[m': '<s-tab>', ']m': '<tab>'}]])
			vim.cmd("command! -nargs=* G rightbelow vertical Git <args>")
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "LspAttach" },
		config = function()
			-- import gitsigns plugin safely
			local setup, gitsigns = pcall(require, "gitsigns")
			if not setup then
				return
			end

			gitsigns.setup({
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir = {
					interval = 1000,
					follow_files = true,
				},
				attach_to_untracked = true,
				current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
					delay = 10,
					ignore_whitespace = false,
				},
				current_line_blame_formatter = "  <author>, <author_time:%Y-%m-%d> - <summary>",
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 10000, -- Disable if file is longer than this (in lines)
				preview_config = {
					-- Options passed to nvim_open_win
					border = "single",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
				-- yadm = {
				--   enable = false,
				-- },
				on_attach = function(bufnr)
					local function map(mode, lhs, rhs, opts)
						opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
						vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
					end
					-- Navigation
					map("n", "<leader>sj", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
					map("n", "<leader>sk", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

					map("n", "<leader>ph", "<cmd>Gitsigns preview_hunk_inline<cr>", { silent = true })

					map("n", "<leader>gD", "<cmd>Gitsigns toggle_deleted<cr>", { silent = true })

					-- vim.keymap.set({'o', 'x'}, 'ih', '<Cmd>Gitsigns select_hunk<CR>')

					-- Actions
					map("n", "<leader>gT", "<cmd>Gitsigns toggle_current_line_blame<CR>")
				end,
			})
		end,
	},
}
