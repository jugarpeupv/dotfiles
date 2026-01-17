return {
	"ravitemer/mcphub.nvim",
	enabled = function()
		local is_headless = #vim.api.nvim_list_uis() == 0
		if is_headless then
			return false
		end
		return true
	end,
	dependencies = {
		{ "nvim-lua/plenary.nvim" }, -- Required for Job and HTTP requests
	},
	ft = { "copilot-chat", "codecompanion" },
	cmd = "MCPHub", -- lazy load by default
	build = "bundled_build.lua",
	opts = {
		use_bundled_binary = true,
		global_env = function(_context)
			return {
				GH_MCP_TOKEN = os.getenv("GH_MCP_TOKEN") or "",
				TAVILY_API_KEY = os.getenv("TAVILY_API_KEY") or "",
			}
		end,
		log = {
			level = vim.log.levels.DEBUG,
			to_file = true,
			file_path = vim.fn.expand("~/mcphub.log"),
			prefix = "MCPHub",
		},
		extensions = {
			copilotchat = {
				enabled = true,
				convert_tools_to_functions = true,
				convert_resources_to_functions = true,
				add_mcp_prefix = false,
			},
			avante = {
				make_slash_commands = true, -- make /slash commands from MCP server prompts
			},
		},
	},
	config = function(_, opts)
		require("mcphub").setup(opts)
	end,
}
