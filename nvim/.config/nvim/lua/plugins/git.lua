return {
	-- {
	-- 	-- "aweis89/ai-commit-msg.nvim",
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
		-- "akinsho/git-conflict.nvim",
		"jugarpeupv/git-conflict.nvim",
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
