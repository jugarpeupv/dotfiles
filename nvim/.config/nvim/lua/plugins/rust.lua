return {
	{
		"rhysd/rust-doc.vim",
		ft = { "rust", "rs" },
		enabled = false,
	},
	{
		"jugarpeupv/rust-docs.nvim",
		enabled = true,
		lazy = true,
		-- dev = true,
		-- dir = "~/projects/rust-docs.nvim/wt-main/",
		keys = {
			{ mode = { "n" }, "<leader>rd", ":RustDocs<cr>" },
		},
		dependencies = {
			-- Pick one:
			"nvim-telescope/telescope.nvim",
			-- or "folke/snacks.nvim",
		},
		opts = {
			open_mode = "split",
			keymaps = {
				open = "<leader>rd", -- global keymap to open picker
				section_next = ")", -- buffer-local: next section
				section_prev = "(", -- buffer-local: prev section
				open_browser = "gx", -- buffer-local: open in browser
			},
		}, -- uses defaults; see Configuration below
	},
	{
		"mrcjkb/rustaceanvim",
		-- To avoid being surprised by breaking changes,
		-- I recommend you set a version range
		version = "^9",
		-- This plugin implements proper lazy-loading (see :h lua-plugin-lazy).
		-- No need for lazy.nvim to lazy-load it.
		ft = { "rust", "rs" },
		lazy = false,
	},
}
