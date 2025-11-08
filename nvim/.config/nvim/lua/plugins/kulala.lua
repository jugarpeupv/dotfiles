return {
	{
		"mistweaverco/kulala.nvim",
		enabled = true,
		ft = { "http", "rest" },
		opts = {
      lsp = {
        enable = true,
        filetypes = { "http", "rest", "json", "yaml", "bruno" },
        keymaps = false, -- disabled by default, as Kulala relies on default Neovim LSP keymaps
        formatter = {
          sort = { -- enable/disable alphabetical sorting
            metadata = true,
            variables = true,
            commands = false,
            json = true,
          },
          quote_json_variables = true, -- add quotes around {{variable}} in JSON bodies
          indent = 2, -- base indentation for scripts
        },
        -- on_attach = function(client, bufnr)
        --   -- custom on_attach function
        -- end,
      },
			debug = true,
			vscode_rest_client_environmentvars = true,
			winbar = true,
			ui = {
				default_winbar_panes = { "body", "headers", "verbose", "script_output", "report" },
				pickers = {
					snacks = {
						layout = {

							layout = {
								box = "vertical",
								backdrop = false,
								row = -1,
								width = 0,
								height = 0.4,
								border = "top",
								title = " {title} {live} {flags}",
								title_pos = "center",
								{ win = "input", height = 1, border = "none" },
								{
									box = "horizontal",
									{ win = "list", border = "none" },
									{ win = "preview", title = "{preview}", width = 0.35, border = "left" },
								},
							},
						},
					},
				},
			},
			kulala_keymaps = {
				["Show headers"] = {
					"H",
					function()
						require("kulala.ui").show_headers()
					end,
				},
				["Show body"] = {
					"B",
					function()
						require("kulala.ui").show_body()
					end,
				},
				-- ["Show headers and body"] = {
				-- 	"A",
				-- 	function()
				-- 		require("kulala.ui").show_headers_body()
				-- 	end,
				-- },

				["Show headers and body"] = false,
				["Show verbose"] = {
					"A",
					function()
						require("kulala.ui").show_verbose()
					end,
				},

				["Show script output"] = {
					"O",
					function()
						require("kulala.ui").show_script_output()
					end,
				},
				["Show stats"] = {
					"S",
					function()
						require("kulala.ui").show_stats()
					end,
				},
				["Show report"] = {
					"R",
					function()
						require("kulala.ui").show_report()
					end,
				},
				["Show filter"] = {
					"F",
					function()
						require("kulala.ui").toggle_filter()
					end,
				},

				-- ["Send WS message"] = {
				-- 	"<S-CR>",
				-- 	function()
				-- 		require("kulala.cmd.websocket").send()
				-- 	end,
				-- 	mode = { "n", "v" },
				-- },
				["Interrupt requests"] = {
					"<C-c>",
					function()
						require("kulala.cmd.websocket").close()
					end,
					desc = "also: CLose WS connection",
				},

				["Next response"] = {
					")",
					function()
						require("kulala.ui").show_next()
					end,
				},
				["Previous response"] = {
					"(",
					function()
						require("kulala.ui").show_previous()
					end,
				},
				-- ["Jump to response"] = {
				-- 	"<CR>",
				-- 	function()
				-- 		require("kulala.ui").jump_to_response()
				-- 	end,
				-- 	desc = "also: Send WS message for WS connections",
				-- },

				["Clear responses history"] = {
					"X",
					function()
						require("kulala.ui").clear_responses_history()
					end,
				},

				["Show help"] = {
					"?",
					function()
						require("kulala.ui").show_help()
					end,
				},
				["Show news"] = false,
				["Toggle split/float"] = {
					"|",
					function()
						require("kulala.ui").toggle_display_mode()
					end,
					prefix = false,
				},
				["Close"] = {
					"q",
					function()
						require("kulala.ui").close_kulala_buffer()
					end,
				},
			},

			global_keymaps = {
				-- ["Open scratchpad"] = {
				-- 	"b",
				-- 	function()
				-- 		require("kulala").scratchpad()
				-- 	end,
				-- },
				["Open kulala"] = {
					"<leader>kt",
					function()
						require("kulala").open()
					end,
				},

				-- ["Toggle headers/body"] = {
				-- 	"<leader>kt",
				-- 	function()
				-- 		require("kulala").toggle_view()
				-- 	end,
				-- 	ft = { "http", "rest" },
				-- },
				["Show stats"] = {
					"<leader>kS",
					function()
						require("kulala").show_stats()
					end,
					ft = { "http", "rest" },
				},
				-- ["Close window"] = {
				-- 	"q",
				-- 	function()
				-- 		require("kulala").close()
				-- 	end,
				-- 	ft = { "http", "rest" },
				-- },

				["Copy as cURL"] = {
					"<leader>kc",
					function()
						require("kulala").copy()
					end,
					ft = { "http", "rest" },
				},
				["Paste from curl"] = {
					"<leader>kC",
					function()
						require("kulala").from_curl()
					end,
					ft = { "http", "rest" },
				},

				-- ["Send request"] = {
				-- 	"<leader>kr",
				-- 	function()
				-- 		require("kulala").run()
				-- 	end,
				-- 	mode = { "n", "v" },
				-- },
				["Send request <cr>"] = {
					"<CR>",
					function()
						require("kulala").run()
					end,
					mode = { "n", "v" },
					ft = { "http", "rest" },
				},
				-- ["Send all requests"] = {
				-- 	"a",
				-- 	function()
				-- 		require("kulala").run_all()
				-- 	end,
				-- 	mode = { "n", "v" },
				-- },

				["Inspect current request"] = {
					"<leader>ki",
					function()
						require("kulala").inspect()
					end,
					ft = { "http", "rest" },
				},
				["Open cookies jar"] = {
					"<leader>kj",
					function()
						require("kulala").open_cookies_jar()
					end,
					ft = { "http", "rest" },
				},
				["Replay the last request"] = {
					"<leader>kr",
					function()
						require("kulala").replay()
					end,
				},

				["Find request"] = {
					"<leader>ks",
					function()
						require("kulala").search()
					end,
					ft = { "http", "rest" },
				},
				["Jump to next request"] = {
					"<leader>kn",
					function()
						require("kulala").jump_next()
					end,
					ft = { "http", "rest" },
				},
				["Jump to previous request"] = {
					"<leader>kp",
					function()
						require("kulala").jump_prev()
					end,
					ft = { "http", "rest" },
				},

				["Select environment"] = {
					"<leader>ke",
					function()
						require("kulala").set_selected_env()
					end,
					ft = { "http", "rest" },
				},
				["Manage Auth Config"] = {
					"<leader>kA",
					function()
						require("lua.kulala.ui.auth_manager").open_auth_config()
					end,
					ft = { "http", "rest" },
				},
				-- ["Download GraphQL schema"] = {
				-- 	"g",
				-- 	function()
				-- 		require("kulala").download_graphql_schema()
				-- 	end,
				-- 	ft = { "http", "rest" },
				-- },
				--
				-- ["Clear globals"] = {
				-- 	"x",
				-- 	function()
				-- 		require("kulala").scripts_clear_global()
				-- 	end,
				-- 	ft = { "http", "rest" },
				-- 	["Clear cached files"] = {
				-- 		"X",
				-- 		function()
				-- 			require("kulala").clear_cached_files()
				-- 		end,
				-- 		ft = { "http", "rest" },
				-- 	},
				-- },
			},
			-- show_icons = "nil",
			-- winbar = false,
			-- disable_script_print_output = false,
			-- default_view = "headers_body",
		},
	},
	{
		"jellydn/hurl.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown" },
				},
				ft = { "markdown" },
			},
		},
		ft = "hurl",
		opts = {
			-- Show debugging info
			debug = false,
			-- Show notification on run
			show_notification = false,
			env_file = { ".env" },
			-- Show response in popup or split
			mode = "split",
			-- Default formatter
			formatters = {
				json = { "jq" }, -- Make sure you have install jq in your system, e.g: brew install jq
				html = {
					"prettier", -- Make sure you have install prettier in your system, e.g: npm install -g prettier
					"--parser",
					"html",
				},
				xml = {
					"tidy", -- Make sure you have installed tidy in your system, e.g: brew install tidy-html5
					"-xml",
					"-i",
					"-q",
				},
			},
			-- Default mappings for the response popup or split views
			mappings = {
				close = "q", -- Close the response popup or split view
				next_panel = "<C-n>", -- Move to the next response popup window
				prev_panel = "<C-p>", -- Move to the previous response popup window
			},
		},
		keys = {
			-- Run API request
			-- { "<leader>A",  "<cmd>HurlRunner<CR>",        desc = "Run All requests" },
			{ "<leader>um", "<cmd>HurlManageVariable<CR>", desc = "manage variables", mode = "n" },
			{ "<leader>ue", "<cmd>HurlShowLastResponse<CR>", desc = "Hurl show last response", mode = "n" },
			{ "<leader>ur", "<cmd>HurlRunnerAt<CR>", desc = "Run Api request", mode = "n" },
			-- { "<leader>te", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
			-- { "<leader>tE", "<cmd>HurlRunnerToEnd<CR>",   desc = "Run Api request from current entry to end" },
			-- { "<leader>tm", "<cmd>HurlToggleMode<CR>",    desc = "Hurl Toggle Mode" },
			-- { "<leader>uv", "<cmd>HurlVerbose<CR>",       desc = "Run Api in verbose mode" },
			-- { "<leader>uV", "<cmd>HurlVeryVerbose<CR>",   desc = "Run Api in very verbose mode" },
			-- Run Hurl request in visual mode
			{
				"<leader>Hr",
				":HurlRunner<CR>",
				desc = "Hurl Runner",
				mode = "v",
			},
		},
	},
}
