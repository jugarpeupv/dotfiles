return {
	{
		"yelog/i18n.nvim",
		lazy = true,
    enabled = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>is", "<cmd>I18nShowTranslations<cr>", desc = "I18n show translations" },
			{ "<leader>in", "<cmd>I18nNextLocale<cr>", desc = "I18n next locale" },
			{ "<leader>iu", "<cmd>I18nKeyUsages<cr>", desc = "I18n key usages" },
			-- { "<leader>ia", "<cmd>I18nAddKey<cr>", desc = "I18n add key" },
			-- { "<leader>it", "<cmd>I18nToggleTranslation<cr>", desc = "I18n toggle translation" },
		},
		opts = {
			func_pattern = {
				"t",
				"$t",
				{ pattern = "['\"]([%w%.%-_]+)['\"]%s*%)?%s*|%s*translate.*" },
			},
			filetypes = {
				"vue",
				"typescript",
				"javascript",
				"typescriptreact",
				"javascriptreact",
				"tsx",
				"jsx",
				"java",
				"html",
        "htmlangular", -- Angular templates
			},
		},
	},
}
