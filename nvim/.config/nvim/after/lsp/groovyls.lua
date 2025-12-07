return {
  	handlers = {
  		["textDocument/publishDiagnostics"] = function() end,
  	},
  	cmd = {
  		"java",
  		"-jar",
  		os.getenv("HOME") .. "/.config/groovy-language-server/build/libs/groovy-language-server-all.jar",
  		-- "~/.local/share/nvim/mason/packages/groovy-language-server/build/libs/groovy-language-server-all.jar",
  	},
}
