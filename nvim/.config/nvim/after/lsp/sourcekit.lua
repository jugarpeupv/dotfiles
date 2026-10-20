return {
	-- root_dir = function(filename, _)
	-- 	local util = require("lspconfig.util")
	-- 	local sourcekit_root_dir = util.root_pattern("buildServer.json")(filename)
	-- 		or util.root_pattern("*.xcodeproj", "*.xcworkspace")(filename)
	-- 		-- better to keep it at the end, because some modularized apps contain multiple Package.swift files
	-- 		or util.root_pattern("compile_commands.json", "Package.swift")(filename)
	-- 		or vim.fs.dirname(vim.fs.find(".git", { path = filename, upward = true })[1])
	-- 		or vim.fs.dirname(filename)
	-- 	print("sourcekit_root_dir: ", sourcekit_root_dir)
	-- 	return sourcekit_root_dir
	-- end,
	-- root_dir = function(filename, bufnr)
	-- 	local util = require("lspconfig.util")
	-- 	-- Intenta buscar los marcadores habituales de un proyecto Swift/Xcode
	-- 	return util.root_pattern("Package.swift", "buildServer.json")(filename)
	-- 		or require("lspconfig.util").find_git_ancestor(vim.fn.getcwd())
	-- 		or vim.fs.dirname(filename) -- Cae en el directorio del archivo actual si está en caché
	-- end,
	root_dir = function(filename, callback)
	  callback(
	    require("lspconfig.util").root_pattern("Package.swift")(vim.fn.getcwd())
	    or vim.fs.dirname(vim.fs.find('.git', { path = vim.fn.getcwd(), upward = true })[1]) or vim.fs.dirname(filename)
	  )
	end,
	cmd = { vim.trim(vim.fn.system("xcrun -f sourcekit-lsp")) },
	filetypes = { "swift", "objc", "objcpp", "c", "cpp" },
	capabilities = {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
		textDocument = {
			diagnostic = {
				dynamicRegistration = true,
				relatedDocumentSupport = true,
			},
		},
	},
}
