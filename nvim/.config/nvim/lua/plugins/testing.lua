-- Find project root using root markers
function _G.RunVimTest(cmd_name)
	return function()
		local win_ids = vim.api.nvim_list_wins()
		print("win_ids", vim.inspect(win_ids))

		local writable_win_ids = {}
		for _, win in ipairs(win_ids) do
			local buf = vim.api.nvim_win_get_buf(win)
			-- get the buff name

			-- local buffer_name = vim.api.nvim_buf_get_name(buf)
			-- print('buffer_name', buffer_name)
			local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
			local modified = vim.api.nvim_buf_get_option(buf, "modified")
			local readonly = vim.api.nvim_buf_get_option(buf, "readonly")

      ---@diagnostic disable-next-line: unnecessary-if
			if buftype == "" and modified and not readonly then
				table.insert(writable_win_ids, win)
			end
		end

		print("writable_win_ids", vim.inspect(writable_win_ids))

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

		-- local root_markers = { "Gemfile", "package.json", ".git/", "nx.json" }
		-- for _, marker in ipairs(root_markers) do
		--   local marker_file = vim.fn.findfile(marker, vim.fn.expand('%:p:h') .. ';')
		--   if #marker_file > 0 then
		--     vim.g['test#project_root'] = vim.fn.fnamemodify(marker_file, ":p:h")
		--     break
		--   end
		--   local marker_dir = vim.fn.finddir(marker, vim.fn.expand('%:p:h') .. ';')
		--   if #marker_dir > 0 then
		--     vim.g['test#project_root'] = vim.fn.fnamemodify(marker_dir, ":p:h")
		--     break
		--   end
		--
		--   vim.g['test#javascript#runner'] = "jest"
		-- end

		local marker_file = vim.fn.findfile("nx.json", vim.fn.expand("%:p:h") .. ";")
		if #marker_file > 0 then
			vim.g["test#javascript#runner"] = "nx"
		else
			vim.g["test#javascript#runner"] = "jest"
		end

		vim.cmd(":" .. cmd_name)
	end
end

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
			{ "<leader>tn", RunVimTest("TestNearest"), desc = "Run nearest test" },
			{ "<leader>tf", RunVimTest("TestFile"), desc = "Run all tests in the current file" },
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
		config = function()
			require("neotest").setup({
				status = {
					enabled = true,
					signs = false,
					virtual_text = true,
				},
				adapters = {
					require("neotest-jest")({
					}),
				},
			})

			vim.keymap.set({ "n" }, "<leader>no", function()
				require("neotest").output_panel.toggle()
				local win = vim.fn.bufwinid("Neotest Output Panel")
				if win > -1 then
					vim.api.nvim_set_current_win(win)
				end
			end, {})

			vim.keymap.set({ "n" }, "<leader>Tn", function()
				require("neotest").run.run()
			end, {})

			vim.keymap.set({ "n" }, "<leader>Dn", function()
				require("neotest").run.run({ strategy = "dap" })
			end, {})

			vim.keymap.set({ "n" }, "<leader>Tf", function()
				require("neotest").run.run(vim.fn.expand("%"))
			end, {})
		end,
	},
}
