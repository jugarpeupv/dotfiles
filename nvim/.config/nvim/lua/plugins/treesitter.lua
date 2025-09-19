-- return {}
return {
	{
		"nvim-treesitter/nvim-treesitter",
		-- branch = "master",
		-- lazy = false,
		branch = "main",
		build = ":TSUpdate",
		-- lazy = true,
		-- lazy = true,
		-- branch = 'main',
		-- build = ':TSUpdate',
		event = { "BufReadPost", "BufNewFile" },
		-- cmd = { "TSInstall", "TSBufEnable", "TSModuleInfo" },
		dependencies = {
      {
        'daliusd/incr.nvim',
        opts = {
          incr_key = '<cr>', -- increment selection key
          decr_key = '<bs>', -- decrement selection key
        },
      },
			{ "wellle/targets.vim", event = { "BufReadPost", "BufNewFile" } },
			-- "RRethy/nvim-treesitter-endwise",
			{ "cfdrake/vim-pbxproj" },
			-- {
			-- 	-- cmd = { "TSPlaygroundToggle" },
			-- 	"nvim-treesitter/playground",
			-- },
			{
				"axelvc/template-string.nvim",
				config = function()
					require("template-string").setup({
						filetypes = {
							"html",
							"typescript",
							"javascript",
							"typescriptreact",
							"javascriptreact",
							"vue",
							"svelte",
							"python",
							"cs",
						}, -- filetypes where the plugin is active
						jsx_brackets = true, -- must add brackets to JSX attributes
						remove_template_string = true, -- remove backticks when there are no template strings
						restore_quotes = {
							-- quotes used when "remove_template_string" option is enabled
							normal = [[']],
							jsx = [["]],
						},
					})
				end,
			},
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				branch = "main",
				config = function()
					-- configuration
					require("nvim-treesitter-textobjects").setup({
						select = {
							enable = true,

							-- Automatically jump forward to textobj, similar to targets.vim
							lookahead = true,

							-- You can choose the select mode (default is charwise 'v')
							--
							-- Can also be a function which gets passed a table with the keys
							-- * query_string: eg '@function.inner'
							-- * method: eg 'v' or 'o'
							-- and should return the mode ('v', 'V', or '<c-v>') or a table
							-- mapping query_strings to modes.
							selection_modes = {
								["@parameter.outer"] = "v", -- charwise
								["@function.outer"] = "V", -- linewise
								["@class.outer"] = "<c-v>", -- blockwise
							},
							-- If you set this to `true` (default is `false`) then any textobject is
							-- extended to include preceding or succeeding whitespace. Succeeding
							-- whitespace has priority in order to act similarly to eg the built-in
							-- `ap`.
							--
							-- Can also be a function which gets passed a table with the keys
							-- * query_string: eg '@function.inner'
							-- * selection_mode: eg 'v'
							-- and should return true of false
							include_surrounding_whitespace = false,
						},
					})

					-- keymaps
					-- You can use the capture groups defined in `textobjects.scm`
					vim.keymap.set({ "x", "o" }, "af", function()
						require("nvim-treesitter-textobjects.select").select_textobject(
							"@function.outer",
							"textobjects"
						)
					end)
					vim.keymap.set({ "x", "o" }, "if", function()
						require("nvim-treesitter-textobjects.select").select_textobject(
							"@function.inner",
							"textobjects"
						)
					end)

					vim.keymap.set({ "x", "o" }, "ih", function()
						require("nvim-treesitter-textobjects.select").select_textobject(
							"@assignment.lhs",
							"textobjects"
						)
					end)

					vim.keymap.set({ "x", "o" }, "il", function()
						require("nvim-treesitter-textobjects.select").select_textobject(
							"@assignment.rhs",
							"textobjects"
						)
					end)

					vim.keymap.set({ "x", "o" }, "ac", function()
						require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
					end)
					vim.keymap.set({ "x", "o" }, "ic", function()
						require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
					end)

					local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

					-- Repeat movement with ; and ,
					-- ensure ; goes forward and , goes backward regardless of the last direction
					vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { expr = true })
					vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous, { expr = true })

					-- vim way: ; goes to the direction you were moving.
					-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
					-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

					-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
					vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
					vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
					vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
					vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
				end,
				-- enabled = false,
				-- event = { "BufReadPre", "BufNewFile" },
				-- cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
				-- event = "VeryLazy",
				-- dependencies = "nvim-treesitter/nvim-treesitter",
			},
			-- "nvim-treesitter/nvim-treesitter-refactor",
			-- {
			--   "RRethy/nvim-treesitter-textsubjects",
			--   config = function()
			--     require("nvim-treesitter-textsubjects").configure({
			--       prev_selection = ",",
			--       keymaps = {
			--         ["."] = "textsubjects-smart",
			--         [";"] = "textsubjects-container-outer",
			--         ["i;"] = "textsubjects-container-inner",
			--       },
			--     })
			--   end,
			-- },
			{
				"chrisgrieser/nvim-various-textobjs",
				-- event = "VeryLazy",
				-- event = { "BufReadPost", "BufNewFile" },
				keys = {
					{ mode = { "o", "x" }, "as", "<cmd>lua require('various-textobjs').subword('outer')<CR>" },
					{ mode = { "o", "x" }, "is", "<cmd>lua require('various-textobjs').subword('inner')<CR>" },
					-- {
					-- 	mode = { "n" },
					-- 	"gx",
					-- 	function()
					-- 		require("various-textobjs").url() -- select URL
					--
					-- 		local foundURL = vim.fn.mode() == "v" -- only switches to visual mode when textobj found
					-- 		if not foundURL then
					-- 			return
					-- 		end
					--
					-- 		local url = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), { type = "v" })[1]
					-- 		vim.ui.open(url) -- requires nvim 0.10
					-- 		vim.cmd.normal({ "v", bang = true })
					-- 	end,
					-- },
					-- {
					-- 	mode = { "n" },
					-- 	"gf",
					-- 	function()
					-- 		require("various-textobjs").filepath("outer") -- select filepath
					--
					-- 		local foundPath = vim.fn.mode() == "v" -- only switches to visual mode when textobj found
					-- 		if not foundPath then
					-- 			return
					-- 		end
					--
					-- 		local path = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), { type = "v" })[1]
					--
					-- 		local exists = vim.uv.fs_stat(vim.fs.normalize(path)) ~= nil
					-- 		if exists then
					-- 			vim.ui.open(path)
					-- 		else
					-- 			vim.notify("Path does not exist.", vim.log.levels.WARN)
					-- 		end
					-- 	end,
					-- },
				},
				opts = {
					keymaps = {
						useDefaults = true,
						disabledDefaults = { "L", "in", "an" },
					},
				},
				-- config = function(_, opts)
				-- 	require("various-textobjs").setup(opts)
				-- 	-- example: `as` for outer subword, `is` for inner subword
				-- 	-- vim.keymap.set({ "o", "x" }, "as", '<cmd>lua require("various-textobjs").subword("outer")<CR>')
				-- 	-- vim.keymap.set({ "o", "x" }, "is", '<cmd>lua require("various-textobjs").subword("inner")<CR>')
				-- end,
			},
			{
				"jugarpeupv/nvim-treesitter-context",
				lazy = true,
				-- dir='~/private/nvim-treesitter-context',
				-- dev = true,
				-- event = { "BufReadPost", "BufNewFile" },
				-- cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
				-- affects = "nvim-treesitter",
				-- event = "VeryLazy",
				config = function()
					require("treesitter-context").setup({
						enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
						multiwindow = true, -- Enable multiple floating windows
						max_lines = 6, -- How many lines the window should span. Values <= 0 mean no limit.
						trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
						min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
						zindex = 20, -- The Z-index of the context window
						mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
						-- Separator between context and content. Should be a single character string, like '-'.
						-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
						separator = nil,
						-- separator = '.',
						-- on_attach = function(bufnr)
						--   return true
						-- end
						-- separator = "─",
						-- on_attach = function(bufnr)
						--   -- return true
						-- 	if vim.wo.diff then
						-- 		return false
						-- 	end
						--
						-- 	if vim.opt.diff:get() then
						-- 		return false
						-- 	end
						--
						-- 	local current_filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
						-- 	return current_filetype ~= 'DiffviewFiles'
						-- end
					})

					vim.cmd([[highlight TreesitterContext guifg=#B4BEFE]])
				end,
			},
		},
		-- build = function()
		-- 	require("nvim-treesitter.install").update({ with_sync = true })
		-- end,
		config = function()
			-- import nvim-treesitter plugin safely
			-- local status, treesitter = pcall(require, "nvim-treesitter.configs")
			local status, treesitter = pcall(require, "nvim-treesitter")
			if not status then
				return
			end

			-- configure treesitter
			treesitter.setup({
				-- endwise = {
				--   enable = true,
				-- },
				-- refactor = {
				--   highlight_definitions = {
				--     enable = false,
				--     -- Set to false if you have an `updatetime` of ~100.
				--     clear_on_cursor_move = true,
				--   },
				-- },

				-- enable syntax highlighting
				-- refactor = {
				-- 	navigation = { enable = false },
				-- 	highlight_current_scope = { enable = false },
				-- 	smart_rename = {
				-- 		enable = false,
				-- 		-- Assign keymaps to false to disable them, e.g. `smart_rename = false`.
				-- 		keymaps = {
				-- 			smart_rename = "grr",
				-- 		},
				-- 	},
				-- 	highlight_definitions = {
				-- 		enable = false,
				-- 		-- Set to false if you have an `updatetime` of ~100.
				-- 		clear_on_cursor_move = false,
				-- 	},
				-- },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<CR>",
						node_incremental = "<CR>",
						scope_incremental = "<Tab>",
						node_decremental = "<S-Tab>",
					},
				},
				sync_install = true,
				-- ignore_install = { "yaml" },
				-- ignore_install = {},
				modules = {},
				-- enable indentation
				-- indent = { enable = true },
				indent = {
					enable = true,
					disable = { "yaml" },
				},
				-- enable autotagging (w/ nvim-ts-autotag plugin)
				-- autotag = { enable = true },
				-- ensure these language parsers are installed
				ensure_installed = {
					-- "lua_patterns",
					"toml",
					"ruby",
					"swift",
					"json",
					"jsonc",
					"json5",
					"angular",
					"gitignore",
					"git_config",
					"git_rebase",
					"gitattributes",
					"gitcommit",
					"gitignore",
					"vimdoc",
					"luadoc",
					"vim",
					"lua",
					"javascript",
					"xml",
					"http",
					"java",
					"jq",
					"jsdoc",
					"groovy",
					"typescript",
					"tsx",
					"html",
					"css",
					"yaml",
					-- "sql",
					"markdown",
					"markdown_inline",
					-- "svelte",
					"graphql",
					"bash",
					"lua",
					"luadoc",
					"vim",
					"dockerfile",
					"rust",
					"cpp",
					"dap_repl",
					"regex",
				},
				-- ignore_install =  { "dockerfile" },
				-- auto install above language parsers
				auto_install = false,
				rainbow = {
					enable = true,
					disable = { "html" },
					-- query = 'rainbow-parens',
					-- strategy = require('ts-rainbow').strategy.global
					-- extended_mode = true,
					-- max_file_lines = nil,
					colors = {
						-- vscode
						-- "#DCDCAA",
						-- "#569CD6",
						-- "#9CDCFE",

						-- catpuccin
						"#C6A0F6",
						"#8AADF4",
						"#F0C6C6",

						-- tokyo
						-- "#7aa2f7",
						-- "#2ac3de",
						-- "#9d7cd8",
					}, -- table of hex strings
					-- termcolors = {} -- table of colour name strings
				},
				matchup = {
					enable = true,
					disable_virtual_text = false,
					disable = { "javascript", "typescript" },
				},
			})

			--
			-- parser_configs.lua_patterns = {
			--   install_info = {
			--     url = "https://github.com/OXY2DEV/tree-sitter-lua_patterns",
			--     files = { "src/parser.c" },
			--     branch = "main",
			--   },
			-- }

			-- local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
			---@diagnostic disable-next-line: inject-field
			-- parser_configs.ghactions = {
			-- 	install_info = {
			-- 		url = "https://github.com/rmuir/tree-sitter-ghactions",
			--       files = { "src/parser.c" },
			-- 		-- queries = "queries",
			-- 		branch = "main",
			-- 		--      generate_requires_npm = true, -- if stand-alone parser without npm dependencies
			-- 		--      requires_generate_from_grammar = true
			-- 	},
			-- }
			-- vim.treesitter.language.register('ghactions', 'yaml')  -- the someft filetype will use the python parser and queries.
			-- custom parsers
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
          "java",
					"yaml",
					"yaml.github",
					"jsonc",
					"sh",
					"dosini",
					"editorconfig",
					"typescript",
					"javascript",
					"gitcommit",
					"hurl",
          "markdown",
          "jproperties",
          "properties",
          "codecompanion",
          "bash",
          "html",
          "htmlangular",
          "scss",
          "css",
          "groovy",
          "Avante",
          "dockerfile"
				},
				callback = function()
          -- callback = function(ev)
          -- event fired: {
          --   buf = 10,
          --   event = "FileType",
          --   file = "package.json",
          --   id = 132,
          --   match = "jsonc"
          -- }

					-- if
					-- 	(ev.match == "json" or ev.match == "jsonc")
					-- 	-- and vim.api.nvim_buf_get_name(ev.buf):match("package%-lock%.json")
					--        and ev.file:match("package%-lock%.json")
					-- then
					-- 	vim.api.nvim_buf_set_option(ev.buf, "foldmethod", "syntax")
					--        return
					-- end
					--
					--      local line_number = 1
					--      local line = vim.fn.getline(line_number)
					--      local char_count = #line
					--
					--      if char_count > 1500 then
					--        vim.api.nvim_buf_set_option(ev.buf, "foldmethod", "syntax")
					--        return
					--        -- print("char_count > 1500, disabling treesitter")
					--      end
					--
					--      local max_filesize = 500 * 1024 -- 100 KB
					--      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
					--      if ok and stats and stats.size > max_filesize and (ev.match == "json" or ev.match == "jsonc") then
					--        -- print("buf_filesize > 100 KB, disabling treesitter")
					--        return
					--      end

					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					vim.treesitter.start()
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "TSUpdate",
				callback = function()
					require("nvim-treesitter.parsers").ghactions = {
						install_info = {
							url = "https://github.com/rmuir/tree-sitter-ghactions",
							queries = "queries",
						},
					}
				end,
			})
		end,
	},
}
