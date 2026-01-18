return {
	cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/marksman", "server" },
	root_dir = function(fname)
		if type(fname) == "number" then
			fname = vim.api.nvim_buf_get_name(fname)
		end

		if type(fname) ~= "string" or fname == "" then
			return nil
		end

		if fname:match("^diffview://") or fname:match("^fugitive://") then
			return nil -- Don't start LSP for these buffers
		end

		return require("lspconfig.util").root_pattern(".git")(fname)
	end,
}
