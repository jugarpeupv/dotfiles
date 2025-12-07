local on_publish_diagnostics = vim.lsp.diagnostic.on_publish_diagnostics

return {
	cmd = { "bash-language-server", "start" },
	filetypes = { "bash", "sh", "yaml.github" },
	handlers = {
		["textDocument/publishDiagnostics"] = function(err, res, ...)
			local file_name = vim.fn.fnamemodify(vim.uri_to_fname(res.uri), ":t")
			if string.match(file_name, "^%.env") == nil then
				return on_publish_diagnostics(err, res, ...)
			end
		end,
	},
}
