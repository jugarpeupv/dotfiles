return {
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
					default = {
						description = "Collection of common files for all projects",
						files = {
							-- ".clinerules",
							-- ".cursorrules",
							-- ".goosehints",
							-- ".rules",
							-- ".windsurfrules",
							".github/copilot-instructions.md",
							"AGENT.md",
							"AGENTS.md",
              { path = "~/.config/opencode/AGENTS.md", parser = "claude" },
							-- { path = "CLAUDE.md", parser = "claude" },
							-- { path = "CLAUDE.local.md", parser = "claude" },
							-- { path = "~/.claude/CLAUDE.md", parser = "claude" },
						},
						is_preset = true,
					},
					opts = {
						chat = {
							enabled = true,
							default_rules = "default", -- The rule groups to load
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
								-- model = "claude-sonnet-4.5"
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
						opts = {
							completion_provider = "blink", -- blink|cmp|coc|default
						},
						adapter = "opencode",
						-- adapter = {
						-- 	name = "copilot",
						-- 	-- model = "gpt-5.1-codex",
						-- 	model = "claude-opus-4.5",
						-- 	-- model = "gpt-5-codex",
						-- 	-- model = "claude-sonnet-4.5",
						-- 	-- model = "gpt-5.1",
						-- },
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
							["cmd_runner"] = {
								opts = {
									require_cmd_approval = false,
								},
							},
							["create_file"] = {
								opts = {
									require_cmd_approval = false,
								},
							},
							["file_search"] = {
								opts = {
									require_cmd_approval = false,
								},
							},
							["get_changed_files"] = {
								opts = {
									require_cmd_approval = false,
								},
							},
							["grep_search"] = {
								opts = {
									require_cmd_approval = false,
								},
							},
							["insert_edit_into_file"] = {
								opts = {
									require_cmd_approval = false,
								},
							},
							["list_code_usages"] = {
								opts = {
									require_cmd_approval = false,
								},
							},
							["read_file"] = {
								opts = {
									require_cmd_approval = false,
								},
							},
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
	{
		-- "sudo-tee/opencode.nvim",
		dev = true,
		dir = "~/work/tmp/opencode.nvim/wt-feature-auto_scroll_config",
		lazy = true,
		enabled = false,
		keys = {
			{
				"<C-.>",
				function()
					require("opencode.api").toggle()
				end,
			},
		},
		config = function()
			-- Default configuration with all available options
			require("opencode").setup({
				preferred_picker = "telescope", -- 'telescope', 'fzf', 'mini.pick', 'snacks', 'select', if nil, it will use the best available picker. Note mini.pick does not support multiple selections
				preferred_completion = "blink", -- 'blink', 'nvim-cmp','vim_complete' if nil, it will use the best available completion
				default_global_keymaps = false, -- If false, disables all default global keymaps
				default_mode = "build", -- 'build' or 'plan' or any custom configured. @see [OpenCode Agents](https://opencode.ai/docs/modes/)
				keymap_prefix = "", -- Default keymap prefix for global keymaps change to your preferred prefix and it will be applied to all keymaps starting with <leader>o
				keymap = {
					editor = {
						["<C-.>"] = { "toggle" }, -- Open opencode. Close if opened
						["<leader>og"] = { "open_input_new_session" }, -- Open opencode. Close if opened
						["<leader>oi"] = false, -- Opens and focuses on input window on insert mode
						["<leader>oI"] = false, -- Opens and focuses on input window on insert mode. Creates a new session
						["<leader>oo"] = false, -- Opens and focuses on output window
						["<leader>ot"] = false, -- Toggle focus between opencode and last window
						["<leader>oT"] = { "timeline" }, -- Display timeline picker to navigate/undo/redo/fork messages
						["<leader>oQ"] = { "close" }, -- Close UI windows
						["<leader>oS"] = { "select_session" }, -- Select and load a opencode session
						["<leader>oR"] = { "rename_session" }, -- Rename current session
						["<leader>oP"] = { "configure_provider" }, -- Quick provider and model switch from predefined list
						["<leader>oZ"] = { "toggle_zoom" }, -- Zoom in/out on the Opencode windows
						["<leader>oV"] = { "paste_image" }, -- Paste image from clipboard into current session
						["<leader>od"] = { "diff_open" }, -- Opens a diff tab of a modified file since the last opencode prompt
						["<leader>o]"] = { "diff_next" }, -- Navigate to next file diff
						["<leader>o["] = { "diff_prev" }, -- Navigate to previous file diff
						["<leader>oC"] = { "diff_close" }, -- Close diff view tab and return to normal editing
						["<leader>ora"] = { "diff_revert_all_last_prompt" }, -- Revert all file changes since the last opencode prompt
						["<leader>ort"] = { "diff_revert_this_last_prompt" }, -- Revert current file changes since the last opencode prompt
						["<leader>orA"] = { "diff_revert_all" }, -- Revert all file changes since the last opencode session
						["<leader>orT"] = { "diff_revert_this" }, -- Revert current file changes since the last opencode session
						["<leader>orr"] = { "diff_restore_snapshot_file" }, -- Restore a file to a restore point
						["<leader>orR"] = { "diff_restore_snapshot_all" }, -- Restore all files to a restore point
						["<leader>ox"] = { "swap_position" }, -- Swap Opencode pane left/right
						["<leader>oa"] = { "permission_accept" }, -- Accept permission request once
						["<leader>oA"] = { "permission_accept_all" }, -- Accept all (for current tool)
						["<leader>oD"] = { "permission_deny" }, -- Deny permission request once
						["<leader>ott"] = false, -- Toggle tools output (diffs, cmd output, etc.)
						["<leader>otr"] = false, -- Toggle reasoning output (thinking steps)
					},
					input_window = {
						["<esc>"] = false, -- Close UI windows
						["<cr>"] = { "submit_input_prompt", mode = { "n", "i" } }, -- Submit prompt (normal mode and insert mode)
						["<c-s>"] = { "submit_input_prompt", mode = { "i" } }, -- Submit prompt (normal mode and insert mode)
						["q"] = { "close" }, -- Close UI windows
						["<C-c>"] = { "cancel" }, -- Cancel opencode request while it is running
						["~"] = { "mention_file", mode = "i" }, -- Pick a file and add to context. See File Mentions section
						["@"] = { "mention", mode = "i" }, -- Insert mention (file/agent)
						["/"] = { "slash_commands", mode = "i" }, -- Pick a command to run in the input window
						["#"] = { "context_items", mode = "i" }, -- Manage context items (current file, selection, diagnostics, mentioned files)
						["<M-v>"] = { "paste_image", mode = "i" }, -- Paste image from clipboard as attachment
						["<C-i>"] = { "focus_input", mode = { "n", "i" } }, -- Focus on input window and enter insert mode at the end of the input from the output window
						-- ["<tab>"] = { "toggle_pane", mode = { "n", "i" } }, -- Toggle between input and output panes
						["<up>"] = { "prev_prompt_history", mode = { "n", "i" } }, -- Navigate to previous prompt in history
						["<down>"] = { "next_prompt_history", mode = { "n", "i" } }, -- Navigate to next prompt in history
						["<tab>"] = { "switch_mode" }, -- Switch between modes (build/plan)
						["<M-m>"] = false,
					},
					output_window = {
						["<esc>"] = false, -- Close UI windows
						["q"] = { "close" }, -- Close UI windows
						["<C-c>"] = { "cancel" }, -- Cancel opencode request while it is running
						["]]"] = { "next_message" }, -- Navigate to next message in the conversation
						["[["] = { "prev_message" }, -- Navigate to previous message in the conversation
						["<tab>"] = { "toggle_pane", mode = { "n", "i" } }, -- Toggle between input and output panes
						["i"] = { "focus_input", "n" }, -- Focus on input window and enter insert mode at the end of the input from the output window
						["<leader>oS"] = { "select_child_session" }, -- Select and load a child session
						["<leader>oD"] = { "debug_message" }, -- Open raw message in new buffer for debugging
						["<leader>oO"] = { "debug_output" }, -- Open raw output in new buffer for debugging
						["<leader>ods"] = { "debug_session" }, -- Open raw session in new buffer for debugging
					},
					permission = {
						accept = "<C-x>a", -- Accept permission request once (only available when there is a pending permission request)
						accept_all = "<C-x>A", -- Accept all (for current tool) permission request once (only available when there is a pending permission request)
						deny = "<C-x>d", -- Deny permission request once (only available when there is a pending permission request)
					},
					session_picker = {
						rename_session = { "<C-r>" }, -- Rename selected session in the session picker
						delete_session = { "<C-d>" }, -- Delete selected session in the session picker
						new_session = { "<C-n>" }, -- Create and switch to a new session in the session picker
					},
					timeline_picker = {
						undo = { "<C-u>", mode = { "i", "n" } }, -- Undo to selected message in timeline picker
						fork = { "<C-f>", mode = { "i", "n" } }, -- Fork from selected message in timeline picker
					},
					history_picker = {
						delete_entry = { "<C-d>", mode = { "i", "n" } }, -- Delete selected entry in the history picker
						clear_all = { "<C-X>", mode = { "i", "n" } }, -- Clear all entries in the history picker
					},
				},
				ui = {
					position = "right", -- 'right' (default), 'left' or 'current'. Position of the UI split. 'current' uses the current window for the output.
					input_position = "bottom", -- 'bottom' (default) or 'top'. Position of the input window
					window_width = 0.45, -- Width as percentage of editor width
					zoom_width = 0.6, -- Zoom width as percentage of editor width
					input_height = 0.15, -- Input height as percentage of window height
					display_model = true, -- Display model name on top winbar
					display_context_size = true, -- Display context size in the footer
					display_cost = true, -- Display cost in the footer
					window_highlight = "Normal:OpencodeBackground,FloatBorder:OpencodeBorder", -- Highlight group for the opencode window
					icons = {
						preset = "nerdfonts", -- 'nerdfonts' | 'text'. Choose UI icon style (default: 'nerdfonts')
						overrides = {}, -- Optional per-key overrides, see section below
					},
					output = {
						rendering = {
							markdown_debounce_ms = 250,
							on_data_rendered = nil,
							event_throttle_ms = 40,
							event_collapsing = true,
						},
						tools = {
							show_output = true,
							show_reasoning_output = true,
						},
						auto_scroll = false,
						always_scroll_to_bottom = false,
					},
					input = {
						text = {
							wrap = true, -- Wraps text inside input window
						},
					},
					completion = {
						file_sources = {
							enabled = true,
							preferred_cli_tool = "server", -- 'fd','fdfind','rg','git','server' if nil, it will use the best available tool, 'server' uses opencode cli to get file list (works cross platform) and supports folders
							ignore_patterns = {
								"^%.git/",
								"^%.svn/",
								"^%.hg/",
								"node_modules/",
								"%.pyc$",
								"%.o$",
								"%.obj$",
								"%.exe$",
								"%.dll$",
								"%.so$",
								"%.dylib$",
								"%.class$",
								"%.jar$",
								"%.war$",
								"%.ear$",
								"target/",
								"build/",
								"dist/",
								"out/",
								"deps/",
								"%.tmp$",
								"%.temp$",
								"%.log$",
								"%.cache$",
							},
							max_files = 10,
							max_display_length = 50, -- Maximum length for file path display in completion, truncates from left with "..."
						},
					},
				},
				context = {
					enabled = true, -- Enable automatic context capturing
					cursor_data = {
						enabled = false, -- Include cursor position and line content in the context
					},
					diagnostics = {
						info = false, -- Include diagnostics info in the context (default to false
						warn = true, -- Include diagnostics warnings in the context
						error = true, -- Include diagnostics errors in the context
					},
					current_file = {
						enabled = true, -- Include current file path and content in the context
					},
					selection = {
						enabled = true, -- Include selected text in the context
					},
				},
				debug = {
					enabled = false, -- Enable debug messages in the output window
				},
				prompt_guard = nil, -- Optional function that returns boolean to control when prompts can be sent (see Prompt Guard section)

				-- User Hooks for custom behavior at certain events
				hooks = {
					on_file_edited = nil, -- Called after a file is edited by opencode.
					on_session_loaded = nil, -- Called after a session is loaded.
					on_done_thinking = nil, -- Called when opencode finishes thinking (all jobs complete).
					on_permission_requested = nil, -- Called when a permission request is issued.
				},
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"MeanderingProgrammer/render-markdown.nvim",
			},
			"saghen/blink.cmp",

			"folke/snacks.nvim",
		},
	},
}
