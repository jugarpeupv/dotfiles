return {
	{
		"yelog/i18n.nvim",
		lazy = true,
		enabled = true,
		ft = { "htmlangular", "html" },
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>is", "<cmd>I18nShowTranslations<cr>", desc = "I18n show translations" },
			{ "<leader>in", "<cmd>I18nNextLocale<cr>", desc = "I18n next locale" },
			{ "<leader>iu", "<cmd>I18nKeyUsages<cr>", desc = "I18n key usages" },
			{ "<leader>iA", "<cmd>I18nAddKey<cr>", desc = "I18n add key" },
			{
				"<leader>ik",
				function()
					require("i18n").i18n_keys()
				end,
				desc = "I18n keys with telescope",
			},
			-- { "<leader>it", "<cmd>I18nToggleTranslation<cr>", desc = "I18n toggle translation" },
		},
		opts = {
			auto_detect = {
				enabled = true,
				root_dirs = { "src", "app" }, -- directories to scan
				locale_dir_names = { "locales", "i18n" }, -- locale directory names
				extensions = { "json", "ts" }, -- supported file extensions
        merge_sources   = true,
				max_depth = 6, -- max directory depth to scan
				notify = false, -- show auto-detect summary
			},
			i18n_keys = {
				popup_type = "telescope", -- fzf-lua | telescope
				-- Action key mappings (multiple trigger keys allowed as multiple strings in the array)
				-- Use Vim-style notation (<cr>, <c-j>, etc.); they will be converted to keys recognized by fzf
				keys = {
					copy_key = { "<c-e>" }, -- Copy i18n key
					copy_translation = { "<c-y>" }, -- Copy translation of display locale
					jump = { "<cr>" }, -- Jump to display locale (fallback to default locale if failed)
					split_jump = { "<c-s>" }, -- Horizontal split jump
					vsplit_jump = { "<c-v>" }, -- Vertical split jump
					tab_jump = { "<c-t>" }, -- Tab page jump
					choose_locale_jump = { "<c-x>" }, -- Jump after choosing language
				},
				jump = {
					prefer_current_locale = true,
					open_cmd_default = "edit", -- edit|split|vsplit|tabedit
				},
				show_missing = true,
				missing_style = "Error",
				preview_order = "config", -- config|current_first|default_first
			},
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
