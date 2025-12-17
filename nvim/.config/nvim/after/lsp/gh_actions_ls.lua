return {
	init_options = require("jg.custom.lsp-utils").get_gh_actions_init_options(),
	-- init_options = {
	-- 	sessionToken = os.getenv("GH_ACTIONS_PAT"),
	-- 	repos = {},
	-- },
	filetypes = { "yaml.github" },
	cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/gh-actions-language-server", "--stdio" },
	settings = {
		yaml = {
			format = {
				enable = true,
			},
			validate = {
				enable = true,
			},
		},
	},
}
