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
	-- "ej-shafran/compile-mode.nvim",
	 -- dir = "~/projects/compile-mode.nvim/wt-compile-mode-main/",
	 -- dev = true,
  "jugarpeupv/compile-mode.nvim",
	-- tag = "v5.*",
	-- branch = "latest",
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
		-- Global: jump to next/prev error from any buffer.
		-- Opens the compilation buffer in a split if not visible,
		-- moves the compilation cursor to the error, then jumps to source.
		{
			mode = { "n" },
			"<C-S-N>",
			"<Cmd>NextError<CR>",
			{ noremap = true, silent = true, desc = "Next compile error" },
		},
		{
			mode = { "n" },
			"<C-S-P>",
			"<Cmd>PrevError<CR>",
			{ noremap = true, silent = true, desc = "Prev compile error" },
		},
		-- Global: recompile from any buffer.
		{
			mode = { "n" },
			"<leader>ro",
			"<Cmd>Recompile<CR>",
			{ noremap = true, silent = true, desc = "Recompile" },
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
      error_locus_highlight = 500,
			hidden_buffer = false,
			focus_compilation_buffer = true,
			use_circular_error_navigation = true,
			ask_about_save = true,
			auto_jump_to_first_error = false,
			ask_to_interrupt = false,
			use_pseudo_terminal = true,
			auto_scroll = true,
			error_regexp_table = {
				typescript = {
					-- TypeScript errors take the form
					-- "path/to/error-file.ts(13,23): error TS22: etc."
					regex = "^\\(.\\+\\)(\\([1-9][0-9]*\\),\\([1-9][0-9]*\\)): error TS[1-9][0-9]*:",
					filename = 1,
					row = 2,
					col = 3,
				},
				rust = {
					-- Rust errors take the form
					-- "--> path/to/error-file.rs:12:20"
					regex = "^[[:space:]]*--> \\([^:]*\\):\\([1-9][0-9]*\\):\\([1-9][0-9]*\\)",
					filename = 1,
					row = 2,
					col = 3,
					priority = 10,
				},
			},
		}

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "compilation",
			group = vim.api.nvim_create_augroup("ftcompilemode", { clear = true }),
			callback = function()
				-- vim.bo.buflisted = true
				-- vim.keymap.set({ "n" }, "<C-q>", function()
				-- 	require("compile-mode").add_to_qflist()
				-- 	print("Added all errors to quickfix list")
				-- end, { noremap = true, silent = true, buffer = true })

				vim.keymap.set({ "n" }, "r", "<Cmd>Recompile<CR>", { noremap = true, silent = true, buffer = true })

				vim.keymap.set({ "n" }, "<c-q>", function()
					require("compile-mode").send_to_qflist()
          vim.cmd("copen")
				end, { noremap = true, silent = true, buffer = true })

				vim.keymap.set(
					{ "n" },
					"<C-S-O>",
					"<Cmd>CompileGotoError<CR>",
					{ noremap = true, silent = true, buffer = true }
				)
				vim.keymap.set(
					{ "n" },
					"<C-S-N>",
					"<Cmd>CompileNextError<CR>",
					{ noremap = true, silent = true, buffer = true }
				)
				vim.keymap.set(
					{ "n" },
					"<C-S-P>",
					"<Cmd>CompilePrevError<CR>",
					{ noremap = true, silent = true, buffer = true }
				)
			end,
		})
	end,
}
