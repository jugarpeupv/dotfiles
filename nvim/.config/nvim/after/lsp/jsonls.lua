local capabilities_json_ls = vim.lsp.protocol.make_client_capabilities()
capabilities_json_ls.textDocument.completion.completionItem.snippetSupport = true

return {
  cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/vscode-json-language-server", "--stdio" },
	filetypes = { "jsonc", "json", "json5" },
	capabilities = capabilities_json_ls,
	-- init_options = {
	--   provideFormatter = true,
	-- },
  -- root_markers = { ".git", "" },
	settings = {
		json = {
			schemas = require("schemastore").json.schemas({
				ignore = {
					"Applicant Profile Protocol",
          -- The **Applicant Profile Protocol (APP)** is a JSON-based open standard for structuring professional profiles, resumes, and CVs. It defines a schema for fields like skills, work experience, education, certifications, etc. — essentially a machine-readable resume format.
          --
          --   Its schema is hosted at `https://app-protocol.org/schema/app-1.0.json` and was added to the SchemaStore catalog with `fileMatch: ["*.app.json"]`, meaning any file ending in `.app.json` gets validated against it.
          --
          --   The problem is that `*.app.json` is an overly broad glob — it collides with completely unrelated files like `tsconfig.app.json`, `firebase.app.json`, or any `<name>.app.json` file that has nothing to do with resumes. This is arguably a bug in the SchemaStore catalog entry itself.
				},
			}),
			format = {
				enable = true,
			},
			validate = {
				enable = true,
			},
		},
	},
}
