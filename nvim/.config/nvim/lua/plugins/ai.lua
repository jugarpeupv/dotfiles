vim.g.chat_loaded = false
vim.g.chat_title = nil
return {
	{
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
				"tavily",
				"github",
				-- "github_list_issues",
				-- "github_create_pending_pull_request_review",
				-- "github_get_pull_request",
				-- "github_list_pull_requests",
				"neovim",
				"nx",
				-- "copilot",
			},
			resources = { "selection", "buffer" },
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
				-- "<M-m>",
				"<leader>ca",
				-- mode = { "n", "v", "t" },
				mode = { "n", "v" },
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
	},

	{
		"olimorris/codecompanion.nvim",
		enabled = function()
			local is_headless = #vim.api.nvim_list_uis() == 0
			if is_headless then
				return false
			end
			return true
		end,
		-- init = function()
		--   -- vim.cmd([[cab cc CodeCompanion]])
		--   -- require("plugins.custom.spinner"):init()
		--   require("jg.custom.codecompanion_spinner"):init()
		-- end,
		dependencies = {
			"ravitemer/codecompanion-history.nvim",
			"j-hui/fidget.nvim", -- Display status
			"ravitemer/mcphub.nvim",
			-- "franco-ruggeri/codecompanion-spinner.nvim",
			-- { "nvim-lua/plenary.nvim", branch = "master" },
			-- "folke/snacks.nvim",
			-- { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } }, -- Optional: For prettier markdown rendering
			-- { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
		},
		-- config = true,
		-- init = function()
		-- 	require("plugins.codecompanion.spinner"):init()
		-- end,
		config = function()
			require("codecompanion").setup({
				rules = {
					opts = {
						chat = {
							enabled = true,
						},
					},
				},
				adapters = {
					acp = {
						opencode = function()
							return require("codecompanion.adapters").extend("opencode", {
								commands = {
									-- The default uses the opencode/config.json value
									default = {
										"opencode",
										"acp",
									},
									github_copilot_gpt_5_1_codex = {
										"opencode",
										"acp",
										"-m",
										"github-copilot/gpt-5.1-codex",
									},
									copilot_sonnet_4_5 = {
										"opencode",
										"acp",
										"-m",
										"github-copilot/claude-sonnet-4.5",
									},
									copilot_opus_4_5 = {
										"opencode",
										"acp",
										"-m",
										"github-copilot/claude-opus-4.5",
									},
									anthropic_sonnet_4_5 = {
										"opencode",
										"acp",
										"-m",
										"anthropic/claude-sonnet-4.5",
									},
									anthropic_opus_4_5 = {
										"opencode",
										"acp",
										"-m",
										"anthropic/claude-opus-4.5",
									},
								},
							})
						end,
					},
				},

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
							picker = "snacks",
							-- Automatically generate titles for new chats
							auto_generate_title = true,
							title_generation_opts = {
								---Adapter for generating titles (defaults to current chat adapter)
								adapter = "copilot", -- "copilot"
								---Model for generating titles (defaults to current chat model)
								model = "gpt-4o", -- "gpt-4o"
							},
							---On exiting and entering neovim, loads the last chat on opening chat
							continue_last_chat = false,
							---When chat is cleared with `cl` delete the chat from history
							delete_on_clearing_chat = true,
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

				interactions = {
					chat = {
						-- adapter = "opencode",

						adapter = {
						  -- name = "opencode",
						  -- model = "claude-sonnet-4",
						  name = "copilot",
						  model = "gpt-5.1-codex",
						},
						slash_commands = {
							["image"] = {
								opts = {
									dirs = { os.getenv("HOME") .. "/Documents", os.getenv("HOME") .. "/Downloads" },
									provider = "snacks", -- telescope|fzf_lua|mini_pick|snacks|default
								},
								keymaps = {
									modes = {
										i = "<C-g>",
										n = { "<C-g>", "gi" },
									},
								},
							},
							["buffer"] = {
								keymaps = {
									modes = {
										i = "<C-b>",
										n = { "<C-b>", "gb" },
									},
								},
							},
						},
						tools = {
							groups = {
								["fagent"] = {
									description = "A custom agent combining tools",
									tools = {
										"full_stack_dev",
										"memory",
										"next_edit_suggestion",
									},
									opts = {
										collapse_tools = true, -- When true, show as a single group reference instead of individual tools
									},
								},
								["githubcustom"] = {
									description = "GitHub operations from issue to PR",
									tools = {
										-- File operations
										"neovim__read_multiple_files",
										"neovim__write_file",
										"neovim__edit_file",
										-- GitHub operations
										"github__list_issues",
										"github__get_issue",
										"github__get_issue_comments",
										"github__create_issue",
										"github__create_pull_request",
										"github__get_file_contents",
										"github__create_or_update_file",
										"github__search_code",
									},
								},
								["agentic"] = {
									description = "A custom agent combining tools",
									tools = {
										"cmd_runner",
										"create_file",
										"delete_file",
										"fetch_webpage",
										"file_search",
										"full_stack_dev",
										"get_changed_files",
										"grep_search",
										"insert_edit_into_file",
										"list_code_usages",
										"memory",
										"next_edit_suggestion",
										"read_file",
										"web_search",
									},
									opts = {
										collapse_tools = true, -- When true, show as a single group reference instead of individual tools
									},
								},
							},
							opts = {
								default_tools = {
									"full_stack_dev",
									"fetch_webpage",
									"web_search",
									"memory",
									-- "githubcustom",
									"tavily",
									"nx",
									"neovim",
								},
								-- default_tools = {
								--   "agentic"
								-- },
								auto_submit_errors = true, -- Send any errors to the LLM automatically?
								auto_submit_success = true, -- Send any successful output to the LLM automatically?
							},
						},
						keymaps = {
							clear = {
								modes = {
									n = "cl",
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
					action_palette = {
						provider = "snacks", -- or "telescope", "mini_pick", etc.
						opts = {
							-- Configure snacks picker options
							show_preview = false, -- Disable preview in the picker
						},
					},
					diff = {
						provider_opts = {
							inline = {
								layout = "buffer", -- float|buffer - Where to display the diff
								opts = {
									context_lines = 3, -- Number of context lines in hunks
									dim = 0, -- Background dim level for floating diff (0-100, [100 full transparent], only applies when layout = "float")
									full_width_removed = true, -- Make removed lines span full width
									show_keymap_hints = true, -- Show "gda: accept | gdr: reject" hints above diff
									show_removed = true, -- Show removed lines as virtual text
								},
							},
						},
					},

					-- diff = {
					-- 	enabled = true,
					-- 	-- provider = providers.diff, -- mini_diff|split|inline
					-- 	provider = "inline",
					-- 	provider_opts = {
					-- 		-- Options for inline diff provider
					-- 		inline = {
					-- 			layout = "buffer", -- float|buffer - Where to display the diff
					--
					-- 			diff_signs = {
					-- 				signs = {
					-- 					text = "▌", -- Sign text for normal changes
					-- 					reject = "✗", -- Sign text for rejected changes in super_diff
					-- 					highlight_groups = {
					-- 						addition = "DiagnosticOk",
					-- 						deletion = "DiagnosticError",
					-- 						modification = "DiagnosticWarn",
					-- 					},
					-- 				},
					-- 				-- Super Diff options
					-- 				icons = {
					-- 					accepted = " ",
					-- 					rejected = " ",
					-- 				},
					-- 				colors = {
					-- 					accepted = "DiagnosticOk",
					-- 					rejected = "DiagnosticError",
					-- 				},
					-- 			},
					--
					-- 			opts = {
					-- 				context_lines = 3, -- Number of context lines in hunks
					-- 				dim = 100, -- Background dim level for floating diff (0-100, [100 full transparent], only applies when layout = "float")
					-- 				full_width_removed = true, -- Make removed lines span full width
					-- 				show_keymap_hints = true, -- Show "gda: accept | gdr: reject" hints above diff
					-- 				show_removed = true, -- Show removed lines as virtual text
					-- 			},
					-- 		},
					--
					-- 		-- Options for the split provider
					-- 		-- split = {
					-- 		-- 	close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
					-- 		-- 	layout = "vertical", -- vertical|horizontal split
					-- 		-- 	opts = {
					-- 		-- 		"internal",
					-- 		-- 		"filler",
					-- 		-- 		"closeoff",
					-- 		-- 		"algorithm:histogram", -- https://adamj.eu/tech/2024/01/18/git-improve-diff-histogram/
					-- 		-- 		"indent-heuristic", -- https://blog.k-nut.eu/better-git-diffs
					-- 		-- 		"followwrap",
					-- 		-- 		"linematch:120",
					-- 		-- 	},
					-- 		-- },
					-- 	},
					-- },
					chat = {
						-- icons = {
						-- 	chat_context = "📎️", -- You can also apply an icon to the fold
						-- 	chat_fold = "",
						-- },
						-- intro_message = "",
						show_settings = false,
						fold_reasoning = true,
						show_reasoning = true,
						fold_context = true,
						auto_scroll = false,
						show_tools_processing = true,
						show_header_separator = true, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
						start_in_insert_mode = false,
						separator = "─", -- The separator between the different messages in the chat buffer

						window = {
							layout = "vertical", -- float|vertical|horizontal|buffer
							position = "right", -- left|right|top|bottom (nil will default depending on vim.opt.splitright|vim.opt.splitbelow)
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
								number = false,
								relativenumber = false,
								signcolumn = "no",
								spell = false,
								wrap = true,
							},
						},
					},
				},
			})
			require("jg.custom.codecompanion_spinner"):init()
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
			-- { mode = { "n", "v", "t" }, "<M-m>", "<cmd>CodeCompanionChat Toggle<CR>" },
			{
				mode = { "n", "v", "t" },
				"<M-m>",
				function()
					-- vim.cmd("CodeCompanionChat Toggle")
					require("codecompanion").toggle()
					vim.cmd("normal! zz")
					-- require()
					-- vim.cmd("normal! zz")
					-- vim.schedule(function ()
					--   vim.cmd('normal! zz')
					-- end)
				end,
			},
			-- { mode = { "n", "v" }, "<leader>ca", "<cmd>CodeCompanionChat Toggle<CR>" },
			-- { mode = { "v" }, "ga", "<cmd>CodeCompanionChat Add<CR>" },
			{
				mode = { "v" },
				"ga",
				function()
					vim.cmd("CodeCompanionChat Add")
					vim.cmd("normal! zz")
				end,
			},
		},
	},
}
