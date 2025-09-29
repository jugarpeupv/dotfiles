-- return {}
return {
	{
		"folke/lazydev.nvim",
		enabled = true,
    lazy = false,
		ft = "lua", -- only load on lua files
		dependencies = {
			{ "Bilal2453/luvit-meta", lazy = true, enabled = true }, -- optional `vim.uv` typings
		},
		opts = {
			enabled = true,
			debug = false,
      integrations = {
        -- Fixes lspconfig's workspace management for LuaLS
        -- Only create a new workspace if the buffer is not part
        -- of an existing workspace or one of its libraries
        lspconfig = true,
        -- add the cmp source for completion of:
        -- `require "modname"`
        -- `---@module "modname"`
        cmp = true,
        -- same, but for Coq
        coq = false,
      },
			-- library = {
			--   "nvim-cmp/lua/cmp/types",
			-- },
			library = {
				-- Or relative, which means they will be resolved from the plugin dir.
				"lazy.nvim",
        "$HOME/.local/share/nvim/lazy/luvit-meta/library",
				-- It can also be a table with trigger words / mods
				-- Only load luvit types when the `vim.uv` word is found
				-- { path = "${3rd}/luv/library", words = { "vim%.uv" } },
				-- { path = "$HOME/.local/share/nvim/lazy/luvit-meta/library/uv.lua", words = { "vim%.uv" } },
				-- always load the LazyVim library
				"LazyVim",
			},
		},
	},
}
