local capabilities_json_ls = vim.lsp.protocol.make_client_capabilities()
capabilities_json_ls.textDocument.completion.completionItem.snippetSupport = true

return {
	filetypes = { "jsonc", "json", "json5" },
	capabilities = capabilities_json_ls,
	-- init_options = {
	--   provideFormatter = true,
	-- },
	settings = {
		json = {
			-- schemas = require("schemastore").json.schemas({}),
			format = {
				enable = true,
			},
			validate = {
				enable = true,
			},
		},
	},
}
