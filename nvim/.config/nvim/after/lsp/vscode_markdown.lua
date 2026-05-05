return {
	cmd = { "vscode-markdown-language-server", "--stdio" },
	filetypes = { "markdown" },
  root_markers = { '.git', '.github' },
	-- root_dir = function(fname)
	-- 	return require("lspconfig.util").root_pattern(".marksman.toml", ".git", fname, vim.fn.getcwd())
	-- end,
	init_options = { provideFormatter = false },
}
