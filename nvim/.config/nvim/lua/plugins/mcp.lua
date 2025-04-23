return {
	"ravitemer/mcphub.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
	},
	-- comment the following line to ensure hub will be ready at the earliest
	cmd = "MCPHub", -- lazy load by default
	build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
	-- uncomment this if you don't want mcp-hub to be available globally or can't use -g
	-- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
	config = function()
		require("mcphub").setup({
			extensions = {
				codecompanion = {
					-- Show the mcp tool result in the chat buffer
					show_result_in_chat = true,
					make_vars = true, -- make chat #variables from MCP server resources
					make_slash_commands = true, -- make /slash_commands from MCP server prompts
				},
				avante = {
					make_slash_commands = true, -- make /slash commands from MCP server prompts
				},
			},
		})
    vim.cmd([[hi MCPHubNormal guibg=none]])
	end,
}
