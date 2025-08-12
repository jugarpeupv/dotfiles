return {
	"yetone/avante.nvim",
	enabled = function()
		local is_headless = #vim.api.nvim_list_uis() == 0
		if is_headless then
			return false
		end
		return true
	end,
	-- event = "BufReadPost",
	version = "*",
	-- version = false,
	opts = {
		-- system_prompt as function ensures LLM always has latest MCP server state
		-- This is evaluated for every message, even in existing chats
		system_prompt = function()
			local hub = require("mcphub").get_hub_instance()
			return hub and hub:get_active_servers_prompt() or ""
		end,
		-- Using function prevents requiring mcphub before it's loaded
		custom_tools = function()
			return {
				require("mcphub.extensions.avante").mcp_tool(),
			}
		end,
		disabled_tools = {
			"list_files", -- Built-in file operations
			"search_files",
			"read_file",
			"create_file",
			"rename_file",
			"delete_file",
			"create_dir",
			"rename_dir",
			"delete_dir",
			"bash", -- Built-in terminal access
		},
		provider = "copilot",
		input = {
			provider = "dressing",
			provider_opts = {},
		},
		selector = {
			--- @alias avante.SelectorProvider "native" | "fzf_lua" | "mini_pick" | "snacks" | "telescope" | fun(selector: avante.ui.Selector): nil
			--- @type avante.SelectorProvider
			provider = "telescope",
			-- Options override for custom providers
			provider_opts = {},
      exclude_auto_select = { "NvimTree" },
		},
		windows = {
			---@type "right" | "left" | "top" | "bottom"
			position = "right", -- the position of the sidebar
			wrap = true, -- similar to vim.o.wrap
			width = 50, -- default % based on available width
			sidebar_header = {
				enabled = false, -- true, false to enable/disable the header
				align = "center", -- left, center, right for title
				rounded = true,
			},
			input = {
				prefix = "> ",
				height = 8, -- Height of the input window in vertical layout
				provider = "dressing",
				provider_opts = {},
			},
			edit = {
				border = "rounded",
				start_insert = false, -- Start insert mode when opening the edit window
			},
			ask = {
				floating = false, -- Open the 'AvanteAsk' prompt in a floating window
				start_insert = false, -- Start insert mode when opening the ask window
				border = "rounded",
				---@type "ours" | "theirs"
				focus_on_apply = "ours", -- which diff to focus after applying
			},
		},
		mappings = {
			ask = "<leader>aa", -- ask
			edit = "<leader>ae", -- edit
			refresh = "<leader>ar", -- refresh

			diff = {
				ours = "cc",
				theirs = "ci",
				all_theirs = "ca",
				both = "cb",
				cursor = "cu",
				next = "]x",
				prev = "[x",
			},
			-- suggestion = {
			--   accept = "<M-l>",
			--   next = "<M-]>",
			--   prev = "<M-[>",
			--   dismiss = "<C-]>",
			-- },
			jump = {
				next = "]]",
				prev = "[[",
			},
			submit = {
				normal = "<CR>",
				insert = "<C-s>",
			},
			sidebar = {
				apply_all = "A",
				apply_cursor = "a",
				switch_windows = "<Tab>",
				reverse_switch_windows = "<S-Tab>",
			},
		},
		hints = { enabled = false },
	},
	keys = function(_, keys)
		local opts =
			require("lazy.core.plugin").values(require("lazy.core.config").spec.plugins["avante.nvim"], "opts", false)

		local mappings = {
			{
				"<leader>pa",
				function()
					return vim.bo.filetype == "AvanteInput" and require("avante.clipboard").paste_image()
						or require("img-clip").paste_image()
				end,
				desc = "clip: paste image",
			},
			{
				opts.mappings.ask,
				function()
					require("avante.api").ask()
				end,
				desc = "avante: ask",
				mode = { "n", "v" },
			},
			{
				opts.mappings.refresh,
				function()
					require("avante.api").refresh()
				end,
				desc = "avante: refresh",
				mode = "v",
			},
			{
				opts.mappings.edit,
				function()
					require("avante.api").edit()
				end,
				desc = "avante: edit",
				mode = { "n", "v" },
			},
      {
        "<leader>a+",
        function()
          local tree_ext = require("avante.extensions.nvim_tree")
          tree_ext.add_file()
        end,
        desc = "Select file in NvimTree",
        ft = "NvimTree",
      },
      {
        "<leader>a-",
        function()
          local tree_ext = require("avante.extensions.nvim_tree")
          tree_ext.remove_file()
        end,
        desc = "Deselect file in NvimTree",
        ft = "NvimTree",
      },
		}
		mappings = vim.tbl_filter(function(m)
			return m[1] and #m[1] > 0
		end, mappings)
		return vim.list_extend(mappings, keys)
	end,
	-- lazy = false,
	-- version = false, -- set this if you want to always pull the latest change
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	build = "make",
	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		{
			"stevearc/dressing.nvim",
			-- keys = { "<leader>re", "<M-.>" },
			opts = {
				input = {
					-- Set to false to disable the vim.ui.input implementation
					enabled = false,

					-- Default prompt string
					default_prompt = "Input",

					-- Trim trailing `:` from prompt
					trim_prompt = true,

					-- Can be 'left', 'right', or 'center'
					title_pos = "left",

					-- When true, input will start in insert mode.
					start_in_insert = false,

					-- These are passed to nvim_open_win
					border = "rounded",
					-- 'editor' and 'win' will default to being centered
					relative = "cursor",

					-- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
					prefer_width = 40,
					width = nil,
					-- min_width and max_width can be a list of mixed types.
					-- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
					max_width = { 140, 0.9 },
					min_width = { 20, 0.2 },

					buf_options = {},
					win_options = {
						-- Disable line wrapping
						wrap = false,
						-- Indicator for when text exceeds window
						list = true,
						listchars = "precedes:…,extends:…",
						-- Increase this for more context when text scrolls off the window
						sidescrolloff = 0,
					},

					-- Set to `false` to disable
					mappings = {
						n = {
							["<Esc>"] = "Close",
							["<CR>"] = "Confirm",
						},
						i = {
							["<C-c>"] = "Close",
							["<CR>"] = "Confirm",
							["<Up>"] = "HistoryPrev",
							["<Down>"] = "HistoryNext",
						},
					},

					override = function(conf)
						-- This is the config that will be passed to nvim_open_win.
						-- Change values here to customize the layout
						return conf
					end,

					-- see :help dressing_get_config
					get_config = nil,
				},
				select = {
					-- Set to false to disable the vim.ui.select implementation
					enabled = true,

					-- Priority list of preferred vim.select implementations
					backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },

					-- Trim trailing `:` from prompt
					trim_prompt = true,

					-- Options for telescope selector
					-- These are passed into the telescope picker directly. Can be used like:
					-- telescope = require('telescope.themes').get_ivy({...})
					telescope = nil,

					-- Options for fzf selector
					fzf = {
						window = {
							width = 0.5,
							height = 0.4,
						},
					},

					-- Options for fzf-lua
					fzf_lua = {
						-- winopts = {
						--   height = 0.5,
						--   width = 0.5,
						-- },
					},

					-- Options for nui Menu
					nui = {
						position = "50%",
						size = nil,
						relative = "editor",
						border = {
							style = "rounded",
						},
						buf_options = {
							swapfile = false,
							filetype = "DressingSelect",
						},
						win_options = {
							winblend = 0,
						},
						max_width = 80,
						max_height = 40,
						min_width = 40,
						min_height = 10,
					},

					-- Options for built-in selector
					builtin = {
						-- Display numbers for options and set up keymaps
						show_numbers = true,
						-- These are passed to nvim_open_win
						border = "rounded",
						-- 'editor' and 'win' will default to being centered
						relative = "editor",

						buf_options = {},
						win_options = {
							cursorline = true,
							cursorlineopt = "both",
						},

						-- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
						-- the min_ and max_ options can be a list of mixed types.
						-- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
						width = nil,
						max_width = { 140, 0.8 },
						min_width = { 40, 0.2 },
						height = nil,
						max_height = 0.9,
						min_height = { 10, 0.2 },

						-- Set to `false` to disable
						mappings = {
							["<Esc>"] = "Close",
							["<C-c>"] = "Close",
							["<CR>"] = "Confirm",
						},

						override = function(conf)
							-- This is the config that will be passed to nvim_open_win.
							-- Change values here to customize the layout
							return conf
						end,
					},

					-- Used to override format_item. See :help dressing-format
					format_item_override = {},

					-- see :help dressing_get_config
					get_config = nil,
				},
			},
		},
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
		},
		{ "ravitemer/mcphub.nvim" },
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
