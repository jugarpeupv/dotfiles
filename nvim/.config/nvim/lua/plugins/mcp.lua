return {
	"ravitemer/mcphub.nvim",
	dependencies = {
		{ "nvim-lua/plenary.nvim" }, -- Required for Job and HTTP requests
		-- { "stevearc/overseer.nvim" }
		-- {
		-- 	"Joakker/lua-json5",
		-- 	build = "./install.sh",
		-- },
	},
	-- comment the following line to ensure hub will be ready at the earliest

	ft = { "copilot-chat" },
	cmd = "MCPHub", -- lazy load by default
	-- event = { "BufReadPost", "BufNewFile" }, -- Load on buffer read or new file
	build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module

	-- uncomment this if you don't want mcp-hub to be available globally or can't use -g
	-- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
	-- init = function()
	--   -- local workspace_root = vim.fs.root(0, { ".git" }) or vim.uv.cwd()
	--   -- print("MCPHub: Setting workspace root to " .. workspace_root)
	--   -- vim.fn.setenv("MCP_PROJECT_ROOT_PATH", workspace_root)
	--    vim.fn.setenv("TAVILY_API_KEY", os.getenv("TAVILY_API_KEY"))
	--    vim.fn.setenv("GH_ACTIONS_PAT", os.getenv("GH_ACTIONS_PAT"))
	-- end,
	-- init = function()
	-- 	local wt_utils = require("jg.custom.worktree-utils")
	-- 	local cwd = vim.loop.cwd()
	-- 	local root_dir = cwd
	-- 	local has_worktrees = wt_utils.has_worktrees(cwd)
	-- 	if has_worktrees then
	-- 		local file_utils = require("jg.custom.file-utils")
	-- 		local key = vim.fn.fnamemodify(cwd or "", ":p")
	-- 		local bps_path = file_utils.get_bps_path(key)
	-- 		local data = file_utils.load_bps(bps_path)
	-- 		if data == nil then
	-- 			return
	-- 		end
	-- 		if next(data) == nil or data.last_active_wt == nil then
	-- 			return
	-- 		end
	-- 		root_dir = data.last_active_wt
	-- 	end
	-- 	if root_dir ~= nil then
	-- 		-- Set the environment variable before loading the config
	-- 		-- Used by MCP servers that require project's root path as an argument
	-- 		vim.fn.setenv("MCP_PROJECT_ROOT_PATH", root_dir)
	-- 	end
	-- end,
	opts = {
		-- global_env = {
		-- 	"GITHUB_PERSONAL_ACCESS_TOKEN",
		-- }, -- Global environment variables available to all MCP servers (can be a table or a function returning a table)
    global_env = function(context)
      return {
        GH_MCP_TOKEN = os.getenv("GH_MCP_TOKEN") or "",
        TAVILY_API_KEY = os.getenv("TAVILY_API_KEY") or "",
      }
    end,
		-- port = 2389,
		-- json_decode = require("json5").parse,
		-- json_decode = require("overseer.json").decode,
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
		-- config = vim.fn.expand("~/.config/mcpservers.json"),
		-- log = {
		--   level = vim.log.levels.WARN,
		--   to_file = false,
		--   file_path = nil,
		--   prefix = "MCPHub",
		-- },
	},
	config = function(_, opts)
		require("mcphub").setup(opts)
	end,
	-- config = function()
	-- 	-- require("mcphub").setup({
	-- 	-- 	extensions = {
	-- 	-- 		codecompanion = {
	-- 	-- 			-- Show the mcp tool result in the chat buffer
	-- 	-- 			show_result_in_chat = true,
	-- 	-- 			make_vars = true, -- make chat #variables from MCP server resources
	-- 	-- 			make_slash_commands = true, -- make /slash_commands from MCP server prompts
	-- 	-- 		},
	-- 	-- 		avante = {
	-- 	-- 			make_slash_commands = true, -- make /slash commands from MCP server prompts
	-- 	-- 		},
	-- 	-- 	},
	-- 	-- })
	--    vim.cmd([[hi MCPHubNormal guibg=none]])
	-- end,
}
