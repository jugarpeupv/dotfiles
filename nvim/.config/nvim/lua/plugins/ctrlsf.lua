vim.g.ctrlsf_context = "-C 0"
vim.g.ctrlsf_populate_qflist = 1
vim.g.ctrlsf_auto_preview = 1
vim.cmd([[let g:ctrlsf_auto_preview = 1]])
vim.g.ctrlsf_fold_result = 0
-- vim.g.ctrlsf_preview_position = 'inside'
vim.g.ctrlsf_auto_close = {
	normal = 0,
	compact = 0,
}
-- vim.g.ctrlsf_position = "left_local"
vim.g.ctrlsf_position = "right"
vim.g.ctrlsf_mapping = {
	open = { "<CR>", "o" },
	openb = "O",
	split = "<C-X>",
	vsplit = { "<C-V>", "gd" },
	tab = "t",
	tabb = "T",
	popen = "p",
	popenf = "P",
	quit = "q",
	next = "<C-J>",
	prev = "<C-K>",
	-- nfile   = "<C-N>",
	-- pfile   = "<C-P>",
	pquit = "q",
	loclist = "",
	chgmode = "M",
	stop = "<C-C>",
}
-- return {}
return {
	{
		"dyng/ctrlsf.vim",
		keys = {
			{ mode = { "n" }, "<leader>sf", "<Plug>CtrlSFCwordPath" },
			{ mode = { "n" }, "<leader>st", "<cmd>CtrlSFToggle<cr>", desc = "CtrlSF Toggle" },
		},
		-- branch = "feature/add-devicon",
		event = { "BufRead", "BufNewFile"},
		-- cmd = { "CtrlSFCwordPath", "CtrlSFToggle", "CtrlSF" },
	},
}
