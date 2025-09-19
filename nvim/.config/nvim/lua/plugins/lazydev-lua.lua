-- return {}
return {
	{
		"folke/lazydev.nvim",
    enabled = true,
		ft = "lua", -- only load on lua files
		opts = {
			enabled = true,
			debug = false,
			-- library = {
			--   "nvim-cmp/lua/cmp/types",
			-- },
			library = {
				-- Or relative, which means they will be resolved from the plugin dir.
				"lazy.nvim",
				-- It can also be a table with trigger words / mods
				-- Only load luvit types when the `vim.uv` word is found
				-- { path = "${3rd}/luv/library", words = { "vim%.uv" } },
				-- always load the LazyVim library
				"LazyVim",
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true, enabled = false }, -- optional `vim.uv` typings
}
