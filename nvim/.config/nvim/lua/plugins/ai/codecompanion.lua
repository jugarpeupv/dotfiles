return {
	"olimorris/codecompanion.nvim",
	enabled = function()
		local is_headless = #vim.api.nvim_list_uis() == 0
		if is_headless then
			return false
		end
		return true
	end,
	dependencies = {
		"ravitemer/codecompanion-history.nvim",
		-- "franco-ruggeri/codecompanion-spinner.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		-- "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
		{
			"echasnovski/mini.diff",
			config = function()
				local diff = require("mini.diff")
				diff.setup({
					-- Disabled by default
					source = diff.gen_source.none(),
				})
			end,
		},
		"nvim-telescope/telescope.nvim", -- Optional: For using slash commands
		{ "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } }, -- Optional: For prettier markdown rendering
		{ "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
	},
	-- config = true,
	-- init = function()
	-- 	require("plugins.codecompanion.spinner"):init()
	-- end,
	config = function()
		require("codecompanion").setup({
			-- opts = {
			-- 	system_prompt = function(opts)
			-- 		-- return "hello"
			-- 		return "You are an AI programming assistant named 'CodeCompanion'. You are currently plugged in to the Neovim text editor on a user's machine. Your core tasks include: - Answering general programming questions. - Explaining how the code in a Neovim buffer works. - Reviewing the selected code in a Neovim buffer. - Generating unit tests for the selected code. - Proposing fixes for problems in the selected code. - Scaffolding code for a new workspace. - Finding relevant code to the user's query. - Proposing fixes for test failures. - Answering questions about Neovim. - Running tools. You must: - Follow the user's requirements carefully and to the letter. - Keep your answers short and impersonal, especially if the user responds with context outside of your tasks. - Minimize other prose. - Use Markdown formatting in your answers. - Include the programming language name at the start of the Markdown code blocks. - Surround code blocks with backticks. - Avoid including line numbers in code blocks. - Avoid wrapping the whole response in triple backticks. - Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared. - Use actual line breaks instead of '\n' in your response to begin new lines. - Use '\n' only when you want a literal backslash followed by a character 'n'. - All non-code responses must be in %s. When given a task: 1. Think step-by-step and describe your plan for what to build in pseudocode, written out in great detail, unless asked not to do so. 2. Output the code in a single code block, being careful to only return relevant code. 3. You should always generate short suggestions for the next user turns that are relevant to the conversation. 4. You can only give one reply for each conversation turn."
			-- 	end,
			-- },

			-- opts = {
			--   log_level = "ERROR", -- TRACE|DEBUG|ERROR|INFO
			--   language = "English", -- The language used for LLM responses
			--
			--   -- If this is false then any default prompt that is marked as containing code
			--   -- will not be sent to the LLM. Please note that whilst I have made every
			--   -- effort to ensure no code leakage, using this is at your own risk
			--   ---@type boolean|function
			--   ---@return boolean
			--   send_code = true,
			--
			--   job_start_delay = 100, -- Delay in milliseconds between cmd tools
			--   -- submit_delay = 2000, -- Delay in milliseconds before auto-submitting the chat buffer
			--   submit_delay = 100, -- Delay in milliseconds before auto-submitting the chat buffer
			-- },

			extensions = {
				-- spinner = {},
				mcphub = {
					callback = "mcphub.extensions.codecompanion",
					opts = {
						-- MCP Tools
						make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
						show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
						add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
						show_result_in_chat = true, -- Show tool results directly in chat buffer
						format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
						-- MCP Resources
						make_vars = true, -- Convert MCP resources to #variables for prompts
						-- MCP Prompts
						make_slash_commands = true, -- Add MCP prompts as /slash commands
					},
				},
				history = {
					enabled = true,
					opts = {
						-- Keymap to open history from chat buffer (default: gh)
						keymap = "gh",
						-- Keymap to save the current chat manually (when auto_save is disabled)
						save_chat_keymap = "sc",
						-- Save all chats by default (disable to save only manually using 'sc')
						auto_save = true,
						-- Number of days after which chats are automatically deleted (0 to disable)
						expiration_days = 100,
						-- Picker interface ("telescope" or "snacks" or "fzf-lua" or "default")
						picker = "telescope",
						-- Automatically generate titles for new chats
						auto_generate_title = false,
						---On exiting and entering neovim, loads the last chat on opening chat
						continue_last_chat = true,
						---When chat is cleared with `gx` delete the chat from history
						delete_on_clearing_chat = false,
						---Directory path to save the chats
						dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
						---Enable detailed logging for history extension
						enable_logging = false,
					},
				},
			},

			-- Example: Add spinner integration
			-- spinner = {
			-- 	enabled = true,
			-- 	interval = 100,
			-- 	symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
			-- },

			strategies = {
				chat = {
          tools = {
            opts = {
              default_tools = {
                "nx",
                "github",
                "tavily",
                "files",
                "neovim",
                "search_web"
              },
              auto_submit_errors = true, -- Send any errors to the LLM automatically?
              auto_submit_success = true, -- Send any successful output to the LLM automatically?
            },
          },
					keymaps = {
						clear = {
							modes = {
								n = "gX",
							},
							index = 6,
							callback = "keymaps.clear",
							description = "Clear Chat",
						},
						-- send = {
						-- 	callback = function(chat)
						-- 		vim.cmd("stopinsert") -- Exit insert mode
						-- 		chat:add_buf_message({ role = "llm", content = "" }) -- Add a blank message
						-- 		chat:submit() -- Submit the request
						-- 	end,
						-- 	index = 1,
						-- 	description = "Send",
						-- },
					},
				},
			},
			display = {
				diff = {
					enabled = true,
					close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
					layout = "vertical", -- vertical|horizontal split for default provider
					opts = {
						"internal",
						"filler",
						"closeoff",
						"algorithm:patience",
						"followwrap",
						"linematch:120",
					},
					provider = "default", -- default|mini_diff
				},
				chat = {
					show_header_separator = true, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
					start_in_insert_mode = false,
					separator = "─", -- The separator between the different messages in the chat buffer

					window = {
						layout = "buffer", -- float|vertical|horizontal|buffer
						position = nil, -- left|right|top|bottom (nil will default depending on vim.opt.splitright|vim.opt.splitbelow)
						border = "single",
						height = 0.8,
						width = 0.45,
						relative = "editor",
						full_height = true, -- when set to false, vsplit will be used to open the chat buffer vs. botright/topleft vsplit
						sticky = false, -- when set to true and `layout` is not `"buffer"`, the chat buffer will remain opened when switching tabs
						opts = {
							breakindent = true,
							cursorcolumn = false,
							cursorline = true,
							foldcolumn = "0",
							linebreak = true,
							list = false,
							numberwidth = 1,
							signcolumn = "no",
							spell = false,
							wrap = true,
						},
					},
				},
			},
		})
	end,
	keys = {
		-- {
		-- 	mode = { "n", "v", "t", "i" },
		-- 	"<M-m>",
		-- 	function()
		-- 		require("codecompanion").toggle()
		-- 	end,
		-- 	desc = "Toggle Copilot",
		-- },
		{ mode = { "n", "v" }, "<leader>ca", "<cmd>CodeCompanionChat Toggle<CR>" },
		{ mode = { "v" }, "ga", "<cmd>CodeCompanionChat Add<CR>" },
	},
}
