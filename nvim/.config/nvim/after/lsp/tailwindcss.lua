local root_pattern = require("lspconfig.util").root_pattern

return {
	filetypes = {
		"html",
		"css",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"htmlangular",
	},
	root_dir = root_pattern("tailwind.config.js", "tailwind.config.ts", "postcss.config.js", "postcss.config.ts"),
}
