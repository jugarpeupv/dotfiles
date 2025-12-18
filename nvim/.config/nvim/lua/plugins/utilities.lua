-- return {}
return {

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
	{ "junegunn/gv.vim", dependencies = { "tpope/vim-fugitive" }, cmd = { "GV" } },
	{
		"alex-popov-tech/store.nvim",
		-- dependencies = { "OXY2DEV/markview.nvim" },
		opts = {},
		cmd = "Store",
	},
	{ "rhysd/vim-syntax-codeowners", ft = { "codeowners" } },
	-- { "markonm/traces.vim", event = { "BufReadPost" } },
	{
		"luukvbaal/statuscol.nvim",
		enabled = true,
		event = { "BufReadPre", "BufNewFile" },
		-- event = { "VeryLazy" },
		lazy = true,
		config = function()
			local builtin = require("statuscol.builtin")

			require("statuscol").setup({
				-- configuration goes here, for example:
				relculright = true,
				-- ft_ignore = { "copilot-chat" },
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
		enabled = true,
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
	-- {
	-- 	"eyalk11/speech-to-text.nvim",
	-- 	build = "pip install -r requirements.txt", -- Optional: Install Python dependencies
	--    config = function()
	--      -- Plugin-specific configuration
	--    end,
	-- },

	-- with lazy.nvim
	-- {
	-- 	"cd-4/git-needy.nvim",
	-- 	keys = {
	-- 		{ "<leader>wf", "<cmd>GitNeedyOpen<cr>", desc = "Git needy" },
	-- 	},
	-- 	config = function()
	-- 		require("git-needy").setup({
	-- 			repos = { "my-user-or-org/my-repo-i-watch", "my-user/another-repo" },
	-- 		})
	-- 	end,
	-- 	dependencies = { "nvim-lua/plenary.nvim" },
	-- },
	{
		"johnseth97/gh-dash.nvim",
		lazy = true,
		enabled = false,
		keys = {
			{
				"<leader>cc",
				function()
					require("gh_dash").toggle()
				end,
				desc = "Toggle gh-dash popup",
			},
		},
		opts = {
			keymaps = {}, -- disable internal mapping
			border = "rounded", -- or 'double'
			width = 0.8,
			height = 0.8,
			autoinstall = true,
		},
	},
	{
		"mecattaf/murmur.nvim",
		enabled = false,
		event = "VeryLazy",
		opts = {
			-- Optional: Override default configuration
			server = {
				host = "127.0.0.1", -- whisper.cpp server host
				port = 8009, -- whisper.cpp server port
				model = "whisper-small", -- Model to use
				timeout = 30,
			},
			recording = {
				command = nil, -- Auto-detect (sox, arecord, or ffmpeg)
			},
			ui = {
				border = "single", -- Popup border style
				spinner = true, -- Show processing spinner
			},
		},
	},
	{
		"kyza0d/vocal.nvim",
		enabled = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		cmd = { "Vocal" },
		opts = {
			-- API key (string, table with command, or nil to use OPENAI_API_KEY env var)
			api_key = nil,

			-- Directory to save recordings
			recording_dir = os.getenv("HOME") .. "/recordings",

			-- Delete recordings after transcription
			delete_recordings = true,

			-- Keybinding to trigger :Vocal (set to nil to disable)
			keymap = nil,

			-- Local model configuration (set this to use local model instead of API)
			local_model = nil,
			-- local_model = {
			-- 	model = "base", -- Model size: tiny, base, small, medium, large
			-- 	path = "~/whisper", -- Path to download and store models
			-- },

			-- API configuration (used only when local_model is not set)
			api = {
				model = "whisper-1",
				language = nil, -- Auto-detect language
				response_format = "json",
				temperature = 0,
				timeout = 60,
			},
		},
	},
	{
		"topaxi/pipeline.nvim",
		keys = {
			{ "<leader>cI", "<cmd>Pipeline toggle<cr>", desc = "Open pipeline.nvim" },
		},
		-- optional, you can also install and use `yq` instead.
		build = "make",
		---@module "pipeline"
		---@type pipeline.Config
		opts = {
			--- The browser executable path to open workflow runs/jobs in
			browser = nil,
			--- Interval to refresh in seconds
			refresh_interval = 10,
			--- How much workflow runs and jobs should be indented
			indent = 2,
			providers = {
				github = {
					default_host = "github.com",
					--- Mapping of names that should be renamed to resolvable hostnames
					--- names are something that you've used as a repository url,
					--- that can't be resolved by this plugin, like aliases from ssh config
					--- for example to resolve "gh" to "github.com"
					--- ```lua
					--- resolve_host = function(host)
					---   if host == "gh" then
					---     return "github.com"
					---   end
					--- end
					--- ```
					--- Return nil to fallback to the default_host
					---@param host string
					---@return string|nil
					resolve_host = function(host)
						if host == "gh" or host:match("^github%.com%-") then
							return "github.com"
						end
						return host
					end,
				},
			},
			--- Allowed hosts to fetch data from, github.com is always allowed
			allowed_hosts = {},
			icons = {
				workflow_dispatch = "⚡️",
				conclusion = {
					success = "✓",
					failure = "X",
					startup_failure = "X",
					cancelled = "⊘",
					skipped = "◌",
				},
				status = {
					unknown = "?",
					pending = "○",
					queued = "○",
					requested = "○",
					waiting = "○",
					in_progress = "●",
				},
			},
			split = {
				relative = "editor",
				position = "right",
				size = 60,
				buf_options = {
					filetype = "pipeline",
					buflisted = true,
				},
				win_options = {
					wrap = true,
					number = true,
					foldlevel = nil,
					foldcolumn = "0",
					cursorcolumn = false,
					signcolumn = "no",
				},
			},
		},
	},
	{
		"farmergreg/vim-lastplace",
		event = { "BufNewFile", "BufReadPost" },
		-- event = { "VeryLazy" }
	},
	{
		"vim-scripts/applescript.vim",
		ft = { "applescript" },
		-- event = { "BufNewFile", "BufReadPre" },
	},
	{ "tpope/vim-bundler", ft = { "ruby", "rake", "gemfile", "gemfilelock" } },
	{ "tpope/vim-rails", ft = { "ruby", "rake", "gemfile", "gemfilelock" } },
	-- {
	--   'vim-ruby/vim-ruby',
	--   event = { "BufNewFile", "BufReadPre" },
	-- },
	{
		"RRethy/vim-illuminate",
		enabled = false,
		event = { "BufNewFile", "BufReadPost" },
		opts = {
			-- providers: provider used to get references in the buffer, ordered by priority
			providers = {
				"lsp",
				"treesitter",
				-- "regex",
			},
			-- delay: delay in milliseconds
			delay = 300,
			-- filetype_overrides: filetype specific overrides.
			-- The keys are strings to represent the filetype while the values are tables that
			-- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
			-- filetype_overrides = {},
			-- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
			filetypes_denylist = {
				"grug-far",
				"oil",
				"dirvish",
				"fugitive",
				"alpha",
				"NvimTree",
				"lazy",
				"neogitstatus",
				"Trouble",
				"lir",
				"Outline",
				"spectre_panel",
				"toggleterm",
				"DressingSelect",
				"TelescopePrompt",
				"NvimTree",
			},
			-- filetypes_denylist = {
			--   "TelescopePrompt",
			--   "NvimTree",
			--   "dirbuf",
			--   "dirvish",
			--   "fugitive",
			-- },
			-- filetypes_allowlist: filetypes to illuminate, this is overridden by filetypes_denylist
			-- You must set filetypes_denylist = {} to override the defaults to allow filetypes_allowlist to take effect
			-- filetypes_allowlist = {},
			-- modes_denylist: modes to not illuminate, this overrides modes_allowlist
			-- See `:help mode()` for possible values
			-- modes_denylist = { "i" },
			-- modes_allowlist: modes to illuminate, this is overridden by modes_denylist
			-- See `:help mode()` for possible values
			-- modes_allowlist = {},
			-- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
			-- Only applies to the 'regex' provider
			-- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
			-- providers_regex_syntax_denylist = {},
			-- -- providers_regex_syntax_allowlist: syntax to illuminate, this is overridden by providers_regex_syntax_denylist
			-- -- Only applies to the 'regex' provider
			-- -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
			-- providers_regex_syntax_allowlist = {},
			-- under_cursor: whether or not to illuminate under the cursor
			under_cursor = true,
			-- large_file_cutoff: number of lines at which to use large_file_config
			-- The `under_cursor` option is disabled when this cutoff is hit
			large_file_cutoff = 10000,
			-- large_file_config: config to use for large files (based on large_file_cutoff).
			-- Supports the same keys passed to .configure
			-- If nil, vim-illuminate will be disabled for large files.
			-- large_file_overrides = nil,
			-- -- min_count_to_highlight: minimum number of matches required to perform highlighting
			-- min_count_to_highlight = 1,
			-- should_enable: a callback that overrides all other settings to
			-- enable/disable illumination. This will be called a lot so don't do
			-- anything expensive in it.
			-- should_enable = function(bufnr)
			--   return true
			-- end,
			-- case_insensitive_regex: sets regex case sensitivity
			case_insensitive_regex = false,
			-- disable_keymaps: disable default keymaps
			disable_keymaps = true,
		},
		config = function(_, opts)
			require("illuminate").configure(opts)
			vim.keymap.set({ "n" }, "<leader>ij", function()
				require("illuminate").goto_next_reference(true)
			end, { noremap = true, silent = true })

			vim.keymap.set({ "n" }, "<leader>ik", function()
				require("illuminate").goto_prev_reference(true)
			end, { noremap = true, silent = true })
		end,
	},
	-- { 'ii14/neorepl.nvim', cmd = { "Repl" }},
	{
		"Yilin-Yang/vim-markbar",
		event = { "BufReadPre", "BufNewFile" },
		enabled = false,
		config = function()
			vim.g.markbar_marks_to_display = "QPOMLKJIHGFEDCBA"
			vim.g.markbar_width = 50
			vim.g.markbar_context_indent_block = "  "
			vim.g.markbar_num_lines_context = 0
		end,
	},
	{
		"LintaoAmons/bookmarks.nvim",
		enabled = false,
		-- pin the plugin at specific version for stability
		-- backup your bookmark sqlite db when there are breaking changes
		-- tag = "v2.3.0",
		dependencies = {
			{ "kkharji/sqlite.lua" },
			{ "nvim-telescope/telescope.nvim" },
			-- { "stevearc/dressing.nvim" }, -- optional: better UI
		},
		config = function()
			local opts = {} -- go to the following link to see all the options in the deafult config file
			require("bookmarks").setup(opts) -- you must call setup to init sqlite db
		end,
	},
	-- run :BookmarksInfo to see the running status of the plugin
	{
		"tomasky/bookmarks.nvim",
		enabled = false,
		-- after = "telescope.nvim",
		-- event = "VimEnter",
		config = function()
			require("bookmarks").setup({
				save_file = vim.fn.expand("$HOME/.bookmarks"), -- bookmarks save file path
				keywords = {},
				---@diagnostic disable-next-line: unused-local
				on_attach = function(_bufnr)
					local bm = require("bookmarks")
					local map = vim.keymap.set
					map("n", "mm", bm.bookmark_toggle) -- add or remove bookmark at current line
					map("n", "mi", bm.bookmark_ann) -- add or edit mark annotation at current line
					map("n", "mc", bm.bookmark_clean) -- clean all marks in local buffer
					map("n", "mn", bm.bookmark_next) -- jump to next mark in local buffer
					map("n", "mp", bm.bookmark_prev) -- jump to previous mark in local buffer
					map("n", "ml", bm.bookmark_list) -- show marked file list in quickfix window
					map("n", "mx", bm.bookmark_clear_all) -- removes all bookmarks
					map("n", "mL", function()
						require("telescope").extensions.bookmarks.list()
					end)
				end,
			})
		end,
	},
	{
		"2kabhishek/markit.nvim",
		enabled = false,
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			{
				mode = { "n" },
				-- "<leader>mm",
				"<leader>mL",
				function()
					require("telescope").extensions.markit.bookmarks_list_all()
				end,
				{ noremap = true, silent = true },
			},

			{
				mode = { "n" },
				-- "<leader>mm",
				"<leader>ml",
				"<cmd>MarksQFListGlobal<cr>",
				{ noremap = true, silent = true },
			},
			-- {
			--   mode = { "n" },
			--   "<leader>mp",
			--   function()
			--     require("telescope").extensions.markit.bookmarks_list_all({ project_only = true })
			--   end,
			--   { noremap = true, silent = true },
			-- },
		},
		config = function()
			require("markit").setup({
				-- whether to map keybinds or not. default true
				default_mappings = true,
				-- which builtin marks to show. default {}
				-- builtin_marks = { ".", "<", ">", "^" },
				-- whether movements cycle back to the beginning/end of buffer. default true
				cyclic = true,
				-- whether the shada file is updated after modifying uppercase marks. default false
				force_write_shada = false,
				-- how often (in ms) to redraw signs/recompute mark positions.
				-- higher value means better performance but may cause visual lag,
				-- while lower value may cause performance penalties. default 150.
				refresh_interval = 150,
				-- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
				-- marks, and bookmarks.
				-- can be either a table with all/none of the keys, or a single number, in which case
				-- the priority applies to all marks.
				-- default 10.
				sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
				-- disables mark tracking for specific filetypes. default {}
				excluded_filetypes = { "qf", "NvimTree" },
				-- disables mark tracking for specific buftypes. default {}
				excluded_buftypes = {},
				-- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
				-- sign/virttext. Bookmarks can be used to group together positions and quickly move
				-- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
				-- default virt_text is "".
				bookmark_0 = {
					sign = "⚑",
					virt_text = "hello world",
					-- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
					-- defaults to false.
					annotate = false,
				},
				mappings = {},
			})
		end,
	},
	{
		-- regex plugin
		"OXY2DEV/patterns.nvim",
		enabled = false,
		cmd = { "Patterns" },
	},
	{
		"andersevenrud/nvim_context_vt",
		-- event = { "BufReadPre", "BufNewFile" },
		opts = {
			enabled = true,
		},
		keys = { { "<leader>co", "<cmd>NvimContextVtToggle<cr>" } },
	},
	-- lazy.nvim
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
	-- {
	--   'girishji/devdocs.vim',
	--   cmd = { "DevdocsFind", "DevdocsInstall" },
	-- },
	-- {
	--   "yuratomo/w3m.vim",
	-- },
	-- {
	--   "luckasRanarison/nvim-devdocs",
	--   dependencies = {
	--     "nvim-lua/plenary.nvim",
	--     "nvim-telescope/telescope.nvim",
	--     "nvim-treesitter/nvim-treesitter",
	--   },
	--   opts = {},
	-- },
	{
		"ragnarok22/whereami.nvim",
		cmd = "Whereami",
	},
	{
		"vzze/calculator.nvim",
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
		-- config = function()
		-- 	vim.api.nvim_create_user_command(
		-- 		"Calculate",
		-- 		'lua require("calculator").calculate()',
		-- 		{ ["range"] = 1, ["nargs"] = 0 }
		-- 	)
		-- end,
	},
	{ "sam4llis/nvim-lua-gf", keys = { "gf" } },
	{
		"tldr-pages/tldr-neovim-extension",
		cmd = { "Tldr", "Telescope" },
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("tldr").setup()
		end,
	},
	-- {
	--   "matthewmturner/rfsee",
	--   opts = {},
	--   cmd = { "RFSeeIndex", "RFSee" },
	--   dependencies = {
	--     "nvim-lua/plenary.nvim",
	--   },
	-- },
	{ "benelori/vim-rfc", cmd = { "RFC" } },
	{
		"troydm/zoomwintab.vim",
		keys = { { mode = { "n" }, "<c-w>m", "<cmd>ZoomWinTabToggle<CR>" } },
	},
	-- { "dhruvasagar/vim-zoom" },
	{
		"fasterius/simple-zoom.nvim",
		enabled = false,
		config = true,
		opts = {
			hide_tabline = false,
		},
	},
	{
		"vuki656/package-info.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		enabled = true,
		ft = { "json", "jsonc" },
		-- config = function (_, opts)
		--   require("package-info").setup(opts)
		-- end,

		opts = {
			-- colors = {
			--   up_to_date = "#94E2D5", -- Text color for up to date dependency virtual text
			--   outdated = "#313244", -- Text color for outdated dependency virtual text
			--   invalid = "#F38BA8", -- Text color for invalid dependency virtual text
			-- },
			icons = {
				enable = true, -- Whether to display icons
				style = {
					up_to_date = "|  ", -- Icon for up to date dependencies
					outdated = "| 󰃰 ", -- Icon for outdated dependencies
					invalid = "|  ", -- Icon for invalid dependencies
				},
			},
			autostart = false, -- Whether to autostart when `package.json` is opened
			hide_up_to_date = false, -- It hides up to date versions when displaying virtual text
			hide_unstable_versions = true, -- It hides unstable versions from version list e.g next-11.1.3-canary3
			-- Can be `npm`, `yarn`, or `pnpm`. Used for `delete`, `install` etc...
			-- The plugin will try to auto-detect the package manager based on
			-- `yarn.lock` or `package-lock.json`. If none are found it will use the
			-- provided one, if nothing is provided it will use `yarn`
			package_manager = "npm",
		},
		config = function(_, opts)
			require("package-info").setup(opts)
			-- manually register them
			vim.cmd("highlight PackageInfoUpToDateVersion guifg=#94E2D5 guibg=#394b70")
			vim.cmd("highlight PackageInfoOutdatedVersion guifg=#747ebd guibg=#394b70")
			vim.cmd("highlight PackageInfoInvalidVersion guifg=#F38BA8 guibg=#394b70")

			-- Show dependency versions
			-- vim.keymap.set({ "n" }, "<leader>ns", require("package-info").show, { silent = true, noremap = true })
			-- vim.api.nvim_set_keymap(
			--   "n",
			--   "<leader>nr",
			--   "<cmd>lua require('package-info').show({ force = true })<cr>",
			--   { silent = true, noremap = true }
			-- )

			-- -- Hide dependency versions
			-- vim.keymap.set({ "n" }, "<leader>nh", require("package-info").hide, { silent = true, noremap = true })

			-- Toggle dependency versions
			vim.keymap.set({ "n" }, "<leader>nt", require("package-info").toggle, { silent = true, noremap = true })

			-- vim.api.nvim_set_keymap(
			--   "n",
			--   "<leader>nt",
			--   "<cmd>lua require('package-info').toggle({ force = true })<cr>",
			--   { silent = true, noremap = true }
			-- )

			-- Update dependency on the line
			vim.keymap.set({ "n" }, "<leader>nu", require("package-info").update, { silent = true, noremap = true })

			-- Delete dependency on the line
			vim.keymap.set({ "n" }, "<leader>nd", require("package-info").delete, { silent = true, noremap = true })

			-- Install a new dependency
			-- vim.keymap.set({ "n" }, "<leader>ni", require("package-info").install, { silent = true, noremap = true })

			-- Install a different dependency version
			vim.keymap.set(
				{ "n" },
				"<leader>nc",
				require("package-info").change_version,
				{ silent = true, noremap = true }
			)
		end,
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
	-- {
	--   "alexxGmZ/Md2Pdf",
	--   cmd = "Md2Pdf"
	-- },

	-- {
	--   "andrewferrier/wrapping.nvim",
	--   config = function()
	--     require("wrapping").setup()
	--   end,
	-- },
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

		-- Uncomment next line if you want to follow only stable versions
		-- version = "*"
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
		"gennaro-tedesco/nvim-jqx",
		event = { "BufReadPost" },
		enabled = false,
		ft = { "json", "yaml" },
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
		"christoomey/vim-tmux-navigator",
		enabled = false,
		-- event = "VeryLazy",
		-- commit = "d847ea942a5bb4d4fab6efebc9f30d787fd96e65",
		keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
		config = function()
			vim.g.tmux_navigator_disable_when_zoomed = 1
			vim.g.tmux_navigator_preserve_zoom = 1
		end,
	},

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
	{ "tpope/vim-surround", event = { "BufReadPost", "BufNewFile" } },
	{
		"windwp/nvim-ts-autotag",
		ft = { "html", "htmlangular" },
		-- opts = {
		--   aliases = {
		--     ["htmlangular"] = "html",
		--   },
		-- },
		config = function()
			require("nvim-ts-autotag").setup({
				aliases = {
					["html"] = "html",
					["htmlangular"] = "html",
				},
			})
		end,
	},
	{ "tpope/vim-dispatch", lazy = true },
	{ "kkharji/sqlite.lua", lazy = true },
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
