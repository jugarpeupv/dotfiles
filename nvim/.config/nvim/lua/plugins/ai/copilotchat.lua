vim.g.chat_loaded = false
vim.g.chat_title = nil

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
		callback = function(_response, _source)
			-- -- Find the buffer number by name
			-- for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			-- 	if vim.api.nvim_buf_get_name(buf):match("copilot%-chat") then
			-- 		-- Find the window displaying this buffer
			-- 		for _, win in ipairs(vim.api.nvim_list_wins()) do
			-- 			if vim.api.nvim_win_get_buf(win) == buf then
			-- 				-- Scroll to the end in that window
			-- 				vim.api.nvim_win_call(win, function()
			-- 					-- print("Scrolling to the end of Copilot Chat window")
			-- 					vim.cmd("normal! G")
			--              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-d>", true, false, true), "n", false)
			--              vim.cmd("normal! zz")
			-- 				end)
			-- 			end
			-- 		end
			-- 	end
			-- end

			local chat = require("CopilotChat")
			if vim.g.chat_title then
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
				if not wt_info["wt_root_dir"] then
					vim.g.chat_title = vim.trim(cwd:gsub("/", "_"))
					return
				end
				vim.g.chat_title = vim.trim(wt_info["wt_root_dir"]:gsub("/", "_"))
			end
			-- print("vim.g.chat_title", vim.g.chat_title)
			chat.save(vim.g.chat_title)
		end,
		default = { "copilot" },
		-- tools = { "nx", "github", "tavily", "neovim" },
		tools = {
			"neovim",
			"nx",
			"copilot",
			"tavily",
			"github_list_issues",
			"github_create_pending_pull_request_review",
			"github_get_pull_request",
			"github_list_pull_requests",
		},
		resources = { "selection", "buffer:visible" },
		sticky = nil, -- Default sticky prompt or array of sticky prompts to use at start of every new chat (can be specified manually in prompt via >).
		-- diff = "block", -- Default diff format to use, 'block' or 'unified'.
		diff = "block", -- Default diff format to use, 'block' or 'unified'.
		language = "English", -- Default language to use for answers
		chat_autocomplete = true, -- Enable chat autocompletion (when disabled, requires manual `mappings.complete` trigger)
		-- temperature = 0.1,           -- Lower = focused, higher = creative
		-- chat_autocomplete = true,
		highlight_selection = true, -- Highlight selection
		highlight_headers = true, --

		-- headers = {
		-- 	user = "User", -- Header to use for user questions
		-- 	assistant = "  Copilot", -- Header to use for AI answers
		-- 	tool = "Tool", -- Header to use for tool calls
		-- },

		separator = "━━",
		auto_fold = true, -- Automatically folds non-assistant messages
		show_help = false, -- Shows help message as virtual lines when waiting for user input
		show_folds = true, -- Shows folds for sections in chat
		headers = {
			user = "👤 You",
			assistant = "🤖 Copilot",
			tool = "🔧 Tool",
		},

		auto_follow_cursor = false, -- Auto-follow cursor in chat
		auto_insert_mode = false, -- Automatically enter insert mode when opening window and on new prompt
		insert_at_end = false, -- Move cursor to end of buffer when inserting text
		clear_chat_on_new_prompt = false, -- Clears chat on every new prompt
		stop_on_function_failure = false, -- Stop processing prompt if any function fails (preserves quota)
		selection = "visual",
		-- selection = 'visual',
		-- selection = function(source)
		-- 	-- return require("CopilotChat.select").visual(source) or require("CopilotChat.select").line(source)
		-- 	-- return require("CopilotChat.select").visual(source) or require("CopilotChat.select").buffer(source)
		--     -- return require("CopilotChat.select").buffer(source)
		--     return require("CopilotChat.select").line(source)
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
			-- complete = { insert = "<Tab>" },
			complete = { insert = "<M-`>" },
			toggle_sticky = {
				detail = "Makes line under cursor sticky or deletes sticky line.",
				normal = "gR",
			},
			accept_diff = {
				normal = "<C-b>",
				insert = "<C-b>",
			},
			reset = {
				normal = "cl",
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
			-- show_context = {
			-- 	normal = "gC",
			-- },
			show_help = {
				normal = "g?",
			},
		},

		window = {
			layout = "vertical", -- 'vertical', 'horizontal', 'float', 'replace'
			width = 0.45, -- fractional width of parent, or absolute width in columns when > 1
			height = 0.90, -- fractional height of parent, or absolute height in rows when > 1
			-- Options below only apply to floating windows
			relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
			border = "rounded", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
			row = 0, -- row position of the window, default is centered
			col = 100, -- column position of the window, default is centered
			title = "Copilot Chat", -- title of chat window
			-- footer = "footer", -- footer of chat window
			footer = "", -- footer of chat window
			zindex = 1, -- determines if window is on top or below other floating windows
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
		{
			"<leader>sc",
			function()
				local chat = require("CopilotChat")
				if vim.g.chat_title then
					chat.save(vim.g.chat_title)
					return
				end

				local cwd = vim.fn.getcwd()
				local wt_utils = require("jg.custom.worktree-utils")
				local wt_info = wt_utils.get_wt_info(cwd)

				if next(wt_info) == nil then
					vim.g.chat_title = vim.trim(cwd:gsub("/", "_"))
				else
					if not wt_info["wt_root_dir"] then
						vim.g.chat_title = vim.trim(cwd:gsub("/", "_"))
						return
					end
					vim.g.chat_title = vim.trim(wt_info["wt_root_dir"]:gsub("/", "_"))
				end
				chat.save(vim.g.chat_title)
			end,
			desc = "save chat Copilot",
		},
		{
			"<leader>lc",
			function()
				local chat = require("CopilotChat")
				local cwd = vim.fn.getcwd()
				local wt_utils = require("jg.custom.worktree-utils")
				local wt_info = wt_utils.get_wt_info(cwd)

				if next(wt_info) == nil then
					vim.g.chat_title = vim.trim(cwd:gsub("/", "_"))
				else
					if not wt_info["wt_root_dir"] then
						vim.g.chat_title = vim.trim(cwd:gsub("/", "_"))
						return
					end
					vim.g.chat_title = vim.trim(wt_info["wt_root_dir"]:gsub("/", "_"))
				end
				local existing_chat_path = vim.fn.stdpath("data")
					.. "/copilotchat_history/"
					.. vim.g.chat_title
					.. ".json"

				local chat_exits = wt_utils.file_exists(existing_chat_path)

				if chat_exits then
					chat.load(vim.g.chat_title)
				end
				vim.g.chat_loaded = true
			end,
			desc = "CopilotChat - Prompt actions",
		},
		{
			"<M-m>",
      -- "<leader>ca",
			mode = { "n", "v", "t" },
      -- mode = { "n", "v" },
			function()
				local chat = require("CopilotChat")
				if vim.g.chat_loaded then
					chat.toggle()
					return
				else
					local cwd = vim.fn.getcwd()
					local wt_utils = require("jg.custom.worktree-utils")
					local wt_info = wt_utils.get_wt_info(cwd)

					if next(wt_info) == nil then
						vim.g.chat_title = vim.trim(cwd:gsub("/", "_"))
					else
						if not wt_info["wt_root_dir"] then
							vim.g.chat_title = vim.trim(cwd:gsub("/", "_"))
							return
						end
						vim.g.chat_title = vim.trim(wt_info["wt_root_dir"]:gsub("/", "_"))
					end

					local existing_chat_path = vim.fn.stdpath("data")
						.. "/copilotchat_history/"
						.. vim.g.chat_title
						.. ".json"

					local chat_exits = wt_utils.file_exists(existing_chat_path)

					if chat_exits then
						chat.load(vim.g.chat_title)
						chat.toggle()
					else
						chat.toggle()
					end
					vim.g.chat_loaded = true
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
			"<leader>cA",
			function()
				local actions = require("CopilotChat.actions")
				require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
			end,
			desc = "CopilotChat - Prompt actions",
		},
	},
}
