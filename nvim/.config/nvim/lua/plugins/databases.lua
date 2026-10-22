return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{
				"kristijanhusak/vim-dadbod-completion",
				ft = { "sql", "mysql", "plsql" },
				lazy = true,
			},
		},
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    keys = {
      { "<leader>dB", "<cmd>DBUIToggle<CR>", desc = "Toggle DBee" },
    },
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1

			vim.g.dbs = {
				nomo = "sqlite:" .. vim.fn.expand("~/projects/nomo/wt-feature-rebrand/server/prisma/dev.db"),
			}
		end,
	},
	{
		"kndndrj/nvim-dbee",
		dependencies = { "MunifTanjim/nui.nvim" },
		cmd = { "Dbee" },
		keys = {
			{ "<leader>db", "<cmd>Dbee toggle<CR>", desc = "Toggle DBee" },
		},
		build = function()
			require("dbee").install()
		end,
		config = function()
			require("dbee").setup({
				sources = {
					require("dbee.sources").MemorySource:new({
						{
							name = "Nomo dev",
							type = "sqlite",
							url = vim.fn.expand("~/projects/nomo/wt-feature-rebrand/server/prisma/dev.db"),
						},
					}),
				},
			})
		end,
	},
}
