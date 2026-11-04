return {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
	root_markers = {
		".clangd",
		".clang-tidy",
		".clang-format",
		"compile_commands.json",
		"compile_flags.txt",
		"configure.ac",
		".git",
	},
	capabilities = {
		textDocument = {
			completion = {
				editsNearCursor = true,
			},
		},
		offsetEncoding = { "utf-8", "utf-16" },
	},
	-- Ignore clangd diagnostics entirely (no gutter signs, no extmarks, no
	-- entries in vim.diagnostic / quickfix). Completion, go-to-definition,
	-- hover, references, etc. keep working: they are separate LSP methods.
	handlers = {
		["textDocument/publishDiagnostics"] = function() end,
	},
}
