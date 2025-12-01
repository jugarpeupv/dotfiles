return {
	"olimorris/codecompanion.nvim",
	tag = "v17.33.0",
	enabled = function()
		local is_headless = #vim.api.nvim_list_uis() == 0
		if is_headless then
			return false
		end
		return true
	end,
	dependencies = {
		"ravitemer/codecompanion-history.nvim",
		"franco-ruggeri/codecompanion-spinner.nvim",
		{ "nvim-lua/plenary.nvim", branch = "master" },
		"folke/snacks.nvim",
		{ "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } }, -- Optional: For prettier markdown rendering
		-- { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
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
				spinner = {},
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

			strategies = {
				chat = {
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

							["agentic"] = {
								description = "A custom agent combining tools",
								tools = {
									"cmd_runner",
									"create_file",
									"delete_file",
									"fetch_webpage",
									"file_search",
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
								"memory",
								"web_search",
								"fetch_webpage",
								"full_stack_dev",
								"github",
								"tavily",
								"nx",
								"neovim",
							},
							-- default_tools = {
							--   "agentic"
							-- },
              auto_submit_errors = false, -- Send any errors to the LLM automatically?
              auto_submit_success = false, -- Send any successful output to the LLM automatically?
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
				diff = {
					enabled = true,
					-- provider = providers.diff, -- mini_diff|split|inline
					provider = "inline",
					provider_opts = {
						-- Options for inline diff provider
						inline = {
							layout = "buffer", -- float|buffer - Where to display the diff

							diff_signs = {
								signs = {
									text = "▌", -- Sign text for normal changes
									reject = "✗", -- Sign text for rejected changes in super_diff
									highlight_groups = {
										addition = "DiagnosticOk",
										deletion = "DiagnosticError",
										modification = "DiagnosticWarn",
									},
								},
								-- Super Diff options
								icons = {
									accepted = " ",
									rejected = " ",
								},
								colors = {
									accepted = "DiagnosticOk",
									rejected = "DiagnosticError",
								},
							},

							opts = {
								context_lines = 3, -- Number of context lines in hunks
								dim = 100, -- Background dim level for floating diff (0-100, [100 full transparent], only applies when layout = "float")
								full_width_removed = true, -- Make removed lines span full width
								show_keymap_hints = true, -- Show "gda: accept | gdr: reject" hints above diff
								show_removed = true, -- Show removed lines as virtual text
							},
						},

						-- Options for the split provider
						split = {
							close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
							layout = "vertical", -- vertical|horizontal split
							opts = {
								"internal",
								"filler",
								"closeoff",
								"algorithm:histogram", -- https://adamj.eu/tech/2024/01/18/git-improve-diff-histogram/
								"indent-heuristic", -- https://blog.k-nut.eu/better-git-diffs
								"followwrap",
								"linematch:120",
							},
						},
					},
				},
				chat = {
					-- icons = {
					-- 	chat_context = "📎️", -- You can also apply an icon to the fold
					-- 	chat_fold = " ",
					-- },
					fold_reasoning = false,
          show_reasoning = true,
					fold_context = false,
					auto_scroll = false,
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
				vim.cmd("CodeCompanionChat Toggle")
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
}
