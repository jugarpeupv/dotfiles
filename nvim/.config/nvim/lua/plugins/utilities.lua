return {
	{
		"https://tangled.org/cuducos.me/yaml.nvim",
		ft = { "yaml", "yml", "yaml.github" }, -- optional
		dependencies = {
			"folke/snacks.nvim", -- optional
		},
		config = function()
			require("yaml_nvim").setup({ ft = { "yaml", "yml", "yaml.github" } })
		end,
	},
	{
		"yuratomo/w3m.vim",
		lazy = true,
		cmd = { "W3m" },
		enabled = false,
	},
	{
		"Avi-D-coder/whisper.nvim",
		enabled = true,
		config = function()
			require("whisper").setup({
				model = "base.en",
				keybind = "<space><Enter>",
				manual_trigger_key = "<Enter>",
				modes = { "n" },
				-- Whisper parameters
				threads = 8, -- Number of CPU threads
				step_ms = 20000, -- Process audio every 20 seconds
				length_ms = 25000, -- 25 second audio buffer
				vad_thold = 0.60, -- Voice activity detection threshold (0.0-1.0)
				language = "en",

				-- Streaming parameters
				enable_streaming = false,
				poll_interval_ms = 20000, -- Auto-insert every 20 seconds
				filter_markers = true, -- Remove [BLANK_AUDIO], [MUSIC], etc.

				-- UI settings
				show_whisper_output = false,
				notifications = true,

				-- Debug settings
				debug = false,
				debug_file = "/tmp/whisper-debug.log",
			})
		end,
		keys = {
			{ "<space><enter>", mode = { "n" }, desc = "Toggle speech-to-text" },
		},
	},
	{
		"necrom4/calcium.nvim",
		cmd = { "Calcium" },
		enabled = false,
		opts = {},
	},
	{
		"chrisgrieser/nvim-early-retirement",
		enabled = false,
		event = "LspAttach",
		opts = {
			retirementAgeMins = 10,
			-- Filetypes to ignore.
			ignoredFiletypes = {},
			-- Ignore files matching this lua pattern; empty string disables this setting.
			ignoreFilenamePattern = "",
			-- Will not close the alternate file.
			ignoreAltFile = true,
			-- Minimum number of open buffers for auto-closing to become active. E.g.,
			-- by setting this to 4, no auto-closing will take place when you have 3
			-- or fewer open buffers. Note that this plugin never closes the currently
			-- active buffer, so a number < 2 will effectively disable this setting.
			minimumBufferNum = 3,
			-- Ignore buffers with unsaved changes. If false, the buffers will
			-- automatically be written and then closed.
			ignoreUnsavedChangesBufs = true,
			-- Ignore non-empty buftypes, for example terminal buffers
			ignoreSpecialBuftypes = true,
			-- Ignore visible buffers. Buffers that are open in a window or in a tab
			-- are considered visible by vim. ("a" in `:buffers`)
			ignoreVisibleBufs = true,
			-- ignore unloaded buffers. Session-management plugin often add buffers
			-- to the buffer list without loading them.
			ignoreUnloadedBufs = false,
			-- Show notification on closing. Works with plugins like nvim-notify.
			notificationOnAutoClose = false,
			-- When a file is deleted, for example via an external program, delete the
			-- associated buffer as well. Requires Neovim >= 0.10.
			-- (This feature is independent from the automatic closing)
			deleteBufferWhenFileDeleted = true,
		},
	},
	{
		"Wansmer/treesj",
		enabled = false,
		keys = {
			{
				"sj",
				function()
					require("treesj").toggle({ split = { recursive = true } })
				end,
			},
		},
		dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
		config = function()
			require("treesj").setup({ use_default_keymaps = false, max_join_length = 240 })
		end,
	},
	{
		"jugarpeupv/bufjump.nvim",
		enabled = true,
		keys = {
			{ "<M-i>" },
			{ "<M-o>" },
			{ "<D-i>" },
			{ "<D-o>" },
		},
		config = function()
			local function is_inside_tmux()
				return os.getenv("TMUX") ~= nil
			end

			local function get_mi_key()
				if is_inside_tmux() then
					return "<M-i>"
				else
					return "<D-i>"
				end
			end

			local function get_mo_key()
				if is_inside_tmux() then
					return "<M-o>"
				else
					return "<D-o>"
				end
			end

			require("bufjump").setup({
				forward_key = get_mi_key(),
				backward_key = get_mo_key(),
				-- on_success = nil
				on_success = function()
					vim.cmd([[execute "normal! g`\"zz"]])
				end,
			})
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		enabled = true,
		-- event = { "BufReadPost", "BufNewFile" },
		-- event = { "VeryLazy" },
		event = { "LspAttach" },
		opts = { enable = true, enable_autocmd = false, config = { http = "# %s" } },
	},
	{
		"uga-rosa/ccc.nvim",
		keys = { { "<leader>CC", "<cmd>CccHighlighterToggle<cr>" } },
		cmd = { "CccPick", "CccHighlighterToggle", "CccConvert", "CccHighlighterEnable", "CccHighlighterDisable" },
		config = function()
			local ccc = require("ccc")
			ccc.setup({
				highlighter = {
					excludes = { "lazy" },
					auto_enable = true,
					lsp = false,
				},
			})
		end,
	},
	{
		"AndrewRadev/bufferize.vim",
		cmd = { "Bufferize" },
		config = function()
			vim.g.bufferize_keep_buffers = 1
		end,
	},
	{
		"m00qek/baleia.nvim",
		lazy = true,
		tag = "v1.3.0",
		config = function()
			-- local baleia = require("baleia").setup({})
			vim.g.baleia = require("baleia").setup({})
			vim.api.nvim_create_autocmd({ "FileType" }, {
				pattern = "dap-repl",
				callback = function()
					vim.g.baleia.automatically(vim.api.nvim_get_current_buf())
				end,
			})

			vim.api.nvim_create_user_command("BaleiaColorize", function()
				vim.g.baleia.once(vim.api.nvim_get_current_buf())
			end, { bang = true })
		end,
	},
	{
		"mogelbrod/vim-jsonpath",
		ft = { "json", "jsonc" },
		config = function()
			vim.g.jsonpath_register = "*"

			vim.keymap.set("n", "<leader>cp", "<cmd>JsonPath<CR>", {})
		end,
	},
	-- { 'mistweaverco/snap.nvim', opts = {}, cmd = { "Snap" } },
	{
		"katonori/ps.vim",
		cmd = "PS",
		keys = {
			{ "<leader>ps", "<cmd>PS<cr>" },
			{ "<leader>pr", "<cmd>PsRefresh<cr>" },
		},
	},
	-- { "rhysd/clever-f.vim", event = { "InsertEnter" } },
	{ "junegunn/gv.vim", enabled = false, dependencies = { "tpope/vim-fugitive" }, cmd = { "GV" } },
	{
		"alex-popov-tech/store.nvim",
		-- dependencies = { "OXY2DEV/markview.nvim" },
		opts = {},
		enabled = false,
		cmd = "Store",
	},
	{ "rhysd/vim-syntax-codeowners", ft = { "codeowners" } },
	-- { "markonm/traces.vim", event = { "BufReadPost" } },
	{
		"luukvbaal/statuscol.nvim",
		enabled = true,
		-- event = { "BufReadPre", "BufNewFile" },
		-- event = "VeryLazy",
		event = { "LspAttach" },
		lazy = true,
		config = function()
			local builtin = require("statuscol.builtin")

			require("statuscol").setup({

				-- configuration goes here, for example:
				relculright = true,
				ft_ignore = { "NvimTree", "codecompanion" },
				segments = {
					{
						text = { builtin.foldfunc },
						condition = { builtin.not_empty },
						sign = { maxwidth = 1, colwidth = 1, auto = true, fillchar = "", wrap = true },
					},
					{
						text = { "%s" },
						-- condition = { line_possible_fold }, -- Only show if line is folded
						-- condition = { function(args) return not has_fold(args) end },
						condition = { builtin.not_empty },
						sign = { namespace = { "diagnostic" }, maxwidth = 1, colwidth = 1, auto = true, fillchar = "" },
					},
					{ text = { builtin.lnumfunc, " " }, sign = { maxwidth = 1, fillchar = "", colwidth = 2 } },
					-- {
					-- 	sign = { name = { ".*" }, maxwidth = 1, colwidth = 1, auto = true },
					-- },
				},

				-- segments = {
				-- 	{
				-- 		-- text = { builtin.foldfunc, " " },
				--         text = { builtin.foldfunc, " " },
				-- 		condition = { true, builtin.not_empty },
				-- 		sign = {
				-- 			maxwidth = 1,
				-- 			wrap = false,
				-- 			auto = true,
				-- 			colwidth = 1,
				-- 			-- foldclosed = true,
				-- 		},
				-- 	},
				-- 	-- {
				-- 	-- 	sign = { namespace = { "diagnostic/signs" }, maxwidth = 2, auto = true },
				-- 	-- },
				-- 	{
				--         text = { builtin.signfunc },
				-- 		sign = {
				-- 			namespace = { "diagnostic" },
				-- 			maxwidth = 1,
				-- 			auto = false,
				-- 			colwidth = 1,
				-- 			foldclosed = false,
				-- 		},
				-- 	},
				-- 	{
				-- 		text = { builtin.lnumfunc, " " },
				--         -- text = { builtin.lnumfunc },
				-- 		-- condition = { true, builtin.not_empty },
				-- 		sign = {
				-- 			maxwidth = 1,
				-- 			auto = false,
				-- 			colwidth = 1,
				-- 		},
				-- 	},
				-- },
				-- segments = {
				--   { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
				--   {
				--     sign = { namespace = { "diagnostic/signs" }, maxwidth = 2, auto = true },
				--     click = "v:lua.ScSa"
				--   },
				--   { text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
				--   {
				--     sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
				--     click = "v:lua.ScSa"
				--   },
				-- }
			})
		end,
	},
	{
		"tpope/vim-rsi",
		event = "CmdlineEnter",
		-- event = { "InsertEnter" },
		-- event = { "Lazy" },
		config = function()
			vim.api.nvim_del_keymap("i", "<C-X><C-A>")
			vim.api.nvim_del_keymap("c", "<C-f>")
			-- vim.api.nvim_del_keymap("i", "<C-f>")
			-- vim.api.nvim_del_keymap("i", "<C-b>")
			-- vim.api.nvim_set_keymap("i", "<C-f>", "<S-Right>", { noremap = true, silent = true })
			-- vim.api.nvim_set_keymap("i", "<C-b>", "<S-Left>", { noremap = true, silent = true })
			-- vim.api.nvim_set_keymap("c", "<C-f>", "<S-Right>", { noremap = true, silent = true })
			-- vim.api.nvim_set_keymap("c", "<C-b>", "<S-Left>", { noremap = true, silent = true })
		end,
	},
	{
		"typed-rocks/ts-worksheet-neovim",
		enabled = false,
		cmd = { "Tsw" },
		opts = {
			severity = vim.diagnostic.severity.WARN,
		},
		config = function(_, opts)
			require("tsw").setup(opts)
		end,
	},

	{
		"duqcyxwd/stringbreaker.nvim",
		enabled = false,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("string-breaker").setup()
		end,
	},
	{
		"yelog/i18n.nvim",
		enabled = false,
		dependencies = {
			"ibhagwan/fzf-lua",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("i18n").setup({
				-- Locales to parse; first is the default locale
				-- Use I18nNextLocale command to switch the default locale in real time
				locales = { "en", "es" },
				-- sources can be string or table { pattern = "...", prefix = "..." }
				sources = {
					-- "src/locales/{locales}.json",
					--      "src/assets/i18n/{locales}.json",
					{ pattern = "src/assets/i18n/additional-coverages/{locales}.json" },
					-- { pattern = "src/locales/lang/{locales}/{module}.ts",            prefix = "{module}." },
					-- { pattern = "src/views/{bu}/locales/lang/{locales}/{module}.ts", prefix = "{bu}.{module}." },
				},
			})
		end,
	},
	-- Lazy
	{
		"NMAC427/guess-indent.nvim",
		enabled = false,
		event = "BufReadPost",
		config = true,
	},
	-- {
	-- 	"Joakker/lua-json5",
	-- 	build = "./install.sh",
	-- },
	-- {
	-- 	"wojciech-kulik/xcodebuild.nvim",
	-- 	dependencies = {
	-- 		"nvim-telescope/telescope.nvim",
	-- 		"MunifTanjim/nui.nvim",
	-- 		"folke/snacks.nvim", -- (optional) to show previews
	-- 		"nvim-tree/nvim-tree.lua", -- (optional) to manage project files
	-- 		"stevearc/oil.nvim", -- (optional) to manage project files
	-- 		"nvim-treesitter/nvim-treesitter", -- (optional) for Quick tests support (required Swift parser)
	-- 	},
	-- 	config = function()
	-- 		require("xcodebuild").setup({
	-- 			-- put some options here or leave it empty to use default settings
	-- 		})
	-- 	end,
	-- },
	{
		"axkirillov/unified.nvim",
		enabled = false,
		cmd = { "Unified" },
		opts = {
			-- your configuration comes here
		},
	},
	{
		"almo7aya/openingh.nvim",
		keys = {
			{
				"<leader>oL",
				function()
					vim.cmd("OpenInGHFileLines")
				end,
				desc = "Open in GitHub with lines",
			},
		},
		cmd = { "OpenInGHRepo", "OpenInGHFile", "OpenInGHFileLines" },
	},
	{
		"uga-rosa/translate.nvim",
		enabled = false,
		cmd = { "Translate", "TranslateW" },
		config = function()
			require("translate").setup({

				default = {
					output = "register",
				},
				preset = {
					output = {
						split = {
							append = true,
						},
					},
				},
			})
		end,
	},
	-- {
	--   "echasnovski/mini.icons",
	--   opts = {},
	--   lazy = true,
	--   specs = {
	--     { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
	--   },
	--   init = function()
	--     package.preload["nvim-web-devicons"] = function()
	--       require("mini.icons").mock_nvim_web_devicons()
	--       return package.loaded["nvim-web-devicons"]
	--     end
	--   end,
	-- },
	{
		-- "skanehira/denops-docker.vim",
		"jugarpeupv/denops-docker.vim",
		enabled = false,
		dependencies = {
			{ "vim-denops/denops.vim" },
		},
		dir = "~/projects/denops-docker.vim/wt-feature-fixes",
		dev = true,
		-- cmd = { "Docker", "DockerContainers", "DockerImages" },
		-- event = { "BufReadPost", "BufNewFile" },
		event = { "CmdlineEnter" },
		lazy = true,
		-- config = function ()
		--   vim.keymap.set("n", "<leader>dt", "<cmd>DockerContainers<cr>", { desc = "Docker Containers" })
		-- end,
		keys = {
			{
				"<leader>di",
				function()
					-- vim.cmd(":e docker://images")
					-- vim.defer_fn(function()
					--   vim.cmd(":e")
					--   vim.g.docker_denops_loaded = true
					-- end, 500)

					vim.cmd(":e docker://images")

					-- vim.defer_fn(function()
					--    vim.cmd(":e docker://images")
					-- end, 200)

					-- if vim.g.docker_denops_loaded then
					-- 	vim.cmd(":e docker://images")
					-- 	return
					-- else
					-- 	vim.cmd(":e docker://images")
					-- 	vim.defer_fn(function()
					-- 		vim.cmd(":e")
					-- 		vim.g.docker_denops_loaded = true
					-- 	end, 500)
					-- end
				end,
				desc = "Docker Images",
			},
			{
				"<leader>dc",
				-- "<cmd>DockerContainers<cr>",
				function()
					vim.cmd(":e docker://containers")

					-- vim.defer_fn(function()
					--   vim.cmd(":e docker://containers")
					-- end, 200)
					-- vim.defer_fn(function()
					--   vim.cmd(":e")
					-- end, 500)

					-- if vim.g.docker_denops_loaded then
					-- 	vim.cmd(":e docker://containers")
					-- else
					-- 	vim.cmd(":e docker://containers")
					-- 	vim.defer_fn(function()
					-- 		vim.cmd(":e docker://containers")
					-- 	end, 500)
					-- end

					-- vim.schedule(function() vim.cmd(":e docker://containers") end)
					-- Execute the DockerContainers command
					-- vim.cmd("DockerContainers")
				end,
				desc = "Docker Containers",
			},
		},
	},
	{
		"kkvh/vim-docker-tools",
		cmd = { "DockerToolsToggle" },
		enabled = true,
		keys = {
			{
				"<leader>DT",
				"<cmd>DockerToolsToggle<cr>",
				desc = "Toggle Docker Tools",
			},
		},
	},
	{
		"jfryy/keytrail.nvim",
		ft = { "json", "jsonc", "yaml" },
		enabled = false,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("keytrail").setup({
				-- The delimiter to use between path segments
				delimiter = ".",
				-- The delay in milliseconds before showing the hover popup
				hover_delay = 100,
				-- The key mapping to use for jumping to a path
				key_mapping = "jq",
				-- The file types to enable KeyTrail for
				filetypes = {
					yaml = true,
					json = true,
					jsonc = true,
				},
			})
		end,
	},
	-- Lua
	-- { "HawkinsT/pathfinder.nvim" },
	{
		"rmagatti/auto-session",
		enabled = false,
		-- event = "BufReadPost",
		lazy = false,
		keys = {
			-- Will use Telescope if installed or a vim.ui.select picker otherwise
			{ "<leader>ws", "<cmd>AutoSession search<CR>", desc = "Session search" },
			{ "<leader>wa", "<cmd>AutoSession save<CR>", desc = "Save session" },
		},
		---enables autocomplete for opts
		---@module "auto-session"
		---@diagnostic disable-next-line: undefined-doc-name
		---@type AutoSession.Config
		opts = {
			auto_save_enabled = true,
			auto_restore_enabled = true,
			auto_session_use_git_branch = true,
			pre_save_cmds = {
				"NvimTreeClose",
			},
			cwd_change_handling = {
				post_cwd_changed_hook = function()
					require("lualine").refresh()
				end,
			},
		},
	},
	{
		"farmergreg/vim-lastplace",
		-- event = { "BufNewFile", "BufReadPost" },
		event = { "VeryLazy" },
	},
	-- {
	-- 	"vim-scripts/applescript.vim",
	-- 	ft = { "applescript" },
	-- },
	-- { "tpope/vim-bundler", ft = { "ruby", "rake", "gemfile", "gemfilelock" } },
	-- { "tpope/vim-rails", ft = { "ruby", "rake", "gemfile", "gemfilelock" } },
	{
		"maskudo/devdocs.nvim",
		enabled = true,
		lazy = true,
		dependencies = {
			"folke/snacks.nvim",
		},
		keys = {
			{
				"<leader>ho",
				mode = "n",
				"<cmd>DevDocs get<cr>",
				desc = "Get Devdocs",
			},
			{
				"<leader>hi",
				mode = "n",
				"<cmd>DevDocs install<cr>",
				desc = "Install Devdocs",
			},
			{
				"<leader>hv",
				mode = "n",
				function()
					local devdocs = require("devdocs")
					local installedDocs = devdocs.GetInstalledDocs()
					vim.ui.select(installedDocs, {}, function(selected)
						if not selected then
							return
						end
						local docDir = devdocs.GetDocDir(selected)
						-- prettify the filename as you wish
						---@diagnostic disable-next-line: undefined-global
						Snacks.picker.files({ cwd = docDir })
					end)
				end,
				desc = "View Devdocs",
			},
		},
		opts = {
			ensure_installed = {
				"go",
				"html",
				"angular",
				-- "dom",
				"http",
				-- "css",
				"javascript",
				-- "rust",
				-- some docs such as lua require version number along with the language name
				-- check `DevDocs install` to view the actual names of the docs
				"lua~5.1",
				-- "openjdk~21"
			},
		},
	},
	{
		"vzze/calculator.nvim",
		enabled = false,
		-- cmd = { "Calculate" },
		-- event = { "BufReadPost" },
		keys = {
			{
				"<leader>c=",
				function()
					require("calculator").calculate()
				end,
				desc = "Calculate",
			},
		},
	},
	{ "sam4llis/nvim-lua-gf", keys = { "gf" } },
	{ "wlemuel/vim-tldr", cmd = { "Tldr", "Telescope" } },
	{ "benelori/vim-rfc", cmd = { "RFC" } },
	{
		"troydm/zoomwintab.vim",
		keys = { { mode = { "n" }, "<c-w>m", "<cmd>ZoomWinTabToggle<CR>" } },
	},
	{ "heavenshell/vim-jsdoc", cmd = { "JsDoc" } },
	{
		"barrett-ruth/live-server.nvim",
		enabled = false,
		build = "pnpm add -g live-server",
		keys = { {
			"<leader>le",
			"<cmd>LiveServerToggle<CR>",
		} },
		cmd = { "LiveServerStart", "LiveServerStop", "LiveServerToggle" },
		config = true,
	},
	{
		"danymat/neogen",
		keys = {

			-- vim.keymap.set("n", "<leader>ns", vim.cmd.Neogen)
			{
				"<leader>nG",
				function()
					require("neogen").generate()
				end,
			},
		},
		config = function()
			require("neogen").setup({ enabled = true, snippet_engine = "luasnip" })
		end,
	},
	{
		"hedyhli/outline.nvim",
		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		keys = { -- Example mapping to toggle outline
			{ "<leader>ot", "<cmd>Outline<CR>", desc = "Toggle outline" },
		},
		opts = {
			outline_window = {
				position = "right",
				width = 25,
				relative_width = true,
				auto_close = false,
				-- Automatically scroll to the location in code when navigating outline window.
				auto_jump = false,
				jump_highlight_duration = 500,
				wrap = true,
			},

			outline_items = {
				show_symbol_details = true,
				show_symbol_lineno = false,
				highlight_hovered_item = true,
				-- Whether to automatically set cursor location in outline to match
				-- location in code when focus is in code. If disabled you can use
				-- `:OutlineFollow[!]` from any window or `<C-g>` from outline window to
				-- trigger this manually.
				auto_set_cursor = false,
			},

			-- Options for outline guides which help show tree hierarchy of symbols

			-- These keymaps can be a string or a table for multiple keys.
			-- Set to `{}` to disable. (Using 'nil' will fallback to default keys)
			keymaps = {
				show_help = "?",
				close = { "<Esc>", "q" },
				-- Jump to symbol under cursor.
				-- It can auto close the outline window when triggered, see
				-- 'auto_close' option above.
				goto_location = "<Cr>",
				-- Jump to symbol under cursor but keep focus on outline window.
				peek_location = "o",
				-- Visit location in code and close outline immediately
				goto_and_close = "<S-Cr>",
				-- Change cursor position of outline window to match current location in code.
				-- 'Opposite' of goto/peek_location.
				restore_location = "<C-g>",
				-- Open LSP/provider-dependent symbol hover information
				hover_symbol = "<C-space>",
				-- Preview location code of the symbol under cursor
				toggle_preview = "K",
				rename_symbol = "r",
				code_actions = "a",
				-- These fold actions are collapsing tree nodes, not code folding
				fold = "h",
				unfold = "l",
				fold_toggle = "<Tab>",
				-- Toggle folds for all nodes.
				-- If at least one node is folded, this action will fold all nodes.
				-- If all nodes are folded, this action will unfold all nodes.
				fold_toggle_all = "<S-Tab>",
				fold_all = "W",
				unfold_all = "E",
				fold_reset = "R",
				-- Move down/up by one line and peek_location immediately.
				-- You can also use outline_window.auto_jump=true to do this for any
				-- j/k/<down>/<up>.
				down_and_jump = "<C-j>",
				up_and_jump = "<C-k>",
			},
		},
	},
	{
		"sontungexpt/url-open",
		-- event = "VeryLazy",
		keys = { { "gx", "<esc>:URLOpenUnderCursor<cr>" } },
		cmd = "URLOpenUnderCursor",
		config = function()
			local status_ok, url_open = pcall(require, "url-open")
			if not status_ok then
				return
			end
			url_open.setup({
				highlight_url = {
					all_urls = {
						enabled = false,
						fg = "#21d5ff", -- "text" or "#rrggbb"
						-- fg = "text", -- text will set underline same color with text
						bg = nil, -- nil or "#rrggbb"
						underline = true,
					},
					cursor_move = {
						enabled = false,
						fg = "#199eff", -- "text" or "#rrggbb"
						-- fg = "text", -- text will set underline same color with text
						bg = nil, -- nil or "#rrggbb"
						underline = true,
					},
				},
			})
		end,
	},
	{ "taybart/b64.nvim", cmd = { "B64Encode", "B64Decode" } },
	{
		"lambdalisue/vim-suda",
		cmd = { "SudaWrite", "SudaRead" },
	},
	{
		"chrisgrieser/nvim-spider",
		keys = {
			{
				"w",
				"<cmd>lua require('spider').motion('w')<CR>",
				mode = { "n", "o", "x" },
			},

			{
				"b",
				"<cmd>lua require('spider').motion('b')<CR>",
				mode = { "n", "o", "x" },
			},

			{
				"e",
				"<cmd>lua require('spider').motion('e')<CR>",
				mode = { "n", "o", "x" },
			},
		},
		opts = {
			skipInsignificantPunctuation = true,
			consistentOperatorPending = true, -- see "Consistent Operator-pending Mode" in the README
			subwordMovement = true,
			customPatterns = {}, -- check "Custom Movement Patterns" in the README for details
		},
	},
	{ "dstein64/vim-startuptime", cmd = { "StartupTime" } },
	{
		"junegunn/fzf",
		dependencies = { "junegunn/fzf.vim" },
		build = "./install --all",
		-- event = { "BufReadPost" },
		-- cmd = { "Git" },
		keys = {
			{ "<leader>jL", "<cmd>Jumps<CR>" },
			{
				mode = { "n" },
				"<leader>ga",
				"<cmd>Git add .<cr>",
				{ silent = true, noremap = true },
			},
			{
				mode = { "n" },
				"<Leader>gS",
				"<cmd>Git stash<cr>",
				{ silent = true, noremap = true },
			},
			{
				mode = { "n" },
				"<Leader>gO",
				"<cmd>Git! stash pop<cr>",
				{ silent = true, noremap = true },
			},

			{
				mode = { "n" },
				"<Leader>gP",
				"<cmd>Git! push<cr>",
				{ silent = true, noremap = true },
			},
			{
				mode = { "n" },
				"<leader>gf",
				"<cmd>Git! fetch --all --tags -v<cr>",
				{ silent = true, noremap = true },
			},
			{
				mode = { "n" },
				"<leader>gF",
				"<cmd>Git! fetch --all --tags -v --force<cr>",
				{ silent = true, noremap = true },
			},
			{
				mode = { "n" },
				"<Leader>gp",
				"<cmd>Git! fetch --all | Git! pull<cr>",
				{ silent = true, noremap = true },
			},
			{
				mode = { "n" },
				"<Leader>gy",
				"<cmd>Git! tag -l --format '%(refname:short) --> %(objectname)'<cr>",
				{ silent = true, noremap = true },
			},
			{
				mode = { "n" },
				"<leader>gC",
				"<cmd>Git checkout . | Git clean -fd<cr>",
				{ silent = true, noremap = true },
			},
			{
				mode = { "n" },
				"<Leader>gl",
				"<cmd>Git log -20<cr>",
				{ silent = true, noremap = true },
			},
		},
	},
	{ "stsewd/fzf-checkout.vim", keys = { { "<leader>GT", "<cmd>GTags<CR>" } } },
	{ "tpope/vim-repeat", keys = { "." } },
	{ "nvim-lua/plenary.nvim", lazy = true },
	{ "tpope/vim-surround", event = { "LspAttach" } },
	{
		"windwp/nvim-ts-autotag",
		ft = { "html", "htmlangular" },
		config = function()
			require("nvim-ts-autotag").setup({
				aliases = {
					["html"] = "html",
					["htmlangular"] = "html",
				},
			})
		end,
	},
	{ "tpope/vim-dispatch", enabled = false },
	{ "kkharji/sqlite.lua", enabled = true },
	{
		"ckipp01/nvim-jenkinsfile-linter",
		enabled = false,
		keys = {
			{
				"<leader>va",
				function()
					require("jenkinsfile_linter").validate()
				end,
			},
		},
	},
}
