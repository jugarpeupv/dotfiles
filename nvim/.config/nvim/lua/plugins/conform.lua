-- return {}
return {
	{
		"zapling/mason-conform.nvim",
		-- event = { "BufReadPre", "BufNewFile" },
		-- priority = 700,
		lazy = true,
		config = function()
			require("mason-conform").setup({})
		end,
	},
	{
		"stevearc/conform.nvim",
		priority = 600,
		event = { "BufWritePost" },
		dependencies = {
			"williamboman/mason.nvim",
			{
				"mfussenegger/nvim-lint",
				config = function()
					require("lint").linters_by_ft = {
						["yaml.github"] = { "actionlint" },
					}

          local lint_group = vim.api.nvim_create_augroup("YamlGithubLint", { clear = true })
					vim.api.nvim_create_autocmd("BufWritePost", {
            group = lint_group,
						pattern = "*",
						callback = function()
							if vim.bo.filetype == "yaml.github" then
								require("lint").try_lint()
							end
						end,
					})
				end,
			},
		},
		opts = {
			-- Conform will run the first available formatter
			formatters = {
				kulala = {
					command = "kulala-fmt",
					args = { "format", "$FILENAME" },
					stdin = false,
				},
			},
			formatters_by_ft = {
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				lua = { "stylua" },
				xml = { "xmlformatter" },
				yaml = { "yamlfmt" },
				["yaml.github"] = { "yamlfmt" },
				http = { "kulala" },
			},
		},
		keys = {
			{
				mode = { "n", "v" },
				"<leader>fo",
				function()
					require("conform").format({
						lsp_fallback = true,
						async = true,
						timeout_ms = 500,
					})
				end,
				desc = "Format file or range (in visual mode)",
			},
		},
	},
}
