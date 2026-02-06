return {
	init_options = require("jg.custom.lsp-utils").get_gh_actions_init_options(),
	-- init_options = {
	-- 	sessionToken = os.getenv("GH_ACTIONS_PAT"),
	-- 	repos = {},
	-- },
	handlers = {
		["actions/readFile"] = function(_, result)
			if type(result.path) ~= "string" then
				-- return nil, nil
        return nil, { code = -32602, message = "Invalid path parameter" }
			end
			local file_path = vim.uri_to_fname(result.path)
			if vim.fn.filereadable(file_path) == 1 then
				local f = assert(io.open(file_path, "r"))
				local text = f:read("*a")
				f:close()

				return text, nil
			end
			-- return nil, nil
      return nil, { code = -32603, message = "File not readable: " .. file_path }
		end,
	},
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
