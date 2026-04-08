return {
	{
		"olimorris/codecompanion.nvim",
		-- "aweis89/codecompanion.nvim",
		-- branch = "fix/acp-async-connection",
    enabled = true,
		-- enabled = function()
		-- 	local is_headless = #vim.api.nvim_list_uis() == 0
		-- 	if is_headless then
		-- 		return false
		-- 	end
		-- 	return true
		-- end,
		-- init = function()
		--   -- vim.cmd([[cab cc CodeCompanion]])
		--   -- require("plugins.custom.spinner"):init()
		--   require("jg.custom.codecompanion_spinner"):init()
		-- end,
		dependencies = {
			"ravitemer/codecompanion-history.nvim",
			-- "j-hui/fidget.nvim", -- Display status
			-- { "bassamsdata/fs-monitor.nvim" },
			-- "ravitemer/mcphub.nvim",
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
				display = {
					chat = {
						icons = {
							chat_fold = " ",
						},
						fold_context = true,
						fold_reasoning = false,
						show_reasoning = true,
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
								relativenumber = true,
								signcolumn = "no",
								spell = false,
								wrap = true,
							},
						},
					},
				},
				-- mcp = {
				-- 	servers = {
				--         github = {
				--           cmd = {
				--             "npx", "-y", "mcp-remote",
				--             "https://api.githubcopilot.com/mcp/",
				--           },
				--           env = {
				--             -- GH_MCP_TOKEN = "GH_MCP_TOKEN",
				--             GITHUB_PERSONAL_ACCESS_TOKEN = "GH_MCP_TOKEN",
				--             -- GITHUB_PERSONAL_ACCESS_TOKEN = "cmd:gh auth token",
				--             -- or hardcode: GITHUB_PERSONAL_ACCESS_TOKEN = "ghp_xxx",
				--           },
				--           -- custom_instructions equivalent - passed as server_instructions
				--           server_instructions = "owner: mapfre-tech\nrepo: arch-mar2-mgmt",
				--         },
				--         ["chrome-devtools-mcp"] = {
				--           cmd = { "npx", "-y", "chrome-devtools-mcp@latest" },
				--           env = {
				--             npm_config_registry = "https://registry.npmjs.org",
				--           },
				--         },
				-- 		["nx"] = {
				-- 			cmd = { "npx", "-y", "nx-mcp@latest" },
				-- 			env = {
				-- 				npm_config_registry = "https://registry.npmjs.org",
				-- 			},
				-- 		},
				-- 		["tavily-mcp"] = {
				-- 			cmd = { "npx", "-y", "tavily-mcp@latest" },
				-- 			env = {
				-- 				TAVILY_API_KEY = "TAVILY_API_KEY",
				-- 			},
				-- 		},
				-- 	},
				-- 	opts = {
				-- 		default_servers = { "tavily-mcp", "nx", "github" },
				-- 	},
				-- },

				-- prompt_library = {
				--   markdown = {
				--     dirs = {
				--       "~/dotfiles/nvim/.config/nvim/lua/prompts"
				--     },
				--   },
				-- },
				prompt_library = {
					["Commit Message"] = {
						interaction = "inline",
						description = "Generate a commit message",
						opts = {
							alias = "commit_custom",
							ignore_system_prompt = true,
							is_slash_cmd = true,
							stop_context_insertion = true,
							auto_submit = true,
							placement = "new",
						},
						prompts = {
							{
								role = "user",
								content = function()
									return string.format(
										[[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:

```diff
%s
```

When unsure about the module names to use in the commit message, you can refer to the last 20 commit messages in this repository:

```
%s
```

Output only the commit message without any explanations and follow-up suggestions.
]],
										vim.fn.system("git diff --no-ext-diff --staged"),
										vim.fn.system('git log --pretty=format:"%s" -n 20')
									)
								end,
								opts = {
									contains_code = true,
								},
							},
						},
					},
				},
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
						copilot_cli_acp = function()
							return require("codecompanion.adapters").extend("opencode", {
								formatted_name = "copilot_cli_acp",
								name = "copilot_cli_acp",
								commands = {
									-- The default uses the opencode/config.json value
									default = {
										"copilot",
										"--acp",
										"--allow-all",
									},
								},
							})
						end,
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
					-- mcphub = {
					-- 	callback = "mcphub.extensions.codecompanion",
					-- 	opts = {
					-- 		-- MCP Tools
					-- 		make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
					-- 		show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
					-- 		add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
					-- 		show_result_in_chat = true, -- Show tool results directly in chat buffer
					-- 		format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
					-- 		-- MCP Resources
					-- 		make_vars = true, -- Convert MCP resources to #variables for prompts
					-- 		-- MCP Prompts
					-- 		make_slash_commands = true, -- Add MCP prompts as /slash commands
					-- 	},
					-- },
					fs_monitor = {
						enabled = false,
						opts = {
							keymap = "gF", -- Will be changed to `gD` in future releases.
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
						-- adapter = "copilot_cli_acp",
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
							["read_file"] = {
								opts = {
									require_cmd_approval = false,
								},
							},
							groups = {
								["fagent"] = {
									description = "A custom agent combining tools",
									tools = {
										"agent",
										"memory",
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
										"agent",
										"get_changed_files",
										"grep_search",
										"insert_edit_into_file",
										"memory",
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
									"agent",
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
							options = {
								modes = { n = "g?" },
								callback = "keymaps.options",
								description = "Options",
								hide = true,
							},
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
			})
			-- require("jg.custom.codecompanion_spinner"):init()
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
			-- {
			-- 	mode = { "n", "v", "t" },
			-- 	"<leader>ci",
			-- 	function()
			-- 		require("codecompanion").prompt("commit")
			-- 	end,
			-- },
			-- {
			-- 	mode = { "n", "v", "t" },
			-- 	"<leader>ci",
			-- 	function()
			-- 		vim.cmd("CodeCompanion /commit_custom")
			-- 	end,
			-- },
			{
				mode = { "n", "v", "t" },
				"<C-.>",
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
