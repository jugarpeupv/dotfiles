return {

	{
		"jugarpeupv/search-github-repos.nvim",
		config = function()
			require("search-github-repos").setup({
				owner = "mapfre-tech", -- scope searches to this org
				limit = 15, -- max results from gh CLI
				debounce_ms = 1000,
				ssh_alias = "mar",
				-- backend = "telescope", -- or "snacks" (auto-detects by default)
			})
		end,
		keys = {
			{ "<leader>gr", "<cmd>SearchGithubRepos<cr>", desc = "Search GitHub Repos" },
		},
	},

	{
		"skanehira/github-actions.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim", -- Optional: for enhanced workflow selection
		},
		keys = {
			{ mode = "n", "<leader>gw", "<cmd>GithubActionsWatch<cr>" },
			{ mode = "n", "<leader>gi", "<cmd>GithubActionsHistory<cr>" },
			{ mode = "n", "<leader>gD", "<cmd>GithubActionsDispatch<cr>" },
		},
		-- cmd = { "GithubActionsDispatch", "GithubActionsHistory", "GithubActionsHistoryByPR", "GithubActionsWatch" },
		config = function()
			require("github-actions").setup({
				actions = {
					enabled = false, -- Enable version checking (default: true)
					icons = {
						outdated = "", -- Icon for outdated versions (default)
						latest = "", -- Icon for latest versions (default)
						error = "", -- Icon for error (default)
					},
					highlight_latest = "GitHubActionsVersionLatest", -- Highlight for latest versions
					highlight_outdated = "GitHubActionsVersionOutdated", -- Highlight for outdated versions
					highlight_error = "GitHubActionsVersionError", -- Highlight for error
					highlight_icon_latest = "GitHubActionsIconLatest", -- Highlight for latest icon
					highlight_icon_outdated = "GitHubActionsIconOutdated", -- Highlight for outdated icon
					highlight_icon_error = "GitHubActionsIconError", -- Highlight for error icon
				},
				history = {
					buffer = {
						history = {
							open_mode = "split", -- How to open history buffer: 'tab', 'vsplit', 'split', or 'current' (default: 'tab')
							buflisted = true, -- Whether buffer appears in buffer list (default: true)
							window_options = { -- Window-local options to set (default: {wrap = true})
								wrap = true, -- Enable line wrapping
							},
						},
						logs = {
							open_mode = "vsplit", -- How to open logs buffer: 'tab', 'vsplit', 'split', or 'current' (default: 'vsplit')
							buflisted = true, -- Whether buffer appears in buffer list (default: true)
							window_options = { -- Window-local options to set (default: {wrap = false})
								wrap = false, -- Disable line wrapping (better for log files)
							},
						},
					},
					icons = {
						success = "✓", -- Icon for successful runs (default)
						failure = "✗", -- Icon for failed runs (default)
						cancelled = "⊘", -- Icon for cancelled runs (default)
						skipped = "⊘", -- Icon for skipped runs (default)
						in_progress = "⊙", -- Icon for in-progress runs (default)
						queued = "○", -- Icon for queued runs (default)
						waiting = "○", -- Icon for waiting runs (default)
						unknown = "?", -- Icon for unknown status runs (default)
					},
					highlights = {
						success = "GitHubActionsHistorySuccess", -- Highlight for successful runs
						failure = "GitHubActionsHistoryFailure", -- Highlight for failed runs
						cancelled = "GitHubActionsHistoryCancelled", -- Highlight for cancelled runs
						running = "GitHubActionsHistoryRunning", -- Highlight for running runs
						queued = "GitHubActionsHistoryQueued", -- Highlight for queued runs
						run_id = "GitHubActionsHistoryRunId", -- Highlight for run ID
						branch = "GitHubActionsHistoryBranch", -- Highlight for branch name
						time = "GitHubActionsHistoryTime", -- Highlight for time information
						header = "GitHubActionsHistoryHeader", -- Highlight for header
						separator = "GitHubActionsHistorySeparator", -- Highlight for separator
					},
					-- Optional: customize highlight colors globally
					highlight_colors = {
						success = { fg = "#8ee2cf", bold = false }, -- Highlight for successful runs
						failure = { fg = "#F38BA8", bold = false }, -- Highlight for failed runs
						cancelled = { fg = "#9399B3", bold = false }, -- Highlight for cancelled runs
						running = { fg = "#B4BEFE", bold = false }, -- Highlight for running runs
						queued = { fg = "#F5C2E7", bold = false }, -- Highlight for queued runs
					},
					-- Optional: customize keymaps for history buffers
					keymaps = {
						list = { -- Workflow run list buffer
							close = "q", -- Close the buffer
							expand = "L", -- Expand/collapse run or view logs
							collapse = "H", -- Collapse expanded run
							refresh = "r", -- Refresh history
							rerun = "R", -- Rerun workflow
							dispatch = "D", -- Dispatch workflow
							watch = "W", -- Watch running workflow
							cancel = "X", -- Cancel running workflow
							open_browser = "<C-o>", -- Open run/job URL in browser
						},
						logs = { -- Logs buffer
							close = "q", -- Close the buffer
						},
					},
				},
			})
		end,
	},
}
