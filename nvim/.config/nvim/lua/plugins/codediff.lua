return {
	{
		"esmuellert/codediff.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
    -- dir = "~/projects/codediff.nvim/wt-feature-toggle_layout/",
    -- dev = true,
		enabled = false,
		cmd = { "CodeDiff" },
		keys = {
			{ "<leader>gd", mode = "n", "<cmd>CodeDiff<cr>" },
			-- { "<leader>cc", mode = "n", "<cmd>CodeDiff<cr>" },
			{ "<leader>ll", mode = "n", "<cmd>CodeDiff history<cr>" },
			{ "<leader>gv", mode = { "v" }, "<cmd>'<,'>CodeDiff history<CR>" },
			{ "<leader>gv", mode = { "n" }, "<cmd>CodeDiff history %<cr>" },
		},
		opts = {
			highlights = {
				line_insert = "DiffAdd",
				line_delete = "DiffDelete",
				-- char_insert = "#3fb950",
				-- char_delete = "#ff7b72",
				char_brightness = 1.8,
			},
			-- Diff view behavior
			diff = {
				-- layout = "inline",
        layout = "side-by-side",
				cycle_next_hunk = false,
				disable_inlay_hints = true, -- Disable inlay hints in diff windows for cleaner view
        jump_to_first_change = true,
				max_computation_time_ms = 5000, -- Maximum time for diff computation (VSCode default)
			},

			-- Explorer panel configuration
			explorer = {
				position = "left", -- "left" or "bottom"
				width = 40, -- Width when position is "left" (columns)
				height = 15, -- Height when position is "bottom" (lines)
				indent_markers = true, -- Show indent markers in tree view (│, ├, └)
				flatten_dirs = false,
				initial_focus = "modified", -- Initial focus: "explorer", "original", or "modified"
				focus_on_select = true,
				icons = {
					folder_closed = "", -- Nerd Font folder icon (customize as needed)
					folder_open = "", -- Nerd Font folder-open icon
				},
				view_mode = "tree", -- "list" or "tree"
				file_filter = {
					-- ignore = { ".git/**", ".jj/**", "*package-lock.json" }, -- Glob patterns to hide (e.g., {"*.lock", "dist/*"})
					ignore = { ".git/**", ".jj/**" }, -- Glob patterns to hide (e.g., {"*.lock", "dist/*"})
				},
			},

			-- History panel configuration (for :CodeDiff history)
			history = {
				position = "bottom", -- "left" or "bottom" (default: bottom)
				width = 40, -- Width when position is "left" (columns)
				height = 15, -- Height when position is "bottom" (lines)
				initial_focus = "modified", -- Initial focus: "explorer", "original", or "modified"
				view_mode = "list", -- "list" or "tree" for files under commits
			},

			-- Keymaps in diff view
			keymaps = {
				view = {
					quit = "q", -- Close diff tab
					toggle_explorer = "<M-j>", -- Toggle explorer visibility (explorer mode only)
					focus_explorer = "<M-k>", -- Focus explorer panel (explorer mode only)
					next_hunk = ")", -- Jump to next change
					prev_hunk = "(", -- Jump to previous change
					next_file = "<tab>", -- Next file in explorer/history mode
					prev_file = "<s-tab>", -- Previous file in explorer/history mode
					diff_get = "do", -- Get change from other buffer (like vimdiff)
					diff_put = "dp", -- Put change to other buffer (like vimdiff)
					open_in_prev_tab = "gf", -- Open current buffer in previous tab (or create one before)
					close_on_open_in_prev_tab = false, -- Close codediff tab after gf opens file in previous tab
					toggle_stage = "-", -- Stage/unstage current file (works in explorer and diff buffers)
					stage_hunk = "<leader>hs", -- Stage hunk under cursor to git index
					unstage_hunk = "<leader>hu", -- Unstage hunk under cursor from git index
					discard_hunk = "<leader>hr", -- Discard hunk under cursor (working tree only)
					hunk_textobject = "ih", -- Textobject for hunk (vih to select, yih to yank, etc.)
					show_help = "g?", -- Show floating window with available keymaps
          toggle_layout = "t"
				},
				explorer = {
					select = "<CR>", -- Open diff for selected file
					hover = "K", -- Show file diff preview
					refresh = "R", -- Refresh git status
					toggle_view_mode = "i", -- Toggle between 'list' and 'tree' views
					stage_all = "S", -- Stage all files
					unstage_all = "U", -- Unstage all files
					restore = "X", -- Discard changes (restore file)
					toggle_changes = "gu", -- Toggle Changes (unstaged) group visibility
					toggle_staged = "gs", -- Toggle Staged Changes group visibility
				},
				history = {
					select = "<CR>", -- Select commit/file or toggle expand
					toggle_view_mode = "i", -- Toggle between 'list' and 'tree' views
				},
				conflict = {
					accept_incoming = "<leader>ct", -- Accept incoming (theirs/left) change
					accept_current = "<leader>co", -- Accept current (ours/right) change
					accept_both = "<leader>cb", -- Accept both changes (incoming first)
					discard = "<leader>cx", -- Discard both, keep base
					next_conflict = "(", -- Jump to next conflict
					prev_conflict = ")", -- Jump to previous conflict
					diffget_incoming = "2do", -- Get hunk from incoming (left/theirs) buffer
					diffget_current = "3do", -- Get hunk from current (right/ours) buffer
				},
			},
		},
		config = function(_, opts)
			require("codediff").setup(opts)
			vim.api.nvim_create_autocmd("User", {
				pattern = "CodeDiffOpen",
				callback = function()
					vim.g.codediff_saved_showtabline = vim.o.showtabline
					vim.o.showtabline = 0
					require("barbecue.ui").toggle(false)
					require("treesitter-context").disable()
					for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
						vim.wo[win].cursorline = false
						-- vim.wo[win].scrollbind = true
						-- vim.wo[win].cursorbind = true
					end
				end,
			})
			vim.api.nvim_create_autocmd("User", {
				pattern = "CodeDiffClose",
				callback = function()
					if vim.g.codediff_saved_showtabline then
						vim.o.showtabline = vim.g.codediff_saved_showtabline
						vim.g.codediff_saved_showtabline = nil
						require("barbecue.ui").toggle(true)
						require("treesitter-context").enable()
					end
				end,
			})
		end,
	},
}
