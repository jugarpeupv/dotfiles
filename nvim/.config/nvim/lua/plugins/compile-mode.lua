local function jump_to_compilation_buffer()
	local buf_name = vim.api.nvim_buf_get_name(0)
	if buf_name:match("*compilation*") then
		vim.cmd("close")
	else
		local buffers = vim.api.nvim_list_bufs()
		for _, buf in ipairs(buffers) do
			buf_name = vim.api.nvim_buf_get_name(buf)
			if string.match(buf_name, "compilation") then
				local windows = vim.api.nvim_list_wins()
				for _, win in ipairs(windows) do
					if vim.api.nvim_win_get_buf(win) == buf then
						vim.api.nvim_set_current_win(win)
            -- require("baleia").setup({}).automatically(buf)
            -- -- vim.g.baleia.automatically(buf)
						return
					end
				end
				vim.cmd("split")
				vim.api.nvim_set_current_buf(buf)
				return
			end
		end
		print("No compilation buffer found")
	end
end

return {
	"ej-shafran/compile-mode.nvim",
	-- tag = "v5.*",
	branch = "latest",
	cmd = {
		"Compile",
		"Recompile",
		"FirstError",
		"CurrentError",
		"NextError",
		"PrevError",
		"QuickfixErrors",
		"NextErrorFollow",
		"CompileGotoError",
		"CompileDebugErro",
		"CompileNextError",
		"CompileNextFile",
		"CompilePrevError",
		"CompilePrevFile",
		"CompileInterrupt",
	},
	keys = {
		{
			mode = { "n" },
			"<leader>cu",
			function()
				jump_to_compilation_buffer()
			end,
			{ noremap = true, silent = true },
		},
		{
			mode = { "n" },
			"<leader>cs",
			function()
				require("jg.custom.telescope").compile_mode_on_npm_scripts()
			end,
			{ noremap = true, silent = true },
		},
	},
	-- you can just use the latest version:
	-- branch = "latest",
	-- or the most up-to-date updates:
	-- branch = "nightly",
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- if you want to enable coloring of ANSI escape codes in
		-- compilation output, add:
		{ "m00qek/baleia.nvim", tag = "v1.3.0" },
	},
	config = function()
		vim.g.compile_mode = {
			baleia_setup = true,
			use_diagnostics = false,
			error_locus_highlight = false,
			ask_about_save = false,
			ask_to_interrupt = false,
			error_regexp_table = {
				typescript = {
					-- TypeScript errors take the form
					-- "path/to/error-file.ts(13,23): error TS22: etc."
					regex = "^\\(.\\+\\)(\\([1-9][0-9]*\\),\\([1-9][0-9]*\\)): error TS[1-9][0-9]*:",
					filename = 1,
					row = 2,
					col = 3,
				},
			},
		}

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "compilation",
			callback = function()
				vim.bo.buflisted = true
				vim.keymap.set({ "n" }, "<C-a>", function()
					require("compile-mode").add_to_qflist()
					print("Added all errors to quickfix list")
				end, { noremap = true, silent = true, buffer = true })

				vim.keymap.set({ "n" }, "r", "<Cmd>Recompile<CR>", { noremap = true, silent = true, buffer = true })
				vim.keymap.set(
					{ "n" },
					"sn",
					"<Cmd>CompileNextError<CR>",
					{ noremap = true, silent = true, buffer = true }
				)
				vim.keymap.set(
					{ "n" },
					"sp",
					"<Cmd>CompilePrevError<CR>",
					{ noremap = true, silent = true, buffer = true }
				)
			end,
		})
	end,
}
