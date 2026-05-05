return {
	{
		-- "sindrets/diffview.nvim",
		-- "dlyongemallo/diffview.nvim",
    "jugarpeupv/diffview.nvim",
    -- dev = true,
    -- dir = "~/projects/diffview.nvim/wt-main",
		-- version = "*",
		branch = "main",
		-- event = "VeryLazy",
		cmd = { "DiffviewOpen" },
		enabled = true,
		-- event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"junegunn/fzf",
			"nvim-telescope/telescope.nvim",
			"akinsho/git-conflict.nvim",
		},
		keys = {
			{ "<leader>gd", mode = "n", "<cmd>DiffviewOpen<cr>" },
			-- { "<leader>gd", mode = "n", "<cmd>DiffviewOpen -- :!package-lock.json<cr>" },
			-- { "<leader>cc", mode = "n", "<cmd>DiffviewClose<cr>" },
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

      -- Overleaf inline diff highlights: line background for modified lines
      -- and a brighter background for the removed characters (strikethrough).
      -- These override the plugin defaults (which inherit from DiffDelete)
      -- to provide more contrast.
      vim.api.nvim_set_hl(0, "DiffviewDiffDeleteLine", { bg = "#3F2D3D" })
      vim.api.nvim_set_hl(0, "DiffviewDiffDeleteInline", { bg = "#7b3038", strikethrough = true })

			require("diffview").setup({
				diff_binaries = true, -- Show diffs for binaries
				enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
				clean_up_buffers = true, -- Delete file buffers created by diffview on close.
				git_cmd = { "git" }, -- The git executable followed by default args.
				use_icons = true, -- Requires nvim-web-devicons
				large_file_threshold = 5000, -- Line count above which treesitter is disabled on non-LOCAL diff buffers. 0 = disabled.
				watch_index = true, -- Update views and index buffers when the git index changes.
				icons = { -- Only applies when use_icons is true.
					folder_closed = "",
					folder_open = "",
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
          inline = {
            style = "overleaf"
          },
					default = {
						layout = "diff2_horizontal",
						-- layout = "diff1_inline",
					},
					merge_tool = {
						layout = "diff1_plain",
						disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
					},
					cycle_layouts = {
						-- default = { "diff1_inline", "diff2_horizontal", "diff2_vertical" },
            default = { "diff1_inline", "diff2_horizontal" },
						merge_tool = { "diff4_mixed", "diff3_mixed", "diff3_horizontal", "diff1_plain" },
					},
					file_history = {
						-- Config for changed files in file history views.
						layout = "diff2_horizontal",
						-- layout = "diff1_inline",
					},
				},
				file_panel = {
					listing_style = "tree", -- One of 'list' or 'tree'
					tree_options = { -- Only applies when listing_style is 'tree'
						flatten_dirs = false, -- Flatten dirs that only contain one single dir
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
						vim.b.ignore_early_retirement = true
					end,
					-- ---@param view StandardView
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
						-- ["gf"] = actions.goto_file, -- Open the file in a new split in the previous tabpage
            ["gf"] = actions.goto_file_edit_close, -- Open the file in a new split in the previous tabpage
						["<C-w><C-f>"] = actions.goto_file_split, -- Open the file in a new split
						["<C-w>gf"] = actions.goto_file_tab, -- Open the file in a new tabpage
						["<M-k>"] = actions.focus_files, -- Bring focus to the file panel
						["<M-j>"] = actions.toggle_files, -- Toggle the file panel.
						["<BS>"] = actions.cycle_layout,
						["[x"] = actions.prev_conflict, -- In the merge_tool: jump to the previous conflict
						["]x"] = actions.next_conflict, -- In the merge_tool: jump to the next conflict
						["X"] = actions.restore_entry, -- Restore entry to the state on the left side.
						["-"] = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
						["ck"] = actions.prev_conflict, -- In the merge_tool: jump to the previous conflict
						["cj"] = actions.next_conflict, -- In the merge_tool: jump to the next conflict
						["cc"] = actions.conflict_choose("ours"), -- Choose the OURS version of a conflict
						["ci"] = actions.conflict_choose("theirs"), -- Choose the THEIRS version of a conflict
						["cs"] = actions.conflict_choose("base"), -- Choose the BASE version of a conflict
						["cb"] = actions.conflict_choose("all"), -- Choose all the versions of a conflict
						["cn"] = actions.conflict_choose("none"), -- Delete the conflict region
						{
							"n",
							"<leader>cC",
							actions.conflict_choose_all("ours"),
							{ desc = "Choose the OURS version of a conflict for the whole file" },
						},
						{
							"n",
							"<leader>cI",
							actions.conflict_choose_all("theirs"),
							{ desc = "Choose the THEIRS version of a conflict for the whole file" },
						},
						{
							"n",
							"<leader>cS",
							actions.conflict_choose_all("base"),
							{ desc = "Choose the BASE version of a conflict for the whole file" },
						},
						{
							"n",
							"<leader>cB",
							actions.conflict_choose_all("all"),
							{ desc = "Choose all the versions of a conflict for the whole file" },
						},
						{
							"n",
							"<leader>cN",
							actions.conflict_choose_all("none"),
							{ desc = "Delete the conflict region for the whole file" },
						},
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
						-- ["gf"] = actions.goto_file,
            ["gf"] = actions.goto_file_edit_close,
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
						{
							"n",
							"<leader>cC",
							actions.conflict_choose_all("ours"),
							{ desc = "Choose the OURS version of a conflict for the whole file" },
						},
						{
							"n",
							"<leader>cI",
							actions.conflict_choose_all("theirs"),
							{ desc = "Choose the THEIRS version of a conflict for the whole file" },
						},
						{
							"n",
							"<leader>cS",
							actions.conflict_choose_all("base"),
							{ desc = "Choose the BASE version of a conflict for the whole file" },
						},
						{
							"n",
							"<leader>cB",
							actions.conflict_choose_all("all"),
							{ desc = "Choose all the versions of a conflict for the whole file" },
						},
						{
							"n",
							"<leader>cN",
							actions.conflict_choose_all("none"),
							{ desc = "Delete the conflict region for the whole file" },
						},
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
						-- ["gf"] = actions.goto_file,
            ["gf"] = actions.goto_file_edit_close,
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
}
