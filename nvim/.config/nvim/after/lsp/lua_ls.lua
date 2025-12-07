return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	settings = { -- custom settings for lua
		Lua = {
			diagnostics = {
				globals = { "vim", "jit", "bit", "Config" },
			},
			workspace = {
				library = {
					-- [vim.fn.expand("$VIMRUNTIME/lua")] = true,
					-- [vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
			-- workspace = {
			--   library = {
			--     [vim.fn.expand("$VIMRUNTIME/lua")] = true,
			--     [vim.fn.stdpath("config") .. "/lua"] = true,
			--   },
			-- },
		},
	},
}
