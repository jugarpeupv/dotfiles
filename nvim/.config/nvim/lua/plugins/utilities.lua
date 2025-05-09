-- return {}
return {
	-- Lua
	-- { "HawkinsT/pathfinder.nvim" },
	{
		"rmagatti/auto-session",
		enabled = true,
		-- event = "BufReadPost",
		lazy = true,
		keys = {
			-- Will use Telescope if installed or a vim.ui.select picker otherwise
			{ "<leader>ws", "<cmd>SessionSearch<CR>", desc = "Session search" },
			{ "<leader>wa", "<cmd>SessionSave<CR>", desc = "Save session" },
		},
		---enables autocomplete for opts
		---@module "auto-session"
		---@type AutoSession.Config
		opts = {
			enabled = true, -- Enables/disables auto creating, saving and restoring
			root_dir = vim.fn.stdpath("data") .. "/sessions/", -- Root dir where sessions will be stored
			auto_save = true, -- Enables/disables auto saving session on exit
			auto_restore = true, -- Enables/disables auto restoring session on start
			auto_create = true, -- Enables/disables auto creating new session files. Can take a function that should return true/false if a new session file should be created or not
			suppressed_dirs = nil, -- Suppress session restore/create in certain directories
			allowed_dirs = nil, -- Allow session restore/create in certain directories
			auto_restore_last_session = true, -- On startup, loads the last saved session if session for cwd does not exist
			git_use_branch_name = true, -- Include git branch name in session name
			git_auto_restore_on_branch_change = false, -- Should we auto-restore the session when the git branch changes. Requires git_use_branch_name
			lazy_support = true, -- Automatically detect if Lazy.nvim is being used and wait until Lazy is done to make sure session is restored correctly. Does nothing if Lazy isn't being used. Can be disabled if a problem is suspected or for debugging
			bypass_save_filetypes = nil, -- List of filetypes to bypass auto save when the only buffer open is one of the file types listed, useful to ignore dashboards
			close_unsupported_windows = true, -- Close windows that aren't backed by normal file before autosaving a session
			args_allow_single_directory = true, -- Follow normal sesion save/load logic if launched with a single directory as the only argument
			args_allow_files_auto_save = false, -- Allow saving a session even when launched with a file argument (or multiple files/dirs). It does not load any existing session first. While you can just set this to true, you probably want to set it to a function that decides when to save a session when launched with file args. See documentation for more detail
			continue_restore_on_error = true, -- Keep loading the session even if there's an error
			show_auto_restore_notif = false, -- Whether to show a notification when auto-restoring
			cwd_change_handling = true, -- Follow cwd changes, saving a session before change and restoring after
			lsp_stop_on_restore = false, -- Should language servers be stopped when restoring a session. Can also be a function that will be called if set. Not called on autorestore from startup
			restore_error_handler = nil, -- Called when there's an error restoring. By default, it ignores fold errors otherwise it displays the error and returns false to disable auto_save
			purge_after_minutes = 14400, -- Sessions older than purge_after_minutes will be deleted asynchronously on startup, e.g. set to 14400 to delete sessions that haven't been accessed for more than 10 days, defaults to off (no purging), requires >= nvim 0.10
			post_restore_cmds = {
				function()
					-- Restore nvim-tree after a session is restored
					local nvim_tree_api = require("nvim-tree.api")
					nvim_tree_api.tree.open()
					nvim_tree_api.tree.change_root(vim.fn.getcwd())
					nvim_tree_api.tree.reload()
				end,
			},

			-- ⚠️ This will only work if Telescope.nvim is installed
			-- The following are already the default values, no need to provide them if these are already the settings you want.

			session_lens = {
				-- If load_on_setup is false, make sure you use `:SessionSearch` to open the picker as it will initialize everything first
				load_on_setup = true,
				previewer = true,
				mappings = {
					-- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
					delete_session = { "i", "<C-D>" },
					alternate_session = { "i", "<C-S>" },
					copy_session = { "i", "<C-Y>" },
				},
				-- Can also set some Telescope picker options
				-- For all options, see: https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt#L112
				theme_conf = {
					border = true,
					layout_config = {
						width = 0.8, -- Can set width and height as percent of window
						height = 0.5,
					},
				},
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
		},
	},
	{
		"farmergreg/vim-lastplace",
		event = { "BufNewFile", "BufReadPost" },
	},
	{
		"vim-scripts/applescript.vim",
		event = { "BufNewFile", "BufReadPre" },
	},
	{ "tpope/vim-bundler", event = { "BufNewFile", "BufReadPre" } },
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
			{ "stevearc/dressing.nvim" }, -- optional: better UI
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
				on_attach = function(bufnr)
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
		"OXY2DEV/patterns.nvim",
		cmd = { "Patterns" },
	},
	{
		"andersevenrud/nvim_context_vt",
		-- event = { "BufReadPre", "BufNewFile" },
		opts = {
			enabled = false,
		},
		keys = { { "<leader>co", "<cmd>NvimContextVtToggle<cr>" } },
	},
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
				-- "dom",
				"http",
				-- "css",
				-- "javascript",
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
		event = { "BufReadPost" },
		config = function()
			vim.api.nvim_create_user_command(
				"Calculate",
				'lua require("calculator").calculate()',
				{ ["range"] = 1, ["nargs"] = 0 }
			)
		end,
	},
	{ "sam4llis/nvim-lua-gf", keys = { "gf" } },
	-- { "mrjones2014/tldr.nvim", cmd = { "Tldr", "Telescope" } ,dependencies = { "nvim-telescope/telescope.nvim" } },
	{
		"tldr-pages/tldr-neovim-extension",
		-- enabled = false,
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
	{
		"philosofonusus/ecolog.nvim",
		enabled = true,
		-- commit = "d92107c88febabc2f51190339cabf0bc5e072bd9",
		-- dependencies = {
		--   -- "hrsh7th/nvim-cmp", -- Optional: for autocompletion support (recommended)
		--   "nvim-tree/nvim-tree.lua"
		-- },
		event = { "BufReadPre", "BufNewFile" },
		-- Optional: you can add some keybindings
		-- (I personally use lspsaga so check out lspsaga integration or lsp integration for a smoother experience without separate keybindings)
		keys = {
			{ "<leader>eg", "<cmd>EcologGoto<cr>", desc = "Go to env file" },
			{ "<leader>ep", "<cmd>EcologPeek<cr>", desc = "Ecolog peek variable" },
			{ "<leader>es", "<cmd>EcologSelect<cr>", desc = "Switch env file" },
			{ "<leader>el", "<cmd>EcologShelterLinePeek<cr>", desc = "Ecolog Shelter Line Peek" },
			{ "<leader>et", "<cmd>EcologShelterToggle<cr>", desc = "Ecolog Shelter Line Peek" },
		},
		lazy = true,
		opts = {
			integrations = {
				-- WARNING: for both cmp integrations see readme section below
				files = true,
				nvim_cmp = true, -- If you dont plan to use nvim_cmp set to false, enabled by default
				-- If you are planning to use blink cmp uncomment this line
				-- blink_cmp = true,
			},
			-- Enables shelter mode for sensitive values
			shelter = {
				configuration = {
					partial_mode = false,
					skip_comments = false,
				},
				modules = {
					cmp = true, -- Mask values in completion
					peek = true, -- Mask values in peek view
					telescope = true, -- Mask values in telescope
					telescope_previewer = true, -- Mask values in telescope preview buffers
					files = {
						shelter_on_leave = false, -- Control automatic re-enabling of shelter when leaving buffer
						disable_cmp = false, -- Disable completion in sheltered buffers (default: true)
					},
				},
			},
			-- true by default, enables built-in types (database_url, url, etc.)
			types = true,
			path = vim.fn.getcwd(), -- Path to search for .env files
			preferred_environment = "development", -- Optional: prioritize specific env files
			env_file_patterns = {
				"*.env*",
				".env",
				".env.*",
				"config/env.*",
				".env.local.*",
				-- "*.zshrc",
				-- ".config/zshrc/*.zshrc",
				-- "/Users/jgarcia/.config/zshrc/.zshrc",
				-- ".config/zshrc/.zshrc",
				".config/zshrc/.env.*",
			},
			-- env_file_pattern = {
			--   ".env",
			--   "^%.env%.%w+$",    -- Matches .env.development, .env.production, etc.
			--   "^config/env%.%w+$", -- Matches config/env.development, config/env.production, etc.
			--   "^%.env%.local%.%w+$", -- Matches .env.local.development, .env.local.production, etc.
			--   ".+%.zsh$",
			--   ".+%.zshrc$",
			--   "^.config/zshrc/.+%.zshrc$",
			--   "/Users/jgarcia/.config/zshrc/.zshrc",
			--   "^%.config/zshrc/%.zshrc$", -- Matches .config/zshrc/.zshrc
			--   "^.config/zshrc/^%.env%.%w+$", -- Matches config/env.development, config/env.production, etc.
			-- },
			-- Controls how environment variables are extracted from code and how cmp works
			provider_patterns = true, -- true by default, when false will not check provider patterns
		},

		-- opts = {
		--   integrations = {
		--     lsp = false,
		--     fzf = true,
		--   },
		--   -- Enables shelter mode for sensitive values
		--   shelter = {
		--     configuration = {
		--       partial_mode = false, -- false by default, disables partial mode, for more control check out shelter partial mode
		--       mask_char = "*", -- Character used for masking
		--       -- patterns = {
		--       --   ["*_KEY"] = "full", -- Always fully mask API keys
		--       --   ["*_TOKEN"] = "full", -- Always fully mask API keys
		--       --   ["*_PAT"] = "full", -- Always fully mask API keys
		--       --   ["*_KEY_*"] = "full", -- Always fully mask API keys
		--       -- },
		--     },
		--     modules = {
		--       cmp = true,  -- Mask values in completion
		--       peek = false, -- Mask values in peek view
		--       files = true, -- Mask values in files
		--       telescope = true, -- Mask values in telescope
		--     },
		--   },
		--   -- true by default, enables built-in types (database_url, url, etc.)
		--   types = true,
		--   path = vim.fn.getcwd(), -- Path to search for .env files
		--   env_file_pattern = {
		--     "^%.env%.%w+$",       -- Matches .env.development, .env.production, etc.
		--     "^config/env%.%w+$",  -- Matches config/env.development, config/env.production, etc.
		--     "^%.env%.local%.%w+$", -- Matches .env.local.development, .env.local.production, etc.
		--     ".+%.zsh$",
		--     ".+%.zshrc$",
		--     "^.config/zshrc/.+%.zshrc$",
		--     "/Users/jgarcia/.config/zshrc/.zshrc",
		--     "^%.config/zshrc/%.zshrc$", -- Matches .config/zshrc/.zshrc
		--     "^.config/zshrc/^%.env%.%w+$",  -- Matches config/env.development, config/env.production, etc.
		--   },
		--   preferred_environment = "development", -- Optional: prioritize specific env files
		-- },
	},

	{ "heavenshell/vim-jsdoc", cmd = { "JsDoc" } },
	{
		"barrett-ruth/live-server.nvim",
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
	-- {
	--   "chentoast/marks.nvim",
	--   event = "VeryLazy",
	--   opts = {},
	-- },
	-- {
	--   "MattesGroeger/vim-bookmarks",
	--   config = function()
	--     vim.g.bookmark_save_per_working_dir = 1
	--     vim.g.bookmark_auto_save = 1
	--     vim.g.bookmark_sign = ''
	--     vim.cmd([[highlight BookmarkSign guifg=#89B4FA]])
	--     vim.cmd([[" Finds the Git super-project directory.
	--       function! g:BMWorkDirFileLocation()
	--           let filename = 'bookmarks'
	--           let location = ''
	--           if isdirectory('.git')
	--               " Current work dir is git's work tree
	--               let location = getcwd().'/.git'
	--           else
	--               " Look upwards (at parents) for a directory named '.git'
	--               let location = finddir('info', '.;')
	--           endif
	--           if len(location) > 0
	--               return location.'/'.filename
	--           else
	--               return getcwd().'/.'.filename
	--           endif
	--       endfunction]])
	--     vim.keymap.set("n", "<leader>mm", "<cmd>Telescope vim_bookmarks all<cr>", { noremap = true, silent = true })
	--   end,
	-- },
	{
		"hedyhli/outline.nvim",
		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		keys = { -- Example mapping to toggle outline
			{ "<leader>ot", "<cmd>Outline<CR>", desc = "Toggle outline" },
		},
		opts = {
			-- Your setup opts here
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
	-- https://github.com/johmsalas/text-case.nvim
	-- { "VidocqH/data-viewer.nvim" },
	-- { "Djancyp/regex.nvim" },
	-- {"https://github.com/gabrielpoca/replacer.nvim"},
	-- { "Wansmer/sibling-swap.nvim" },
	-- { "nvim-spider" }
	-- { "airblade/vim-matchquote" },
	-- { "ton/vim-bufsurf" },
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
	-- { https://github.com/axieax/urlview.nvim }
	{ "dstein64/vim-startuptime", cmd = { "StartupTime" } },
	-- { "dstein64/vim-startuptime", event = "VeryLazy" },
	{
		"christoomey/vim-tmux-navigator",
		-- event = "VeryLazy",
		commit = "d847ea942a5bb4d4fab6efebc9f30d787fd96e65",
		keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
		config = function()
			vim.g.tmux_navigator_disable_when_zoomed = 1
			vim.g.tmux_navigator_preserve_zoom = 1
		end,
	},

	{ "wellle/targets.vim", event = { "BufReadPost", "BufNewFile" } },
	-- {
	--   "ibhagwan/fzf-lua",
	--   -- optional for icon support
	--   dependencies = { "nvim-tree/nvim-web-devicons" },
	--   event = { "BufReadPost" },
	--   config = function()
	--     -- calling `setup` is optional for customization
	--     require("fzf-lua").setup({})
	--   end,
	-- },
	{
		"junegunn/fzf",
		dependencies = { "junegunn/fzf.vim" },
		build = "./install --all",
		event = { "BufReadPost" },
		cmd = { "G" },
		keys = {

			{ "<leader>jl", "<cmd>Jumps<CR>" },
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
				"<cmd>Git! fetch --all -v<cr>",
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
				"<Leader>gC",
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
