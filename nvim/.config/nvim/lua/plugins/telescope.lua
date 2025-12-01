-- return {}

-- return { "griwes/telescope.nvim", branch = "group-by" }
--
vim.g.nx_loaded = false

return {
	{
		"nvim-telescope/telescope.nvim",
		-- branch = "0.1.x",
		-- tag = "0.1.8",
		branch = "master",
		lazy = true,
		dependencies = {
			{
				"zigotica/telescope-docker-commands.nvim",
				dependencies = {
					"nvim-lua/plenary.nvim",
					"nvim-telescope/telescope.nvim",
				},
				keys = {
					{
						"<leader>dc",
						function()
							vim.cmd("Telescope docker_commands docker_containers")
						end,
						desc = "Docker Images",
					},
					{
						"<leader>di",
						function()
							vim.cmd("Telescope docker_commands docker_images")
						end,
						desc = "Docker Images",
					},
					{
						"<leader>DD",
						function()
							vim.cmd("Telescope docker_commands")
						end,
						desc = "Docker Images",
					},
				},
				config = function()
					require("docker_commands").setup({
						-- Overwrite/Extend actions for each picker
						-- Actions are defined as tables containing command details,
						-- not direct functions, allowing for easier customization.
						actions = {
							-- Actions are categorized by main pickers
							containers = {
								-- Each action is referenced by a "key" action name, so it is easier to remap.
								-- Example: Customize the 'logs' action
								logs = {
									key = "<C-l>", -- change from C-l to C-g
									command_args = { "logs", "-f" }, -- add the -f to follow logs in real time
									desc = "Container lo[G]s", -- this will be shown in telescope keymaps help
									-- You dont need to modify all table
								},
								-- You can also add new key actions
								kill = {
									key = "<C-x>",
									command_args = { "kill" },
									identifier_field = "ID",
									needs_confirmation = true,
									desc = "[K]ill Container",
								},
							},
						},
					})
				end,
			},
			{
				-- "osyo-manga/vim-over",
				"jugarpeupv/vim-over",
				dev = true,
				dir = "~/projects/vim-over/wt-master",
				cmd = { "OverCommandLine" },
			},
			{
				"prochri/telescope-all-recent.nvim",
				dependencies = {
					"nvim-telescope/telescope.nvim",
					"kkharji/sqlite.lua",
					-- -- optional, if using telescope for vim.ui.select
					-- "stevearc/dressing.nvim",
				},
				opts = {
					vim_ui_select = {
						kinds = {},
						prompts = {},
					},

					pickers = { -- allows you to overwrite the default settings for each picker
						["dap#configurations"] = { -- enable man_pages picker. Disable cwd and use frecency sorting.
							disable = false,
							use_cwd = true,
							sorting = "frecency",
						},
						["git_worktree#create_git_worktree"] = {
							disable = false,
							use_cwd = true,
							sorting = "frecency",
						},

						["git_worktree#git_worktree"] = {
							disable = false,
							use_cwd = true,
							sorting = "recent",
						},
						man_pages = { -- enable man_pages picker. Disable cwd and use frecency sorting.
							disable = false,
							use_cwd = false,
							sorting = "frecency",
						},
						builtin = {
							disable = false,
							use_cwd = true,
							sorting = "recent",
						},
						git_files = {
							disable = true,
							use_cwd = true,
							sorting = "frecency",
						},
						find_files = {
							disable = true,
							use_cwd = true,
							sorting = "frecency",
						},
					},
				},
			},
			{
				"nvim-telescope/telescope-frecency.nvim",
				-- install the latest stable version
				version = "*",
				enabled = false,
				keys = {
					{
						"<leader>fr",
						function()
							require("telescope").extensions.frecency.frecency({})
						end,
						desc = "Open frecency",
						mode = "n",
					},
				},
				-- config = function()
				-- 	require("telescope").load_extension("frecency")
				-- end,
			},
			{
				"Myzel394/jsonfly.nvim",
				enabled = false,
				keys = {
					{
						"<leader>jq",
						"<cmd>Telescope jsonfly<cr>",
						desc = "Open json(fly)",
						ft = { "json", "xml", "yaml", "jsonc" },
						mode = "n",
					},
				},
			},
			-- {
			--   "nvim-telescope/telescope-arecibo.nvim",
			--   rocks = { openssl = true, ["lua-http-parser"] = true },
			-- },
			{
				"smartpde/telescope-recent-files",
			},
			{
				"bloznelis/before.nvim",
				config = function()
					local before = require("before")
					before.setup()
					-- Look for previous edits in quickfix list
					vim.keymap.set("n", "<leader>oq", before.show_edits_in_quickfix, {})

					-- Look for previous edits in telescope (needs telescope, obviously)
					vim.keymap.set("n", "<leader>oe", before.show_edits_in_telescope, {})
				end,
			},
			{
				enabled = true,
				"jugarpeupv/recall.nvim",
				dependencies = { "nvim-telescope/telescope.nvim" },
				-- dir = "~/projects/recall.nvim",
				-- dev = true,
				version = "*",
				event = { "BufReadPre", "BufNewFile" },
				keys = {
					{
						mode = { "n" },
						-- "<leader>mm",
						"mm",
						"<cmd>lua require('recall').toggle()<CR>",
						{ noremap = true, silent = true },
					},
					{
						mode = { "n" },
						-- "<leader>mn",
						"mn",
						"<cmd>lua require('recall').goto_next()<CR>",
						{ noremap = true, silent = true },
					},
					{
						mode = { "n" },
						"<leader>mp",

						function()
							require("telescope.builtin").man_pages({
								-- man_cmd = { "sh", "-c", "apropos . | sort | uniq" },
								man_cmd = { "cat", os.getenv("HOME") .. "/.cache/telescope_man_list.txt" },
								-- man_cmd = { "sh", "-c", "find /usr/share/man/man* -type f | sort | uniq" },
								sections = { "ALL" },
							})

							-- require("telescope.builtin").man_pages({ section = "1" })
							-- Snacks.picker.man({ section = { "1" } })
							-- Snacks.picker.man()
						end,
						{ silent = true },
					},
					{
						mode = { "n" },
						-- "<leader>mp",
						"mp",
						"<cmd>lua require('recall').goto_prev()<CR>",
						{ noremap = true, silent = true },
					},
					{
						mode = { "n" },
						-- "<leader>mc",
						"<leader>mc",
						"<cmd>lua require('recall').clear()<CR>",
						{ noremap = true, silent = true },
					},
					{
						mode = { "n" },
						-- "<leader>ml",
						"<leader>ml",
						"<cmd>Telescope recall<CR>",
						{ noremap = true, silent = true },
					},
				},
				config = function()
					local recall = require("recall")
					recall.setup({
						sign = "",
						sign_highlight = "Function",

						telescope = {
							autoload = true,
							mappings = {
								unmark_selected_entry = {
									normal = "dd",
									-- insert = "<M-d>",
									insert = "<C-x>",
								},
							},
						},

						wshada = vim.fn.has("nvim-0.10") == 0,
					})
				end,
			},
			{
				"jugarpeupv/nx.nvim",
				enabled = true,
				dir = "~/projects/nx.nvim",
				dev = true,
				dependencies = {
					"nvim-telescope/telescope.nvim",
				},
				keys = {
					{
						"<leader>nx",
						function()
							if not vim.g.nx_loaded then
								vim.defer_fn(function()
									require("telescope").extensions.nx.actions()
									vim.g.nx_loaded = true
								end, 1000)
							else
								-- print('vim.g.nx_loaded is: ', vim.inspect(vim.g.nx_loaded))
								require("telescope").extensions.nx.actions()
							end
						end,
						desc = "nx actions",
					},
					{
						"<leader>nm",
						function()
							if not vim.g.nx_loaded then
								vim.defer_fn(function()
									require("telescope").extensions.nx.run_many()
								end, 1000)
								vim.g.nx_loaded = true
							else
								require("telescope").extensions.nx.run_many()
							end
						end,
						desc = "nx actions",
					},
				},

				-- keys = {
				--   { "<leader>nx", "<cmd>Telescope nx actions<CR>", desc = "nx actions" },
				-- },
				-- init = function()
				--   require("telescope").load_extension("nx")
				-- end,
				config = function()
					require("nx").setup({
						nx_cmd_root = "npx nx",
						command_runner = function(command)
							-- vim.cmd('terminal ' .. command)
							local myterm = require("terminal").terminal:new({
								layout = { open_cmd = "botright new" },
								-- cmd = { command },
								autoclose = false,
							})
							myterm:open()
							myterm:send(command)

							-- local terminals = require("jg.custom.worktree-utils").get_all_terminals()
							-- if terminals and next(terminals) ~= nil and #terminals > 0 then
							-- 	vim.fn.chansend(terminals[#terminals]["id"], command)
							-- else
							-- 	local myterm = require("terminal").terminal:new({
							-- 		layout = { open_cmd = "botright new" },
							-- 		-- cmd = { command },
							-- 		autoclose = false,
							-- 	})
							-- 	myterm:open()
							-- 	myterm:send(command)
							-- end
						end,
					})

					-- require("telescope").load_extension("nx")
				end,
			},
			-- {
			--   "nvim-telescope/telescope-frecency.nvim",
			--   -- install the latest stable version
			--   version = "*",
			-- },
			{
				"isak102/telescope-git-file-history.nvim",
				dependencies = {
					"nvim-lua/plenary.nvim",
					"tpope/vim-fugitive",
				},
			},
			{
				"axieax/urlview.nvim",
				cmd = { "UrlView" },
				dependencies = {
					"nvim-telescope/telescope.nvim",
					"folke/snacks.nvim",
				},
				keys = {
					{
						mode = { "i", "t", "n" },
						"<M-`>",
						-- "<M-i>",
						function()
							vim.cmd("UrlView")
						end,
						desc = "Open URLView",
					},
				},
				config = function()
					require("urlview").setup({
						default_picker = "native",
						default_action = "system",
					})
				end,
			},
			{
				"piersolenski/telescope-import.nvim",
				enabled = false,
				dependencies = "nvim-telescope/telescope.nvim",
				keys = {
					{
						mode = { "n" },
						"<leader>ti",
						function()
							require("telescope").extensions.import.import()
						end,
					},
				},
				config = function()
					require("telescope").load_extension("import")
				end,
			},
			{ "nvim-lualine/lualine.nvim" },
			{
				"nvim-telescope/telescope-file-browser.nvim",
				dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
			},
			-- { "nvim-telescope/telescope-dap.nvim" },
			-- { "tom-anders/telescope-vim-bookmarks.nvim" },
			{ "gbprod/yanky.nvim" },
			-- { "Myzel394/jsonfly.nvim" },
			{ "jugarpeupv/git-worktree.nvim" },
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				enabled = true,
				build = "make",
				-- build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
				cmd = { "Telescope" },
			},
			{ "natecraddock/telescope-zf-native.nvim", cmd = { "Telescope" } },
			{
				"mosheavni/yaml-companion.nvim",
				branch = "chore/remove-deprecated-apis",
				enabled = false,
				-- ft = { "yaml", "yml", "yaml.github" },
				config = function()
					local cfg = require("yaml-companion").setup({
						filetypes = { "yaml", "yml" },
						cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/yaml-language-server", "--stdio" },
						on_attach = require("jg.custom.lsp-utils").attach_lsp_config,
						capabilities = require("blink.cmp").get_lsp_capabilities(),
						-- detect k8s schemas based on file content
						builtin_matchers = {
							kubernetes = { enabled = true },
						},

						-- schemas available in Telescope picker
						schemas = {
							-- not loaded automatically, manually select with
							-- :Telescope yaml_schema
							{
								name = "Argo CD Application",
								uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
							},
							{
								name = "SealedSecret",
								uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/bitnami.com/sealedsecret_v1alpha1.json",
							},
							-- schemas below are automatically loaded, but added
							-- them here so that they show up in the statusline
							{
								name = "Kustomization",
								uri = "https://json.schemastore.org/kustomization.json",
							},
							{
								name = "GitHub Workflow",
								uri = "https://json.schemastore.org/github-workflow.json",
							},
						},

						lspconfig = {
							settings = {
								yaml = {
									validate = true,
									-- schemaStore = {
									-- 	enable = false,
									-- 	url = "",
									-- },

									-- schemas from store, matched by filename
									-- loaded automatically
									schemas = require("schemastore").yaml.schemas({
										-- select = {
										-- 	"kustomization.yaml",
										-- 	"GitHub Workflow",
										-- },
										extra = {
											url = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
											name = "Argo CD Application",
											fileMatch = "argocd-application.yaml",
										},
									}),
								},
							},
						},
					})

					require("lspconfig")["yamlls"].setup(cfg)

					-- require("telescope").load_extension("yaml_schema")
				end,
			},
			{ "crispgm/telescope-heading.nvim", enabled = false },
			{
				"nvim-treesitter/nvim-treesitter",
			},
			-- { "3rd/image.nvim" },
			{
				"dhruvmanila/browser-bookmarks.nvim",
				version = "*",
				cmd = { "Telescope" },
				-- event = "VeryLazy",
				-- dependencies = {
				--   "kkharji/sqlite.lua",
				--   "nvim-telescope/telescope.nvim",
				-- },
				config = function()
					---@diagnostic disable-next-line: param-type-not-match
					require("browser_bookmarks").setup({
						-- Available: 'brave', 'buku', 'chrome', 'chrome_beta', 'edge', 'safari', 'firefox', 'vivaldi'
						selected_browser = "brave",
						profile_name = "MAR",

						-- Either provide a shell command to open the URL
						url_open_command = "open",

						-- Or provide the plugin name which is already installed
						-- Available: 'vim_external', 'open_browser'
						url_open_plugin = nil,

						-- Show the full path to the bookmark instead of just the bookmark name
						full_path = true,

						-- Provide a custom profile name for Firefox
						firefox_profile_name = nil,
					})
				end,
			},
			{ "nvim-telescope/telescope-smart-history.nvim", cmd = { "Telescope" } },
			{ "nvim-telescope/telescope-live-grep-args.nvim", cmd = { "Telescope" } },
			{
				"nvim-telescope/telescope-ui-select.nvim",
				dependencies = { "prochri/telescope-all-recent.nvim" },
				cmd = { "Telescope" },
			},
		},
		cmd = { "Telescope" },
		-- event = { "BufReadPre", "BufNewFile" },
		-- keys = { "<M-.>" },
		-- event = "VeryLazy",
		config = function()
			local open_with_trouble = require("trouble.sources.telescope").open
			local fb_actions = require("telescope").extensions.file_browser.actions
			local status_ok, telescope = pcall(require, "telescope")
			if not status_ok then
				return
			end

			-- local telescope_image_preview = require("jg.custom.telescope").telescope_image_preview()

			local actions = require("telescope.actions")
			local actions_live_grep_args = require("telescope-live-grep-args.actions")

			telescope.setup({
				defaults = vim.tbl_extend(
					"force",
					require("telescope.themes").get_ivy(), -- or get_cursor, get_ivy
					{
						-- prompt_prefix = " ",
						prompt_prefix = "> ",
						history = {
							path = "~/.local/share/nvim/databases/telescope_history.sqlite3",
							limit = 50,
						},
						selection_caret = " ",
						initial_mode = "insert",
						cache_picker = { limit_entries = 100 },
						scroll_strategy = "limit",
						path_display = { truncate = 5 },
						wrap_results = false,
						vimgrep_arguments = {
							"rg",
							-- "--color=never",
							"--no-heading",
							"--with-filename",
							"--line-number",
							"--column",
							"--smart-case",
						},
						-- file_previewer = file_previewer,
						-- buffer_previewer_maker = M.buffer_previewer_maker,
						-- file_previewer = telescope_image_preview.file_previewer,
						-- buffer_previewer_maker = telescope_image_preview.buffer_previewer_maker,
						-- buffer_previewer_maker = image_preview,
						-- layout_strategy = 'bottom_pane',
						-- layout_config = {
						--   height = 0.53,
						-- },

						-- buffer_previewer_maker = telescope_image_preview.buffer_previewer_maker,

						-- layout_strategy = "horizontal",
						sorting_strategy = "ascending",
						layout_config = {
							horizontal = { width = 0.98, height = 0.53, preview_width = 0.53, prompt_position = "top" },
							vertical = { width = 0.90, height = 0.53, preview_height = 0.35 },
							center = { width = 0.99, height = 0.47 },
							bottom_pane = { width = 1, height = 0.47, preview_width = 0.40 },
							prompt_position = "top",
						},
						preview = {
							filesize_limit = 1, -- MB
							-- highlight_limit = 0.5, -- MB
							hide_on_startup = false,
							-- timeout = 100,
							-- treesitter = false,
							-- treesitter = {
							--   enable = false
							-- },
							-- 1) Do not show previewer for certain files
							-- mime_hook = function(filepath, bufnr, opts)
							--          print('hi')
							-- 	local is_image = function(mypath)
							-- 		local image_extensions = { "png", "jpg" } -- Supported image formats
							-- 		local split_path = vim.split(mypath:lower(), ".", { plain = true })
							-- 		local extension = split_path[#split_path]
							-- 		return vim.tbl_contains(image_extensions, extension)
							-- 	end
							-- 	if is_image(filepath) then
							--            print('ho')
							-- 		local term = vim.api.nvim_open_term(bufnr, {})
							-- 		local function send_output(_, data, _)
							-- 			for _, d in ipairs(data) do
							-- 				vim.api.nvim_chan_send(term, d .. "\r\n")
							-- 			end
							-- 		end
							-- 		vim.fn.jobstart({
							-- 			"catimg",
							-- 			filepath, -- Terminal image viewer command
							-- 		}, { on_stdout = send_output, stdout_buffered = true, pty = true })
							-- 	else
							-- 		require("telescope.previewers.utils").set_preview_message(
							-- 			bufnr,
							-- 			opts.winid,
							-- 			"Binary cannot be previewed"
							-- 		)
							-- 	end
							-- end,
							filetype_hook = function(filepath, bufnr, opts)
								-- you could analogously check opts.ft for filetypes
								local putils = require("telescope.previewers.utils")
								local excluded = vim.tbl_filter(function(ending)
									return filepath:match(ending)
								end, {
									".*%.pdf",
									".*%.docx",
									".*%.csv",
									".*%.toml",
								})
								if not vim.tbl_isempty(excluded) then
									putils.set_preview_message(
										bufnr,
										opts.winid,
										string.format("I don't like %s files!", excluded[1]:sub(5, -1))
									)
									return false
								end
								return true
							end,
							-- 2) Truncate lines to preview window for too large files
							filesize_hook = function(filepath, bufnr, opts)
								local path = require("plenary.path"):new(filepath)
								-- opts exposes winid
								local height = vim.api.nvim_win_get_height(opts.winid)
								local lines = vim.split(path:head(height), "[\r]?\n")
								vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
							end,
						},
						mappings = {
							i = {
								["<C-space>"] = actions.to_fuzzy_refine,
								["<C-n>"] = actions.cycle_history_next,
								["<C-p>"] = actions.cycle_history_prev,

								["<C-j>"] = actions.move_selection_next,
								["<C-k>"] = actions.move_selection_previous,

								["<C-c>"] = actions.close,

								["<Down>"] = actions.move_selection_next,
								["<Up>"] = actions.move_selection_previous,

								-- ["<CR>"] = actions.select_default,
								-- ["<CR>"] = open_after_tree,
								["<C-s>"] = actions.select_horizontal,
								["<C-v>"] = actions.select_vertical,
								-- ["<C-Enter>"] = actions.select_vertical,
								["<C-t>"] = actions.select_tab,
								-- ["<C-t>"] = trouble.open_with_trouble,
								["<C-e>"] = open_with_trouble,
								["<C-b>"] = require("telescope.actions.layout").toggle_preview,
								-- ["<C-t>"] = trouble.open_with_trouble,

								-- ["<C-u>"] = actions.preview_scrolling_up,
								-- ["<C-d>"] = actions.preview_scrolling_down,

								-- ["<C-u>"] = actions.results_scrolling_up,
								-- ["<C-d>"] = actions.results_scrolling_down,
								["<C-u>"] = function(prompt_bufnr)
									for _ = 1, 5 do
										actions.move_selection_previous(prompt_bufnr)
									end
								end,
								["<C-d>"] = function(prompt_bufnr)
									for _ = 1, 5 do
										actions.move_selection_next(prompt_bufnr)
									end
								end,

								["<PageUp>"] = actions.preview_scrolling_up,
								["<PageDown>"] = actions.preview_scrolling_down,

								["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
								["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,

								["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
								["<C-y>"] = actions.send_selected_to_qflist + actions.open_qflist,
								["<C-x>"] = "delete_buffer",
								-- ["<C-l>"] = actions.complete_tag,
								["<C-h>"] = actions.which_key, -- keys from pressing <C-/>
							},

							n = {
								["<esc>"] = actions.close,
								-- ["<CR>"] = actions.select_default,
								-- ["<CR>"] = open_after_tree,
								["<C-s>"] = actions.select_horizontal,
								["<C-v>"] = actions.select_vertical,
								-- ["<C-Enter>"] = actions.select_vertical,
								["<C-t>"] = actions.select_tab,
								-- ["<C-t>"] = trouble.open_with_trouble,
								["<C-e>"] = open_with_trouble,

								["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
								["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
								["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
								["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

								["j"] = actions.move_selection_next,
								["k"] = actions.move_selection_previous,
								["H"] = actions.move_to_top,
								["M"] = actions.move_to_middle,
								["L"] = actions.move_to_bottom,
								["<BS>"] = "delete_buffer",
								["<C-x>"] = "delete_buffer",

								["<C-j>"] = actions.move_selection_next,
								["<C-k>"] = actions.move_selection_previous,

								["<Down>"] = actions.move_selection_next,
								["<Up>"] = actions.move_selection_previous,
								["gg"] = actions.move_to_top,
								["G"] = actions.move_to_bottom,

								-- ["<C-u>"] = actions.preview_scrolling_up,
								-- ["<C-d>"] = actions.preview_scrolling_down,

								-- ["<PageUp>"] = actions.results_scrolling_up,
								-- ["<PageDown>"] = actions.results_scrolling_down,

								["<C-u>"] = actions.results_scrolling_up,
								["<C-d>"] = actions.results_scrolling_down,

								["<PageUp>"] = actions.preview_scrolling_up,
								["<PageDown>"] = actions.preview_scrolling_down,

								["?"] = actions.which_key,
							},
						},
					}
				),
				-- pickers = {
				--   live_grep = { theme = "ivy", layout_config = { height = 0.53 } },
				--   buffers = {
				--     theme = "ivy",
				--     layout_config = { height = 0.53 },
				--   },
				--   oldfiles = {
				--     theme = "ivy",
				--     layout_config = { height = 0.53 },
				--   },
				--   find_files = {
				--     theme = "ivy",
				--     layout_config = { height = 0.53 },
				--   },
				--   -- live_grep = {
				--   --   theme = "ivy"
				--   --   -- layout_strategy = "vertical",
				--   --   -- path_display = { 'hidden' }
				--   -- },
				--   -- git_worktree = { theme = "ivy" },
				--   -- create_git_worktree = { theme = "ivy" },
				--   git_branches = {
				--     theme = "ivy",
				--     layout_config = { height = 0.53 },
				--     -- layout_strategy = "vertical",
				--     mappings = {
				--       i = { ["<C-b>"] = require("jg.custom.telescope").set_upstream },
				--     },
				--   },
				-- },
				extensions = {
					-- frecency = {
					-- 	db_safe_mode = false,
					-- 	auto_validate = true,
					-- 	initial_mode = "insert",
					-- 	disable_devicons = false,
					-- 	show_filter_column = false,
					-- 	enable_prompt_mappings = true,
					-- 	hide_current_buffer = true,
					-- 	ignore_patterns = {
					-- 		"*/.git",
					-- 		"*/.git/*",
					-- 		"*/.DS_Store",
					-- 		"*.git/*",
					-- 		"*/tmp/*",
					-- 		"term*",
					-- 		"term://*",
					-- 		"*private*",
					-- 		"*node_modules*",
					-- 		"*/node_modules/*",
					-- 	},
					-- 	-- matcher = "fuzzy",
					-- 	show_scores = true,
					-- 	-- path_display = { "filename_first" },
					-- },
					-- jsonfly = {
					--   subkeys_display = "waterfall"
					-- },
					file_browser = {
						theme = "ivy",
						hidden = true,
						-- initial_mode = "normal",
						hijack_netrw = false,
						mappings = {
							["i"] = {
								-- C-f toggle browser
								["<C-t>"] = fb_actions.change_cwd,
								["<C-y>"] = fb_actions.copy,
								["<C-x>"] = fb_actions.remove,
								["<C-v>"] = fb_actions.move,
								["<C-r>"] = fb_actions.goto_cwd,
								["<C-e>"] = fb_actions.goto_home_dir,
								["<C-c>"] = fb_actions.create,
								["<C-q>"] = fb_actions.sort_by_date,
								["<C-b>"] = fb_actions.open,
								["<C-o>"] = function(prompt_bufnr)
									actions.close(prompt_bufnr)
									local action_state = require("telescope.actions.state")
									local selection = action_state.get_selected_entry()
									if vim.fn.isdirectory(selection.value) == 1 then
										require("oil").open(selection.value)
									else
										-- remove the last part of the path from selection.value
										local dir_path = selection.value:match("(.*/)")
										require("oil").open(dir_path)
									end
									return true
								end,
								["<C-u>"] = function(prompt_bufnr)
									for _ = 1, 5 do
										actions.move_selection_previous(prompt_bufnr)
									end
								end,
								["<C-d>"] = function(prompt_bufnr)
									for _ = 1, 5 do
										actions.move_selection_next(prompt_bufnr)
									end
								end,
							},
							["n"] = {
								-- your custom normal mode mappings
								["<BS>"] = fb_actions.change_cwd,
								["gx"] = fb_actions.open,
								["o"] = false,
								["/"] = function()
									vim.cmd("startinsert")
								end,
								["l"] = actions.select_default,
								["h"] = fb_actions.goto_parent_dir,
								["N"] = fb_actions.create,
								["<C-u>"] = function(prompt_bufnr)
									for _ = 1, 5 do
										actions.move_selection_previous(prompt_bufnr)
									end
								end,
								["<C-d>"] = function(prompt_bufnr)
									for _ = 1, 5 do
										actions.move_selection_next(prompt_bufnr)
									end
								end,
							},
						},
					},
					-- heading = {
					-- 	treesitter = true,
					-- },
					["zf-native"] = {
						file = {
							enable = true,
							highlight_results = true,
							match_filename = true,
						},
						generic = {
							enable = true,
							highlight_results = true,
							match_filename = true,
						},
					},
					egrepify = {
						AND = true, -- default
						permutations = false, -- opt-in to imply AND & match all permutations of prompt tokens
						lnum = true, -- default, not required
						lnum_hl = "EgrepifyLnum", -- default, not required, links to `Constant`
						col = false, -- default, not required
						col_hl = "EgrepifyCol", -- default, not required, links to `Constant`
						title = true, -- default, not required, show filename as title rather than inline
						filename_hl = "EgrepifyFile", -- default, not required, links to `Title`
						prefixes = {
							-- ADDED ! to invert matches
							-- example prompt: ! sorter
							-- matches all lines that do not comprise sorter
							-- rg --invert-match -- sorter
							-- DEFAULTS
							-- filter for file suffixes
							-- example prompt: #lua,md $MY_PROMPT
							-- searches with ripgrep prompt $MY_PROMPT in files with extensions lua and md
							-- i.e. rg --glob="*.{lua,md}" -- $MY_PROMPT
							["#"] = {
								-- #$REMAINDER
								-- # is caught prefix
								-- `input` becomes $REMAINDER
								-- in the above example #lua,md -> input: lua,md
								flag = "glob",
								cb = function(input)
									return string.format([[*.{%s}]], input)
								end,
							},
							-- filter for (partial) folder names
							-- example prompt: >conf $MY_PROMPT
							-- searches with ripgrep prompt $MY_PROMPT in paths that have "conf" in folder
							-- i.e. rg --glob="**/conf*/**" -- $MY_PROMPT
							[">"] = {
								flag = "glob",
								cb = function(input)
									return string.format([[**/**{%s}**/**]], input)
								end,
							},
							-- filter for (partial) file names
							-- example prompt: &egrep $MY_PROMPT
							-- searches with ripgrep prompt $MY_PROMPT in paths that have "egrep" in file name
							-- i.e. rg --glob="*egrep*" -- $MY_PROMPT
							["&"] = {
								flag = "glob",
								cb = function(input)
									return string.format([[*{%s}*]], input)
								end,
							},
							["?"] = {
								flag = "no-ignore",
							},
							["%"] = {
								flag = "word-regexp",
							},
							["!"] = {
								flag = "invert-match",
							},
							-- HOW TO OPT OUT OF PREFIX
							-- ^ is not a default prefix and safe example
							["^"] = false,
						},
						-- default mappings
						mappings = {
							i = {
								-- toggle prefixes, prefixes is default
								-- ["<C-z>"] = egrep_actions.toggle_prefixes,
								-- -- toggle AND, AND is default, AND matches tokens and any chars in between
								-- ["<C-a>"] = egrep_actions.toggle_and,
								-- -- toggle permutations, permutations of tokens is opt-in
								-- ["<C-r>"] = egrep_actions.toggle_permutations,
							},
						},
					},
					-- ["ui-select"] = {
					-- 	require("telescope.themes").get_dropdown({
					-- 		layout_config = { width = 0.70 },
					-- 		prompt_prefix = "> ",
					-- 		initial_mode = "normal",
					-- 	}),
					-- },
					ecolog = {
						shelter = {
							-- Whether to show masked values when copying to clipboard
							mask_on_copy = false,
						},
						-- Default keybindings
						mappings = {
							-- Key to copy value to clipboard
							copy_value = "<C-y>",
							-- Key to copy name to clipboard
							copy_name = "<C-n>",
							-- Key to append value to buffer
							append_value = "<C-a>",
							-- Key to append name to buffer (defaults to <CR>)
							append_name = "<CR>",
						},
					},
					live_grep_args = {
						path_display = { "smart" },
						-- layout_strategy = "vertical",
						-- theme = "dropdown",
						-- prompt_position = "bottom",
						-- layout_config = { horizontal = { width = 0.97, height = 0.9, preview_width = 0.40 } },

						-- theme = require("telescope.themes").get_dropdown({
						--   layout_config = { width = 0.90, height = 0.40 },
						--   prompt_prefix = "> ",
						--   prompt_position = "bottom",
						--   -- results_height = 40,
						-- }),
						theme = require("telescope.themes").get_ivy({
							layout_config = { height = 0.45 },
							prompt_prefix = "> ",
							-- prompt_position = "bottom"
						}),
						-- theme = "ivy",
						auto_quoting = false,
						mappings = {
							i = {
								["<C-space>"] = actions.to_fuzzy_refine,
								["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
								["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
								["<C-l>"] = actions_live_grep_args.quote_prompt(),
								["<C-k>"] = actions.move_selection_previous,
								["<C-b>"] = actions_live_grep_args.quote_prompt({ postfix = " --iglob " }),
								["<C-f>"] = actions_live_grep_args.quote_prompt({ postfix = " -t" }),
							},
						},
					},
					arecibo = {
						["selected_engine"] = "google",
						["url_open_command"] = "xdg-open",
						["show_http_headers"] = false,
						["show_domain_icons"] = false,
					},
					media_files = {
						-- filetypes whitelist
						-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
						filetypes = { "png", "webp", "jpg", "jpeg", "pdf", "svg" },
						-- find command (defaults to `fd`)
						-- find_cmd = "rg"
					},
					-- fzy_native = {
					--   override_generic_sorter = true,
					--   override_file_sorter = true,
					-- },
				},
			})

			-- To get fzf loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			-- telescope.load_extension("fzf")
			-- telescope.load_extension("harpoon")

			-- TODO: Check if yank_history plugin is installed

			local yanky_status = pcall(require, "yanky")
			if yanky_status then
				telescope.load_extension("yank_history")
			end

			local markit_status = pcall(require, "markit")
			if markit_status then
				telescope.load_extension("markit")
			end

			local bookmark_status = pcall(require, "bookmarks")
			if bookmark_status then
				telescope.load_extension("bookmarks")
			end

			local ecolog_status = pcall(require, "ecolog")
			if ecolog_status then
				telescope.load_extension("ecolog")
			end

			local yaml_schema = pcall(require, "yaml_schema")
			if yaml_schema then
				telescope.load_extension("yaml_schema")
			end

			local heading = pcall(require, "heading")
			if heading then
				telescope.load_extension("heading")
			end

			-- local jsonfly = pcall(require, "jsonfly")
			-- if jsonfly then
			--   telescope.load_extension("jsonfly")
			-- end

			-- telescope.load_extension("dap")
			telescope.load_extension("zf-native")
			-- telescope.load_extension("ui-select")
			telescope.load_extension("bookmarks")
			telescope.load_extension("git_worktree")
			telescope.load_extension("file_browser")
			telescope.load_extension("git_file_history")
			-- telescope.load_extension("frecency")
			telescope.load_extension("fzf")
			telescope.load_extension("before")
			telescope.load_extension("recent_files")
			telescope.load_extension("nx")
			telescope.load_extension("docker_commands")
			telescope.load_extension("git_file_history")
			-- require("telescope").load_extension("persisted")
			-- telescope.load_extension("jsonfly")
			-- telescope.load_extension("media_files")
			-- telescope.load_extension("egrepify")
			-- telescope.load_extension('node_modules')
			-- telescope.load_extension('projects')
			-- telescope.load_extension('node_modules')
			-- telescope.load_extension("arecibo")
			-- require('telescope').load_extension('vim_bookmarks')
			-- require('telescope').load_extension('fzy_native')
			-- require('telescope').load_extension('gh')
			-- require("telescope").load_extension("media_files")
		end,
	},
}
