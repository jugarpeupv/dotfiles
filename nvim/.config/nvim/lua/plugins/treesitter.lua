-- return {}
return {
	{
		"nvim-treesitter/nvim-treesitter",
		-- branch = "master",
		lazy = true,
		branch = "main",
		build = ":TSUpdate",
		-- lazy = true,
		-- lazy = true,
		-- branch = 'main',
		-- build = ':TSUpdate',
		-- cmd = { "TSInstall", "TSBufEnable", "TSModuleInfo" },
		-- event = { "BufReadPost", "BufNewFile" },
		-- lazy = false,
		dependencies = {
			{ "wellle/targets.vim" },
      {"andymass/vim-matchup"},
			{ "cfdrake/vim-pbxproj" },
			{ "keith/xcconfig.vim" },
			{
				"axelvc/template-string.nvim",
				-- "chrisgrieser/nvim-puppeteer",
				enabled = false,
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
						remove_template_string = false, -- remove backticks when there are no template strings
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
				-- "jugarpeupv/nvim-treesitter-context",
				"nvim-treesitter/nvim-treesitter-context",
				enabled = true,
				lazy = true,
				-- dir='~/private/nvim-treesitter-context',
				-- dev = true,
				-- event = { "BufReadPost", "BufNewFile" },
				-- cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
				-- affects = "nvim-treesitter",
				-- event = "VeryLazy",
				config = function()
					require("treesitter-context").setup({
						on_attach = function(buf)
							-- get filetype based of buf
							local filetype = vim.fn.getbufvar(buf, "&ft")
							if filetype == "markdown" then
								return false
							end
							return true
						end, -- (fun(buf: integer): boolean) return false to disable attaching
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
			treesitter.setup()

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
					"kitty",
					"http",
					"rest",
					"java",
					"go",
					"copilot-chat",
					"yaml",
					"yaml.github",
					"jsonc",
					"sh",
					"dosini",
					"editorconfig",
					"typescript",
					-- "kulala_http",
					"javascript",
					"markdown",
					"gitcommit",
					"hurl",
					"jproperties",
					"properties",
					-- "codecompanion",
					"bash",
					"html",
					"htmlangular",
					"scss",
					"css",
					"groovy",
					"Avante",
					"dockerfile",
					"regex",
					"lua",
				},
				callback = function()
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					vim.treesitter.start()
				end,
			})

			vim.treesitter.language.register("markdown", "octo")

			require("jg.custom.incremental_selection").setup({
				incr_key = "<cr>", -- increment selection key
				decr_key = "<bs>", -- decrement selection key
			})

			vim.filetype.add({
				extension = {
					["http"] = "http",
				},
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

					require("nvim-treesitter.parsers").lua_patterns = {
						install_info = {
							url = "https://github.com/OXY2DEV/tree-sitter-lua_patterns",
						},
					}

					-- require("nvim-treesitter.parsers").scss = {
					--   install_info = {
					--     url = "https://github.com/tree-sitter-grammars/tree-sitter-scss",
					--     queries = "queries",
					--     branch = "master"
					--   },
					-- }
				end,
			})
		end,
	},
}
