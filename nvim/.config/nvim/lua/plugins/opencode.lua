return {
	{
		"sudo-tee/opencode.nvim",
		-- dev = true,
		-- dir = "~/work/tmp/opencode.nvim/wt-feature-auto_scroll_config",
		lazy = true,
		enabled = true,
		keys = {
			{
				mode = { "n", "v" },
				"<C-.>",
				function()
					require("opencode.api").toggle()
				end,
			},
		},
		config = function()
			-- Default configuration with all available options
			require("opencode").setup({
				preferred_picker = "telescope",
				preferred_completion = "blink",
				default_global_keymaps = false,
				default_mode = "build",
				keymap_prefix = "",
				keymap = {
					editor = {
						["<C-.>"] = { "toggle" }, -- Open opencode. Close if opened
					},
					input_window = {
						["<esc>"] = false, -- Close UI windows
						["<cr>"] = { "submit_input_prompt", mode = { "n" } }, -- Submit prompt (normal mode and insert mode)
						["<c-s>"] = { "submit_input_prompt", mode = { "i" } }, -- Submit prompt (normal mode and insert mode)
					},
					output_window = {
						["<esc>"] = false, -- Close UI windows
					},
					permission = {
						accept = "a",
						accept_all = "A",
						deny = "D",
					},
				},
				ui = {
					output = {
						always_scroll_to_bottom = false,
					},
					input = {
						text = {
							wrap = true
						},
					},
				},
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"MeanderingProgrammer/render-markdown.nvim",
			},
			"saghen/blink.cmp",

			"folke/snacks.nvim",
		},
	},
}
