return {
	{
		"olimorris/codecompanion.nvim",
    commit = "c265e25786ca0f2d1a07b4ceaa120ecbafcc5204",
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
						-- 	-- model = "claude-opus-4.5",
						-- 	-- model = "gpt-5-codex",
						-- 	model = "claude-sonnet-4.5",
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
						fold_context = false,
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
					-- vim.cmd("CodeCompanionChat Add")
					local command = ":CodeCompanionChat Add<cr>"
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(command, true, false, true), "n", true)
					vim.cmd("normal! zz")
				end,
			},
		},
	},
}
