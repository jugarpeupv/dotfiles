return {
	{ "vim-scripts/ReplaceWithRegister", keys = { { "gr", mode = "n" }, { "gr", mode = "v" } } },
	{
		"gbprod/yanky.nvim",
		enabled = function()
			local is_headless = #vim.api.nvim_list_uis() == 0
			if is_headless then
				return false
			end
			return true
		end,
		dependencies = {
			{ "kkharji/sqlite.lua" },
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			local utils = require("yanky.utils")
			local mapping = require("yanky.telescope.mapping")
			require("yanky").setup({
				ring = {
					storage = "sqlite",
					history_length = 200,
				},
				highlight = {
					on_put = false,
					on_yank = false,
					timer = 500,
				},
				preserve_cursor_position = {
					enabled = false,
				},
				textobj = {
					enabled = true,
				},
				picker = {
					telescope = {
						mappings = {
							default = mapping.set_register(utils.get_default_register()),
							i = {
								["<c-p>"] = mapping.put("p"),
								-- ["<c-g>"] = mapping.put("P"),
								["<c-x>"] = mapping.delete(),
								["<c-k>"] = require("telescope.actions").move_selection_previous,
							},
							n = {
								p = mapping.put("p"),
								P = mapping.put("P"),
								d = mapping.delete(),
								r = mapping.set_register(utils.get_default_register()),
							},
						},
					},
				},
			})
		end,
		keys = {
			{
				"<M-`>",
				function()
					require("telescope").extensions.yank_history.yank_history()
				end,
				mode = { "i", "x", "n", "c" },
				desc = "Open Yank History",
			},
			{
				"<leader>cl",
				function()
					require("telescope").extensions.yank_history.yank_history()
				end,
				mode = { "n", "x" },
				desc = "Open Yank History",
			},
			{
				"y",
				"<Plug>(YankyYank)",
				mode = { "n", "x" },
				desc = "Yank text",
			},
			-- { "p", "<Plug>(YankyPutAfterFilter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
			-- { "P", "<Plug>(YankyPutBeforeFilter)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
			-- {
			--   "p",
			--   "<Plug>(YankyPutAfter)",
			--   mode = { "n", "x" },
			--   desc = "Put yanked text after cursor",
			-- },
			-- {
			--   "P",
			--   "<Plug>(YankyPutBefore)",
			--   mode = { "n", "x" },
			--   desc = "Put yanked text before cursor",
			-- },
			-- {
			--   "gp",
			--   "<Plug>(YankyGPutAfter)",
			--   mode = { "n", "x" },
			--   desc = "Put yanked text after selection",
			-- },
			-- {
			--   "gP",
			--   "<Plug>(YankyGPutBefore)",
			--   mode = { "n", "x" },
			--   desc = "Put yanked text before selection",
			-- },
			-- {
			--   "<C-p>",
			--   "<Plug>(YankyPreviousEntry)",
			--   desc = "Select previous entry through yank history",
			-- },
			-- {
			--   "<C-n>",
			--   "<Plug>(YankyNextEntry)",
			--   desc = "Select next entry through yank history",
			-- },
			{
				"]p",
				"<Plug>(YankyPutIndentAfterLinewise)",
				desc = "Put indented after cursor (linewise)",
			},
			{
				"[p",
				"<Plug>(YankyPutIndentBeforeLinewise)",
				desc = "Put indented before cursor (linewise)",
			},
			{
				"]P",
				"<Plug>(YankyPutIndentAfterLinewise)",
				desc = "Put indented after cursor (linewise)",
			},
			{
				"[P",
				"<Plug>(YankyPutIndentBeforeLinewise)",
				desc = "Put indented before cursor (linewise)",
			},
			{ ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
			{ "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
			{ ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
			{ "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },
			{ "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
			{ "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
		},
	},
}
