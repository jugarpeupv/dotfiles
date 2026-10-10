return {
	{
		"rhysd/rust-doc.vim",
		ft = { "rust", "rs" },
		enabled = false,
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
