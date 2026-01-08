return {
	{
		"vim-test/vim-test",
		dependencies = {
			"rebelot/terminal.nvim",
		},
		config = function()
			vim.g["test#strategy"] = "neovim_sticky"
			vim.g["test#neovim_sticky#reopen_window"] = 1
			vim.g["test#preserve_screen"] = 1
			vim.g["test#neovim_sticky#kill_previous"] = 1
			vim.g["VimuxHeight"] = "15"
		end,
		keys = {
			{
				"<leader>tn",
				function()
					local cmd_name = "TestNearest"
					local win_ids = vim.api.nvim_list_wins()

					local writable_win_ids = {}
					for _, win in ipairs(win_ids) do
						local buf = vim.api.nvim_win_get_buf(win)
						local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
						local modified = vim.api.nvim_get_option_value("modified", { buf = buf })
						local readonly = vim.api.nvim_get_option_value("readonly", { buf = buf })

						if buftype == "" and modified and not readonly then
							table.insert(writable_win_ids, win)
						end
					end

					if next(writable_win_ids) == nil then
						print("No modified buffers to save")
					end

					for _, id in ipairs(writable_win_ids) do
						local buf = vim.api.nvim_win_get_buf(id)

						vim.api.nvim_buf_call(buf, function()
							vim.cmd("w")
						end)
						require("barbecue.ui").update(id)
					end

					local marker_file = vim.fn.findfile("nx.json", vim.fn.expand("%:p:h") .. ";")
					if #marker_file > 0 then
						vim.g["test#javascript#runner"] = "nx"
					else
						vim.g["test#javascript#runner"] = "jest"
					end

					vim.cmd(":" .. cmd_name)
				end,
				desc = "Run nearest test",
			},
			{
				"<leader>tf",
				function()
					local cmd_name = "TestFile"
					local win_ids = vim.api.nvim_list_wins()

					local writable_win_ids = {}
					for _, win in ipairs(win_ids) do
						local buf = vim.api.nvim_win_get_buf(win)
						local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
						local modified = vim.api.nvim_get_option_value("modified", { buf = buf })
						local readonly = vim.api.nvim_get_option_value("readonly", { buf = buf })

						if buftype == "" and modified and not readonly then
							table.insert(writable_win_ids, win)
						end
					end

					if next(writable_win_ids) == nil then
						print("No modified buffers to save")
					end

					for _, id in ipairs(writable_win_ids) do
						local buf = vim.api.nvim_win_get_buf(id)

						vim.api.nvim_buf_call(buf, function()
							vim.cmd("w")
						end)
						require("barbecue.ui").update(id)
					end

					local marker_file = vim.fn.findfile("nx.json", vim.fn.expand("%:p:h") .. ";")
					if #marker_file > 0 then
						vim.g["test#javascript#runner"] = "nx"
					else
						vim.g["test#javascript#runner"] = "jest"
					end

					vim.cmd(":" .. cmd_name)
				end,
				desc = "Run all tests in the current file",
			},
		},
	},
	{
		"nvim-neotest/neotest",
		event = {
			"BufEnter *.test.[tj]s",
			"BufEnter *.spec.[tj]s",
		},
		dependencies = {
			"nvim-neotest/neotest-jest",
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{

				"<leader>no",
				function()
					require("neotest").output_panel.toggle()
					local win = vim.fn.bufwinid("Neotest Output Panel")
					if win > -1 then
						vim.api.nvim_set_current_win(win)
					end
				end,
			},
			{
				"<leader>Tn",
				function()
					require("neotest").run.run()
				end,
			},
			{
				"<leader>Dn",
				function()
					require("neotest").run.run({ strategy = "dap" })
				end,
			},
			{
				"<leader>Tf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
			},
		},
		config = function()
			require("neotest").setup({
				status = {
					enabled = true,
					signs = false,
					virtual_text = true,
				},
				adapters = {
					require("neotest-jest")({}),
				},
			})
		end,
	},
}
