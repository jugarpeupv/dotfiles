return {
	{
		"mistweaverco/kulala.nvim",
    enabled = true,
		ft = { "http", "rest" },
		opts = {
      lsp = { formatter = true },
			debug = true,
			vscode_rest_client_environmentvars = true,
			winbar = true,
			default_winbar_panes = { "body", "headers" },
			-- show_icons = "nil",
			-- winbar = false,
			-- disable_script_print_output = false,
			-- default_view = "headers_body",
		},
	},
	{
		"jellydn/hurl.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown" },
				},
				ft = { "markdown" },
			},
		},
		ft = "hurl",
		opts = {
			-- Show debugging info
			debug = false,
			-- Show notification on run
			show_notification = false,
			env_file = { ".env" },
			-- Show response in popup or split
			mode = "split",
			-- Default formatter
			formatters = {
				json = { "jq" }, -- Make sure you have install jq in your system, e.g: brew install jq
				html = {
					"prettier", -- Make sure you have install prettier in your system, e.g: npm install -g prettier
					"--parser",
					"html",
				},
				xml = {
					"tidy", -- Make sure you have installed tidy in your system, e.g: brew install tidy-html5
					"-xml",
					"-i",
					"-q",
				},
			},
			-- Default mappings for the response popup or split views
			mappings = {
				close = "q", -- Close the response popup or split view
				next_panel = "<C-n>", -- Move to the next response popup window
				prev_panel = "<C-p>", -- Move to the previous response popup window
			},
		},
		keys = {
			-- Run API request
			-- { "<leader>A",  "<cmd>HurlRunner<CR>",        desc = "Run All requests" },
			{ "<leader>um", "<cmd>HurlManageVariable<CR>", desc = "manage variables", mode = "n" },
			{ "<leader>ue", "<cmd>HurlShowLastResponse<CR>", desc = "Hurl show last response", mode = "n" },
			{ "<leader>ur", "<cmd>HurlRunnerAt<CR>", desc = "Run Api request", mode = "n" },
			-- { "<leader>te", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
			-- { "<leader>tE", "<cmd>HurlRunnerToEnd<CR>",   desc = "Run Api request from current entry to end" },
			-- { "<leader>tm", "<cmd>HurlToggleMode<CR>",    desc = "Hurl Toggle Mode" },
			-- { "<leader>uv", "<cmd>HurlVerbose<CR>",       desc = "Run Api in verbose mode" },
			-- { "<leader>uV", "<cmd>HurlVeryVerbose<CR>",   desc = "Run Api in very verbose mode" },
			-- Run Hurl request in visual mode
			{
				"<leader>Hr",
				":HurlRunner<CR>",
				desc = "Hurl Runner",
				mode = "v",
			},
		},
	},
}
