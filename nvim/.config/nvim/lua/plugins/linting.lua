return {
	-- {
	-- 	"esmuellert/nvim-eslint",
	-- 	config = function()
	-- 		require("nvim-eslint").setup({})
	-- 	end,
	-- },
	{
		"mfussenegger/nvim-lint",
		event = "BufReadPost",
		config = function()
			vim.env.ESLINT_D_PPID = vim.fn.getpid()
			require("lint").linters_by_ft = {
				-- ["yaml.github"] = { "actionlint", "yamllint" },
				["yaml.github"] = { "actionlint" },
				javascript = {'eslint_d'},
				typescript = {'eslint_d'},
			}

			vim.keymap.set("n", "<leader>lf", function()
				require("lint").try_lint()
			end, { noremap = true, silent = true })

			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					-- if vim.bo.filetype ~= "yaml.github" then
					-- 	return
					-- end
					-- try_lint without arguments runs the linters defined in `linters_by_ft`
					-- for the current filetype
					require("lint").try_lint()

					-- -- You can call `try_lint` with a linter name or a list of names to always
					-- -- run specific linters, independent of the `linters_by_ft` configuration
					-- require("lint").try_lint("cspell")
				end,
			})
		end,
	},
}
