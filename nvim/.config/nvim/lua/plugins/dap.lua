return {
	{
		"linux-cultist/venv-selector.nvim",
		branch = "regexp",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"mfussenegger/nvim-dap-python",
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>ve", "<cmd>VenvSelect<cr>" },
		},
		opts = {
			-- stay_on_this_version = true,
			dap_enabled = true,
			settings = {
				options = {
					notify_user_on_venv_activation = true,
				},
			},
		},
		cmd = { "VenvSelect" },
	},
	{
		"mfussenegger/nvim-dap-python",
		dependencies = "mfussenegger/nvim-dap",
		ft = "python",
		config = function()
			local home = os.getenv("HOME")
			local path = home .. "/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
			require("dap-python").setup(path)
		end,
	},
	{
		"Weissle/persistent-breakpoints.nvim",
		-- event = { "BufReadPost" },
		keys = {
			{ "<C-d>" },
			{ "<C-u>" },
			{
				mode = { "n" },
				"<leader>de",
				function()
					require("persistent-breakpoints.api").toggle_breakpoint()
				end,
			},
			{
				mode = { "n" },
				"<leader>da",
				function()
					require("persistent-breakpoints.api").clear_all_breakpoints()
				end,
			},
		},
		config = function()
			require("persistent-breakpoints").setup({
				save_dir = vim.fn.stdpath("data") .. "/nvim_checkpoints",
				load_breakpoints_event = { "BufReadPost" },
				perf_record = false,
			})
		end,
	},
	{
		"mfussenegger/nvim-dap",
		keys = {
			-- {
			-- 	"<leader>dO",
			-- 	function()
			-- 		require("debugmaster.state").sidepanel:open()
			-- 	end,
			-- },
			-- {
			-- 	"<esc>",
			-- 	function()
			-- 		local dm = require("debugmaster")
			-- 		if dmode_enabled then
			-- 			dm.mode.toggle()
			-- 		else
			-- 			-- vim.api.nvim_input("<esc>")
			--
			-- 			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
			-- 			-- return
			-- 		end
			-- 	end,
			-- },
			-- {
			-- 	"<leader>dd",
			-- 	function()
			-- 		local dm = require("debugmaster")
			-- 		dm.mode.toggle()
			-- 		-- require("dap").continue()
			-- 	end,
			-- },
			{
				"<leader>dO",
				function()
					require("dap-view").toggle()
					-- require("dap-view").jump_to_view("scopes")
				end,
			},
			{
				"<leader>dd",
				function()
					require("dap").continue()
				end,
			},
			{
				"<leader>du",
				"<cmd>lua require('dapui').toggle()<cr>",
				{ noremap = true, silent = true },
			},
			{
				"<Leader>dk",
				function()
					require("dap").step_out()
				end,
			},
			{
				"<Leader>dj",
				function()
					require("dap").step_into()
				end,
			},
			{
				"<Leader>do",
				function()
					require("dap").step_over()
				end,
			},
			{
				"<leader>dU",
				function()
					require("dap").run_to_cursor()
				end,
			},
			{
				"<leader>dh",
				':lua require"dap".up()<CR>zz',
			},
			{
				"<leader>dl",
				':lua require"dap".down()<CR>zz',
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
			},
			{
				"<leader>dw",
				function()
					require("dap.ui.widgets").hover()
				end,
			},
			{
				"<leader>dI",
				function()
					require("dapui").eval(nil, { enter = true })
				end,
			},
			{
				"<leader>dr",
				':lua require"dap".repl.toggle({}, "vsplit")<CR><C-w>l',
			},
			{
				"<leader>dV",
				function()
					local widgets = require("dap.ui.widgets")
					local my_sidebar = widgets.sidebar(widgets.scopes)
					my_sidebar.open()
				end,
				{ "n", "v" },
			},
			{
				"<Leader>dC",
				function()
					local widgets = require("dap.ui.widgets")
					widgets.centered_float(widgets.scopes)
				end,
				{ "n", "v" },
			},
			{
				"<Leader>dP",
				function()
					require("dap.ui.widgets").preview()
				end,
				{ "n", "v" },
			},
			{
				"<leader>dp",
				function()
					require("telescope").extensions.dap.list_breakpoints({})
				end,
			},
		},
		dependencies = {
			{
				"igorlfs/nvim-dap-view",
				enabled = false,
				---@module 'dap-view'
				---@type dapview.Config
				opts = {
					winbar = {
						show = true,
						-- You can add a "console" section to merge the terminal with the other views
						sections = {
							"console",
							"scopes",
							"watches",
							"exceptions",
							"breakpoints",
							"threads",
							"repl",
							"sessions",
						},
						-- Must be one of the sections declared above
						default_section = "scopes",
						-- headers = {
						-- 	breakpoints = "[B]",
						-- 	scopes = "[S]",
						-- 	exceptions = "[E]",
						-- 	watches = "[W]",
						-- 	threads = "[T]",
						-- 	repl = "[R]",
						-- 	console = "[C]",
						-- },
						controls = {
							enabled = false,
							position = "right",
							-- buttons = {
							-- 	"play",
							-- 	"step_into",
							-- 	"step_over",
							-- 	"step_out",
							-- 	"step_back",
							-- 	"run_last",
							-- 	"terminate",
							-- 	"disconnect",
							-- },
							-- icons = {
							-- 	pause = "",
							-- 	play = "",
							-- 	step_into = "",
							-- 	step_over = "",
							-- 	step_out = "",
							-- 	step_back = "",
							-- 	run_last = "",
							-- 	terminate = "",
							-- 	disconnect = "",
							-- },
							custom_buttons = {},
						},
					},
					windows = {
						height = 12,
						terminal = {
							-- 'left'|'right'|'above'|'below': Terminal position in layout
							position = "left",
							-- List of debug adapters for which the terminal should be ALWAYS hidden
							hide = { "go" },
							-- Hide the terminal when starting a new session
							start_hidden = false,
						},
					},
					-- Controls how to jump when selecting a breakpoint or navigating the stack
					switchbuf = "useopen,usetab",
				},
			},
			-- {
			-- 	"miroshQa/debugmaster.nvim",
			-- 	config = function()
			-- 		local dm = require("debugmaster")
			-- 		-- keymaps changing example
			-- 		-- dm.keys.get("x").key = "y" -- remap x key in debug mode to y
			--
			-- 		-- changing some plugin options (see 1. note)
			-- 		dm.plugins.cursor_hl.enabled = false
			-- 		vim.api.nvim_set_hl(0, "dCursor", { bg = "#89ddff" })
			-- 	end,
			-- },
			{
				"LiadOz/nvim-dap-repl-highlights",
				config = function()
					require("nvim-dap-repl-highlights").setup()
				end,
			},
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
				config = function()
					require("dapui").setup()
				end,
			},
			{
				"stevearc/overseer.nvim",
				opts = {},
				dependencies = { "mfussenegger/nvim-dap" },
				lazy = true,
				-- event = { "BufReadPre", "BufNewFile" },
				-- event = "VeryLazy",
				config = function()
					require("overseer").setup()
				end,
			},
			{
				"theHamsta/nvim-dap-virtual-text",
				enabled = false,
				config = function()
					require("nvim-dap-virtual-text").setup({
						display_callback = function(variable)
							if #variable > 15 then
								return ": " .. string.sub(variable.value, 1, 15) .. "... "
							end

							return ": " .. variable.value
						end,
					})
				end,
			},
			{
				"jbyuki/one-small-step-for-vimkind",
				keys = {
					{
						"<F5>",
						function()
							require("osv").launch({ port = 8086 })
						end,
						{ noremap = true },
						desc = "Launch lua adapter",
					},
				},
			},
		},
		config = function()
			local dap_status, dap = pcall(require, "dap")
			if not dap_status then
				return
			end

			-- Use overseer for running preLaunchTask and postDebugTask
			-- require("overseer").patch_dap(true)
			require("dap.ext.vscode").json_decode = require("overseer.json").decode
			-- require("dap.ext.vscode").json_decode = require("json5").parse

			-- require("dap").defaults.fallback.switchbuf = "useopen" -- See :h dap-defaults to learn more

			-- dap.defaults.fallback.external_terminal = {
			-- 	command = '/opt/homebrew/bin/kitty';
			-- 	args = {'-e'};
			-- }

			dap.defaults.fallback.terminal_win_cmd = "50split new"

			dap.defaults.fallback.focus_terminal = true

			if not dap.adapters["pwa-node"] then
				require("dap").adapters["pwa-node"] = {
					type = "server",
					host = "localhost",
					port = "${port}",
					executable = {
						command = "node",
						-- 💀 Make sure to update this path to point to your installation
						args = {
							os.getenv("HOME")
								.. "/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
							"${port}",
						},
					},
				}
			end
			if not dap.adapters["node"] then
				dap.adapters["node"] = function(cb, config)
					if config.type == "node" then
						config.type = "pwa-node"
					end
					local nativeAdapter = dap.adapters["pwa-node"]
					if type(nativeAdapter) == "function" then
						nativeAdapter(cb, config)
					else
						cb(nativeAdapter)
					end
				end
			end

			dap.adapters.chrome = {
				type = "executable",
				command = "node",
				args = {
					os.getenv("HOME")
						.. "/.local/share/nvim/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js",
				},
			}

			-- pwa-node
			-- dap.adapters["pwa-node"] = {
			-- 	type = "server",
			-- 	host = "localhost",
			-- 	port = "${port}",
			-- 	executable = {
			-- 		-- command = vim.fn.exepath("js-debug-adapter"),
			-- 		command = "node",
			-- 		args = {
			-- 			os.getenv("HOME")
			-- 				.. "/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
			-- 			"${port}",
			-- 		},
			-- 	},
			-- }
			--
			-- dap.adapters.node2 = {
			-- 	type = "executable",
			-- 	sourceMaps = true,
			-- 	command = "node",
			-- 	args = {
			-- 		os.getenv("HOME") .. "/.local/share/nvim/mason/packages/node-debug2-adapter/out/src/nodeDebug.js",
			-- 	},
			-- }
			--
			-- dap.adapters["node"] = {
			-- 	type = "server",
			-- 	host = "localhost",
			-- 	port = "${port}",
			-- 	executable = {
			-- 		command = "node",
			-- 		args = {
			-- 			os.getenv("HOME")
			-- 				.. "/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
			-- 			"${port}",
			-- 		},
			-- 	},
			-- }
			--
			dap.configurations.java = {
				{
					type = "java",
					request = "attach",
					name = "Attach to process",
					hostName = "localhost",
					processId = require("dap.utils").pick_process,
				},
			}

			for _, language in ipairs({ "typescript", "javascript" }) do
				dap.configurations[language] = {
					{
						name = "[node] Launch",
						type = "node",
						request = "launch",
						program = "${file}",
						cwd = vim.fn.getcwd(),
						-- sourceMaps = true,
						protocol = "inspector",
						console = "integratedTerminal",
					},
					{
						-- For this to work you need to make sure the node process is started with the `--inspect` flag.
						name = "[node] Attach to process",
						type = "node",
						request = "attach",
						processId = require("dap.utils").pick_process,
					},
					{
						type = "node",
						request = "launch",
						name = "[node] Debug Jest Tests",
						-- trace = true, -- include debugger info
						runtimeExecutable = "node",
						runtimeArgs = {
							"./node_modules/jest/bin/jest.js",
							"--runInBand",
						},
						rootPath = "${workspaceFolder}",
						cwd = "${workspaceFolder}",
						console = "integratedTerminal",
						-- internalConsoleOptions = "neverOpen",
					},
					{
						name = "tsx current file",
						type = "node",
						request = "launch",
						program = "${file}",
						runtimeExecutable = "tsx",
						cwd = "${workspaceFolder}",
						console = "integratedTerminal",
						internalConsoleOptions = "neverOpen",
						skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
					},
					-- Debug web applications (client side)
					{
						type = "chrome",
						request = "launch",
						name = "[chrome] Launch Chrome",
						url = function()
							local co = coroutine.running()
							return coroutine.create(function()
								vim.ui.input({
									prompt = "Enter URL: ",
									default = "http://localhost:9222",
								}, function(url)
									if url == nil or url == "" then
										return
									else
										coroutine.resume(co, url)
									end
								end)
							end)
						end,
						webRoot = vim.fn.getcwd(),
						protocol = "inspector",
						sourceMaps = true,
						userDataDir = false,
					},
					{
						type = "chrome",
						request = "attach",
						program = "${file}",
						name = "[chrome] Attach to Chrome",
						cwd = vim.fn.getcwd(),
						sourceMaps = true,
						protocol = "inspector",
						port = 9222,
						webRoot = "${workspaceFolder}",
					},
				}
			end

			dap.configurations.lua = {
				{
					type = "nlua",
					request = "attach",
					name = "Attach to running Neovim instance",
				},
			}

			dap.adapters.nlua = function(callback, config)
				callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
			end

			-- local dv = require("dap-view")
			-- dap.listeners.before.attach["dap-view-config"] = function()
			-- 	dv.open()
			-- end
			-- dap.listeners.before.launch["dap-view-config"] = function()
			-- 	dv.open()
			-- end
			-- dap.listeners.before.event_terminated["dap-view-config"] = function()
			-- 	dv.close()
			-- end
			-- dap.listeners.before.event_exited["dap-view-config"] = function()
			-- 	dv.close()
			-- end

			local dapui = require("dapui")

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end

			-- dap.listeners.before.attach["dapui_config"] = function()
			--   dapui.open()
			-- end
			--
			-- dap.listeners.before.launch["dapui_config"] = function()
			--   dapui.open()
			-- end
			--
			-- dap.listeners.before.event_exited["dapui_config"] = function()
			-- 	dapui.open()
			-- end

			-- dap.listeners.before.event_terminated["dapui_config"] = function()
			-- 	dapui.close()
			-- end
			-- dap.listeners.before.event_exited["dapui_config"] = function()
			-- 	dapui.close()
			-- end

			-- vim.api.nvim_set_hl(0, "DapBreakpoint2", { ctermbg = 0, fg = "#D20F39", bg = "none" })
			-- vim.api.nvim_set_hl(0, "DapBreakpoint2", { ctermbg = 0, fg = "#af0a27", bg = "none" })
			vim.api.nvim_set_hl(0, "DapBreakpoint2", { ctermbg = 0, fg = "#89ddff", bg = "none" })
			vim.api.nvim_set_hl(0, "DapStopped2", { ctermbg = 0, fg = "#8ee2cf", bg = "none" })
			vim.api.nvim_set_hl(0, "DapStopped3", { ctermbg = 0, fg = "none", bg = "#3f4104" })
			vim.api.nvim_set_hl(0, "DapStoppedText", { ctermbg = 0, fg = "#aa8430", bg = "none" })
			vim.api.nvim_set_hl(0, "DapRejected", { ctermbg = 0, fg = "#89ddff", bg = "none" })
			-- vim.api.nvim_set_hl(0, "DapDebug1", { ctermbg = 0, fg = "none", bg = "#664f1d" })

			vim.api.nvim_set_hl(0, "DapDebug1", { ctermbg = 0, fg = "none", bg = "#1a3754" })

			-- vim.fn.sign_define("DapBreakpointRejected", { text = "⊚", texthl = "", linehl = "", numhl = "" })
			-- vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint2", linehl = "", numhl = "" })

			vim.fn.sign_define(
				"DapStopped",
				{ text = "", texthl = "DapStoppedText", linehl = "DapDebug1", numhl = "" }
			)

			-- vim.fn.sign_define("DapStopped", { text = "⇒", texthl = "DapStopped2", linehl = "DiffAdd", numhl = "" })
			local signs = {
				DapBreakpointRejected = { text = "⊚", texthl = "DapRejected", linehl = "", numhl = "" },
				DapBreakpoint = { text = "", texthl = "DapBreakpoint2", linehl = "", numhl = "" },
				-- DapStopped = { text = "", texthl = "DapStopped2", linehl = "DiffAdd", numhl = "" },
			}

			for name, opts in pairs(signs) do
				vim.fn.sign_define(name, opts)
			end
		end,
	},
}
