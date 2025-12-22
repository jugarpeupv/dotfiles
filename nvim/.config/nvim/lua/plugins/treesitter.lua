-- return {}
return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = true,
    event = "VeryLazy",
		branch = "main",
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")

			-- State tracking for async parser loading
			local parsers_loaded = {}
			local parsers_pending = {}
			local parsers_failed = {}

			local ns = vim.api.nvim_create_namespace("treesitter.async")

			-- Helper to start highlighting and indentation
			local function start(buf, lang)
				local ok = pcall(vim.treesitter.start, buf, lang)
				if ok then
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo[0][0].foldmethod = "expr"
          -- vim.schedule(function ()
          --   vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          --   vim.wo[0][0].foldmethod = "expr"
          -- end)
				end
				return ok
			end

			-- Install core parsers after lazy.nvim finishes loading all plugins
			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyDone",
				once = true,
				callback = function()
					ts.install({
						"bash",
						"comment",
						"css",
						"diff",
						"fish",
						"git_config",
						"git_rebase",
						"gitcommit",
						"gitignore",
						"html",
						"javascript",
						"json",
						"latex",
						"lua",
						"luadoc",
						"make",
						"markdown",
						"markdown_inline",
						"norg",
						"python",
						"query",
						"regex",
						"scss",
						"svelte",
						"toml",
						"tsx",
						"typescript",
						"typst",
						"vim",
						"vimdoc",
						"vue",
						"xml",
					}, {
						max_jobs = 8,
					})
				end,
			})

			-- Decoration provider for async parser loading
			vim.api.nvim_set_decoration_provider(ns, {
				on_start = vim.schedule_wrap(function()
					if #parsers_pending == 0 then
						return false
					end
					for _, data in ipairs(parsers_pending) do
						if vim.api.nvim_buf_is_valid(data.buf) then
							if start(data.buf, data.lang) then
								parsers_loaded[data.lang] = true
							else
								parsers_failed[data.lang] = true
							end
						end
					end
					parsers_pending = {}
				end),
			})

			vim.treesitter.language.register("markdown", "octo")
			vim.treesitter.language.register("yaml", "yaml.github") -- the someft filetype will use the python parser and queries.

			vim.filetype.add({
				pattern = {
					[".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
				},
			})

			require("jg.custom.incremental_selection").setup({
				incr_key = "<tab>", -- increment selection key
				decr_key = "<s-tab>", -- decrement selection key
			})

			vim.filetype.add({
				extension = {
					["http"] = "http",
				},
			})

			vim.api.nvim_create_autocmd("User", {
				group = vim.api.nvim_create_augroup("TSUpdateTreesitter", { clear = true }),
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
				end,
			})

			local group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })

			local ignore_filetypes = {
				"checkhealth",
				"lazy",
				"mason",
				"snacks_dashboard",
				"snacks_notif",
				"snacks_win",
			}

			-- Auto-install parsers and enable highlighting on FileType
			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				desc = "Enable treesitter highlighting and indentation (non-blocking)",
				callback = function(event)
					if vim.tbl_contains(ignore_filetypes, event.match) then
						return
					end

					local lang = vim.treesitter.language.get_lang(event.match) or event.match
					local buf = event.buf

					if parsers_failed[lang] then
						return
					end

					if parsers_loaded[lang] then
						-- Parser already loaded, start immediately (fast path)
						start(buf, lang)
					else
						-- Queue for async loading
						table.insert(parsers_pending, { buf = buf, lang = lang })
					end

					-- Auto-install missing parsers (async, no-op if already installed)
					ts.install({ lang })
				end,
			})
		end,
	},
	-- {
	-- 	"nvim-treesitter/nvim-treesitter",
	-- 	-- branch = "master",
	-- 	enabled = true,
	-- 	lazy = true,
	-- 	branch = "main",
	-- 	build = ":TSUpdate",
	-- 	event = { "VeryLazy" },
	-- 	-- lazy = true,
	-- 	-- lazy = true,
	-- 	-- branch = 'main',
	-- 	-- build = ':TSUpdate',
	-- 	-- cmd = { "TSInstall", "TSBufEnable", "TSModuleInfo" },
	-- 	-- event = { "BufReadPost", "BufNewFile" },
	-- 	-- lazy = false,
	-- 	-- build = function()
	-- 	-- 	require("nvim-treesitter.install").update({ with_sync = true })
	-- 	-- end,
	-- 	config = function()
	-- 		-- import nvim-treesitter plugin safely
	-- 		-- local status, treesitter = pcall(require, "nvim-treesitter.configs")
	-- 		local status, treesitter = pcall(require, "nvim-treesitter")
	-- 		if not status then
	-- 			return
	-- 		end
	--
	-- 		-- configure treesitter
	-- 		treesitter.setup()
	--
	-- 		--
	-- 		-- parser_configs.lua_patterns = {
	-- 		--   install_info = {
	-- 		--     url = "https://github.com/OXY2DEV/tree-sitter-lua_patterns",
	-- 		--     files = { "src/parser.c" },
	-- 		--     branch = "main",
	-- 		--   },
	-- 		-- }
	--
	-- 		-- local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
	-- 		---@diagnostic disable-next-line: inject-field
	-- 		-- parser_configs.ghactions = {
	-- 		-- 	install_info = {
	-- 		-- 		url = "https://github.com/rmuir/tree-sitter-ghactions",
	-- 		--       files = { "src/parser.c" },
	-- 		-- 		-- queries = "queries",
	-- 		-- 		branch = "main",
	-- 		-- 		--      generate_requires_npm = true, -- if stand-alone parser without npm dependencies
	-- 		-- 		--      requires_generate_from_grammar = true
	-- 		-- 	},
	-- 		-- }
	-- 		-- vim.treesitter.language.register('ghactions', 'yaml')  -- the someft filetype will use the python parser and queries.
	-- 		-- custom parsers
	--
	-- 		vim.treesitter.language.register("markdown", "octo")
	-- 		vim.treesitter.language.register("yaml", "yaml.github") -- the someft filetype will use the python parser and queries.
	--
	-- 		vim.api.nvim_create_autocmd("FileType", {
	-- 			group = vim.api.nvim_create_augroup("treesitter-enabled-filetype", { clear = true }),
	-- 			pattern = {
	-- 				"kitty",
	-- 				"http",
	-- 				"rest",
	-- 				"java",
	-- 				"go",
	-- 				"copilot-chat",
	-- 				"yaml",
	-- 				"yml",
	-- 				"yaml.github",
	-- 				"jsonc",
	-- 				"sh",
	-- 				"dosini",
	-- 				-- "editorconfig",
	-- 				"typescript",
	-- 				-- "kulala_http",
	-- 				"javascript",
	-- 				"markdown",
	-- 				"gitcommit",
	-- 				"hurl",
	-- 				"jproperties",
	-- 				"properties",
	-- 				"codecompanion",
	-- 				"bash",
	-- 				"html",
	-- 				"htmlangular",
	-- 				"scss",
	-- 				"css",
	-- 				"groovy",
	-- 				"Avante",
	-- 				"dockerfile",
	-- 				"regex",
	-- 				"lua",
	-- 			},
	-- 			callback = function()
	-- 				-- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	-- 				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	-- 				vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
	-- 				vim.wo[0][0].foldmethod = "expr"
	-- 				vim.treesitter.start()
	-- 			end,
	-- 		})
	--
	-- 		vim.filetype.add({
	-- 			pattern = {
	-- 				[".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
	-- 			},
	-- 		})
	--
	-- 		require("jg.custom.incremental_selection").setup({
	-- 			-- incr_key = "<cr>", -- increment selection key
	-- 			-- decr_key = "<bs>", -- decrement selection key
	-- 			incr_key = "<tab>", -- increment selection key
	-- 			decr_key = "<s-tab>", -- decrement selection key
	-- 		})
	--
	-- 		vim.filetype.add({
	-- 			extension = {
	-- 				["http"] = "http",
	-- 			},
	-- 		})
	--
	-- 		vim.api.nvim_create_autocmd("User", {
	-- 			pattern = "TSUpdate",
	-- 			callback = function()
	-- 				require("nvim-treesitter.parsers").ghactions = {
	-- 					install_info = {
	-- 						url = "https://github.com/rmuir/tree-sitter-ghactions",
	-- 						queries = "queries",
	-- 					},
	-- 				}
	--
	-- 				require("nvim-treesitter.parsers").lua_patterns = {
	-- 					install_info = {
	-- 						url = "https://github.com/OXY2DEV/tree-sitter-lua_patterns",
	-- 					},
	-- 				}
	--
	-- 				-- require("nvim-treesitter.parsers").scss = {
	-- 				--   install_info = {
	-- 				--     url = "https://github.com/tree-sitter-grammars/tree-sitter-scss",
	-- 				--     queries = "queries",
	-- 				--     branch = "master"
	-- 				--   },
	-- 				-- }
	-- 			end,
	-- 		})
	-- 	end,
	-- },
	{ "wellle/targets.vim", lazy = true, event = { "VeryLazy" } },
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
    event = { "LspAttach" },
		keys = {
			{
				mode = { "x", "o" },
				"af",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
				end,
			},
			{
				mode = { "x", "o" },
				"if",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
				end,
			},
			{
				mode = { "x", "o" },
				"ih",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@assignment.lhs", "textobjects")
				end,
			},
			{
				mode = { "x", "o" },
				"il",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@assignment.rhs", "textobjects")
				end,
			},
			{
				mode = { "x", "o" },
				"ac",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
				end,
			},
			{
				mode = { "x", "o" },
				"ic",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
				end,
			},
			-- Repeat movement with ; and ,
			-- ensure ; goes forward and , goes backward regardless of the last direction
			{
				mode = { "n", "x", "o" },
				";",
				function()
					require("nvim-treesitter-textobjects.repeatable_move").repeat_last_move_next()
				end,
				{ expr = true },
			},
			{
				mode = { "n", "x", "o" },
				",",
				function()
					require("nvim-treesitter-textobjects.repeatable_move").repeat_last_move_previous()
				end,
				{ expr = true },
			},
		},
		config = function()
			-- configuration
			require("nvim-treesitter-textobjects").setup({
				select = {
					enable = true,
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						["@class.outer"] = "<c-v>", -- blockwise
					},
					include_surrounding_whitespace = false,
				},
			})
		end,
	},
	{
		"chrisgrieser/nvim-various-textobjs",
    event = { "InsertEnter", "LspAttach" },
		keys = {
			{ mode = { "o", "x" }, "as", "<cmd>lua require('various-textobjs').subword('outer')<CR>" },
			{ mode = { "o", "x" }, "is", "<cmd>lua require('various-textobjs').subword('inner')<CR>" },
		},
		opts = {
			keymaps = {
				useDefaults = true,
				disabledDefaults = { "L", "in", "an" },
			},
		},
	},
	{
		-- "jugarpeupv/nvim-treesitter-context",
		"nvim-treesitter/nvim-treesitter-context",
		enabled = true,
		lazy = true,
		ft = { "json", "jsonc", "yaml", "yml", "yaml.github", "javascript", "typescript", "lua" },
		config = function()
			require("treesitter-context").setup({
				on_attach = function(buf)
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
				-- separator = nil,
        separator = "–"
			})
		end,
	},
	-- { "keith/xcconfig.vim", ft = { "xcconfig" } },
	-- { "cfdrake/vim-pbxproj", ft = { "pbxproj" } },
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
}
