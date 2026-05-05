return {
	{
		"letieu/jira.nvim",
    cmd = { "Jira" },
		opts = {
			-- Your setup options...
			jira = {
				limit = 200, -- Global limit of tasks per view (default: 200)
			},
		},
	},
	-- {
	-- 	-- "aweis89/ai-commit-msg.nvim",
	-- 	dev = true,
	-- 	dir = "~/projects/ai-commit-msg.nvim/wt-main",
	-- 	ft = "gitcommit",
	-- 	enabled = false,
	-- 	config = true,
	-- 	opts = {
	-- 		-- your configuration options here
	-- 		-- Enable/disable the plugin
	-- 		enabled = true,
	--
	-- 		-- AI provider to use ("gemini", "openai", "anthropic", or "copilot")
	-- 		provider = "gemini",
	--
	-- 		-- Whether to prompt for push after commit
	-- 		auto_push_prompt = false,
	-- 		-- Pull-before-push behavior (helps avoid rejected pushes)
	-- 		pull_before_push = {
	-- 			enabled = false, -- run a pull before pushing
	-- 			args = { "--rebase", "--autostash" }, -- arguments passed to `git pull`
	-- 		},
	--
	-- 		-- Show spinner while generating
	-- 		spinner = true,
	--
	-- 		-- Show notifications
	-- 		notifications = false,
	--
	-- 		-- Number of surrounding lines to include in git diff (default: 5)
	-- 		context_lines = 0,
	--
	-- 		-- Cost display format ("compact", "verbose", or false to disable)
	-- 		cost_display = "compact",
	--
	-- 		-- Keymaps for commit buffer
	-- 		keymaps = {
	-- 			quit = "q", -- Set to false to disable
	-- 		},
	-- 	},
	-- },
	{
		"jugarpeupv/search-github-repos.nvim",
		dir = "~/projects/search-github-repos.nvim",
		dev = true,
		config = function()
			require("search-github-repos").setup({
				owner = "mapfre-tech", -- scope searches to this org
				limit = 15, -- max results from gh CLI
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
		-- dev = true,
		-- dir = "~/projects/github-actions.nvim/wt-main",
		-- ft = "yaml.github", -- if you want to load for yaml files
		-- event = {
		-- 	"BufReadPre .github/workflows/*",
		-- 	"BufNewFile .github/workflows/*",
		-- },
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
	{
		-- "akinsho/git-conflict.nvim",
		"jugarpeupv/git-conflict.nvim",
		-- dev = true,
		-- dir = "~/projects/git-conflict.nvim/wt-main",
		-- dependencies = { "sindrets/diffview.nvim" },
		lazy = true,
		branch = "main",
		enabled = true,
		event = { "BufReadPost", "BufNewFile" },
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
		"tpope/vim-fugitive",
		cmd = { "Git", "G", "Gitdiff", "Gedit" },
		keys = {
			{ mode = { "n" }, "<leader>ge", "<cmd>Gedit stash<cr>" },
		},
		config = function()
			vim.cmd([[let g:nremap = {'[m': '<s-tab>', ']m': '<tab>'}]])
			-- vim.cmd("command! -nargs=* G rightbelow vertical Git <args>")
			vim.cmd("command! -nargs=* G 0Git <args>")
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

					map("n", "<leader>tD", "<cmd>Gitsigns toggle_deleted<cr>", { silent = true })

					-- vim.keymap.set({'o', 'x'}, 'ih', '<Cmd>Gitsigns select_hunk<CR>')

					-- Actions
					map("n", "<leader>gT", "<cmd>Gitsigns toggle_current_line_blame<CR>")
				end,
			})
		end,
	},
}
