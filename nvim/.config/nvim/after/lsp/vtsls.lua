return {
  cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/vtsls", "--stdio" },
	settings = {
		vtsls = {
			enableMoveToFileCodeAction = true,
			autoUseWorkspaceTsdk = true,
			experimental = {
				maxInlayHintLength = 30,
				completion = {
					enableServerSideFuzzyMatch = true,
				},
			},
		},
		typescript = {
			updateImportsOnFileMove = { enabled = "always" },
			suggest = {
				completeFunctionCalls = true,
			},
			tsserver = {
				maxTsServerMemory = 8192,
			},
			preferences = {
				importModuleSpecifier = "relative",
				importModuleSpecifierEnding = "minimal",
			},
			inlayHints = {
				parameterNames = { enabled = "all" },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = false },
				enumMemberValues = { enabled = true },
			},
		},
	},
}
