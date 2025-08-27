return {
	"CopilotC-Nvim/CopilotChat.nvim",
	cmd = { "CopilotChat", "CopilotChatToggle", "CopilotChatCommit" },
	-- commit = "7e6583c75f1231ea1eac70e06995dd3f97a58478",
	enabled = function()
		local is_headless = #vim.api.nvim_list_uis() == 0
		if is_headless then
			return false
		end
		return true
	end,
	branch = "main",
	dependencies = {
		-- { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
		{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		{ "nvim-telescope/telescope.nvim" },
	},
	build = "make tiktoken", -- Only on MacOS or Linux
	opts = {
		default = { "copilot" },
		chat_autocomplete = true,
		highlight_selection = true, -- Highlight selection
		highlight_headers = true, --
    selection = 'visual',
		-- selection = function(source)
		-- 	-- return require("CopilotChat.select").visual(source) or require("CopilotChat.select").line(source)
		-- 	return require("CopilotChat.select").visual(source) or require("CopilotChat.select").buffer(source)
		--
		-- 	-- return require("CopilotChat.select").visual(source)
		-- 	-- 	or require("CopilotChat.select").line(source)
		-- 	-- 	or require("CopilotChat.select").buffer(source)
		-- end,
		providers = {
			copilot = {
				-- see config.lua for implementation
			},
			github_models = {
				disabled = true,
			},
		},
		log_level = "fatal",
		-- sticky = { "@neovim", "@mcp", "@copilot" },
		-- question_header = '# User ', -- Header to use for user questions
		-- answer_header = '#  ', -- Header to use for AI answers
		-- error_header = '# Error ', -- Header to use for errors
		mappings = {
			complete = { insert = "<Tab>" },
			toggle_sticky = {
				detail = "Makes line under cursor sticky or deletes sticky line.",
				normal = "gR",
			},
			accept_diff = {
				normal = "<C-y>",
				insert = "<C-y>",
			},
			reset = {
				normal = "gX",
				insert = "<C-x>",
			},
			jump_to_diff = {
				normal = "go",
			},
			quickfix_diffs = {
				normal = "gqq",
			},
			yank_diff = {
				normal = "gy",
				register = '"',
			},
			show_diff = {
				normal = "gh",
				full_diff = true,
			},
			show_info = {
				normal = "gi",
			},
			show_context = {
				normal = "gc",
			},
			show_help = {
				normal = "g?",
			},
		},
		window = {
			layout = "vertical", -- 'vertical', 'horizontal', 'float', 'replace'
			width = 0.40, -- fractional width of parent, or absolute width in columns when > 1
			height = 0.45, -- fractional height of parent, or absolute height in rows when > 1
			-- Options below only apply to floating windows
			relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
			border = "rounded", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
			row = nil, -- row position of the window, default is centered
			col = nil, -- column position of the window, default is centered
			title = "Copilot Chat", -- title of chat window
			footer = "footer", -- footer of chat window
			zindex = 1, -- determines if window is on top or below other floating windows
		},

		-- See Configuration section for options
		callback = function()
			local chat = require("CopilotChat")
			if vim.g.chat_title then
				-- print("saving chat quickly")
				chat.save(vim.g.chat_title)
				return
			end

			local cwd = vim.fn.getcwd()
			local wt_utils = require("jg.custom.worktree-utils")
			local wt_info = wt_utils.get_wt_info(cwd)
			-- print("wt_info", vim.inspect(wt_info))

			if next(wt_info) == nil then
				vim.g.chat_title = vim.trim(cwd:gsub("/", "_"))
			else
				-- print("wt_root_dir", wt_info["wt_root_dir"])
				vim.g.chat_title = vim.trim(wt_info["wt_root_dir"]:gsub("/", "_"))
			end
			-- print("vim.g.chat_title", vim.g.chat_title)
			chat.save(vim.g.chat_title)
		end,
		contexts = {
			file = {
				input = function(callback)
					local telescope = require("telescope.builtin")
					local actions = require("telescope.actions")
					local action_state = require("telescope.actions.state")
					telescope.find_files({
						hidden = true,
						find_command = {
							"rg",
							"--files",
							"--color",
							"never",
							"--glob=!.git",
							"--glob=!*__template__",
							"--glob=!*DS_Store",
						},
						attach_mappings = function(prompt_bufnr)
							actions.select_default:replace(function()
								actions.close(prompt_bufnr)
								local selection = action_state.get_selected_entry()
								callback(selection[1])
							end)
							return true
						end,
					})
				end,
			},
		},
	},
	keys = {
		{
			"<leader>cx",
			function()
				local chat = require("CopilotChat")
				vim.g.chat_title = nil
				chat.reset()
			end,
			desc = "CopilotChat - Prompt actions",
		},

		-- { "<leader>ct", mode = { "n", "v" }, "<cmd>CopilotChatToggle<CR>", desc = "Toggle Copilot" },
		{
			"<M-m>",
			mode = { "t" },
			function()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
				-- local chat = require("CopilotChat")
				-- chat.toggle()
				local chat = require("CopilotChat")

				local cwd = vim.fn.getcwd()
				local wt_utils = require("jg.custom.worktree-utils")
				local wt_info = wt_utils.get_wt_info(cwd)

				if next(wt_info) == nil then
					vim.g.chat_title = vim.trim(cwd:gsub("/", "_"))
				else
					vim.g.chat_title = vim.trim(wt_info["wt_root_dir"]:gsub("/", "_"))
				end

				-- print("<leader>ct vim.g.chat_title: ", vim.g.chat_title)

				local existing_chat_path = vim.fn.stdpath("data")
					.. "/copilotchat_history/"
					.. vim.g.chat_title
					.. ".json"
				-- print("existing_chat_path: ", existing_chat_path)

				local chat_exits = wt_utils.file_exists(existing_chat_path)

				if chat_exits then
					chat.toggle()
					chat.load(vim.g.chat_title)
				else
					chat.toggle()
				end
			end,
			desc = "Toggle Copilot",
		},
		{
			"<M-m>",
			mode = { "n", "v", "t" },
			function()
				-- local chat = require("CopilotChat")
				-- chat.toggle()
				local chat = require("CopilotChat")

				local cwd = vim.fn.getcwd()
				local wt_utils = require("jg.custom.worktree-utils")
				local wt_info = wt_utils.get_wt_info(cwd)

				if next(wt_info) == nil then
					vim.g.chat_title = vim.trim(cwd:gsub("/", "_"))
				else
					vim.g.chat_title = vim.trim(wt_info["wt_root_dir"]:gsub("/", "_"))
				end

				-- print("<leader>ct vim.g.chat_title: ", vim.g.chat_title)

				local existing_chat_path = vim.fn.stdpath("data")
					.. "/copilotchat_history/"
					.. vim.g.chat_title
					.. ".json"
				-- print("existing_chat_path: ", existing_chat_path)

				local chat_exits = wt_utils.file_exists(existing_chat_path)

				if chat_exits then
					chat.toggle()
					chat.load(vim.g.chat_title)
				else
					chat.toggle()
				end
			end,
			desc = "Toggle Copilot",
		},
		{
			"<leader>ci",
			mode = { "n", "v" },
			"<cmd>CopilotChatCommit<CR>",
			desc = "Toggle Copilot",
		},
		{
			"<leader>ca",
			function()
				local actions = require("CopilotChat.actions")
				require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
			end,
			desc = "CopilotChat - Prompt actions",
		},
	},
	-- See Commands section for default commands if you want to lazy load on them
}
