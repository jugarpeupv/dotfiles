return {
	{
		"cohama/lexima.vim",
		enabled = true,
		event = { "InsertEnter" },
		config = function()
			vim.g.lexima_enable_space_rules = 0
			vim.cmd([[call lexima#add_rule({'at': '\%#\S', 'char': '(', 'input': '('})]])
			vim.cmd([[call lexima#add_rule({'at': '\%#\S', 'char': '[', 'input': '['})]])
			vim.cmd([[call lexima#add_rule({'at': '\%#\S', 'char': '{', 'input': '{'})]])

			vim.cmd([[call lexima#add_rule({'at': '\S\%#', 'char': '"', 'input': '"'})]])
			vim.cmd([[call lexima#add_rule({'at': '\%#\S', 'char': '"', 'input': '"'})]])
      vim.cmd([[
        call lexima#add_rule({
        \ 'char': '"',
        \ 'at': '"\%#"',
        \ 'input': '',
        \ 'leave': '"',
        \ 'priority': 10,
        \ })
        ]])

      vim.cmd([[call lexima#add_rule({'at': '\S\%#', 'char': "'", 'input': "'"})]])
			vim.cmd([[call lexima#add_rule({'at': '\%#\S', 'char': "'", 'input': "'"})]])
      vim.cmd([[
        call lexima#add_rule({
        \ 'char': "'",
        \ 'at': "\'\\%#\'",
        \ 'input': '',
        \ 'leave': "'",
        \ 'priority': 14,
        \ })
        ]])

      vim.cmd([[call lexima#add_rule({'at': '\S\%#', 'char': "`", 'input': "`"})]])
			vim.cmd([[call lexima#add_rule({'at': '\%#\S', 'char': "`", 'input': "`"})]])
			vim.cmd([[call lexima#add_rule({'char': '`', 'at': '``\%#', 'input_after': '```'})]])
			vim.cmd([[
        call lexima#add_rule({
        \ 'char': '`',
        \ 'at': '`\%#`',
        \ 'input': '',
        \ 'leave': '`',
        \ 'priority': 12,
        \ })
      ]])

		end,
	},
	{
		"saghen/blink.pairs",
		enabled = false,
		version = "*",
		event = { "InsertEnter", "LspAttach" },
		dependencies = "saghen/blink.download",
		opts = {
			mappings = {
				enabled = true,
				cmdline = false,
				disabled_filetypes = {},
				pairs = {
					["'"] = {},
					['"'] = {},
					["{"] = {
						"}",
						open = function(ctx)
							if ctx:text_after_cursor(1) == "" or ctx:text_after_cursor(1) == " " then
								return true
							end
							if ctx:text_after_cursor(1) == "}" then
								return true
							end
							return false
						end,
						close = function(ctx)
							if ctx:text_before_cursor(1) == "{" and ctx:text_after_cursor(1) == "}" then
								return true
							end
							return false
						end,
					},
					["["] = {
						"]",
						open = function(ctx)
							if
								ctx:text_after_cursor(1) == ""
								or ctx:text_after_cursor(1) == " "
								or ctx:text_after_cursor(1) == "]"
							then
								return true
							end
							return false
						end,
						close = function(ctx)
							if
								(ctx:text_before_cursor(1) == "[" or ctx:text_before_cursor(1) == "]")
								and ctx:text_after_cursor(1) == "]"
							then
								return true
							end
							return false
						end,
					},
					["("] = {
						")",
						open = function(ctx)
							if
								ctx:text_after_cursor(1) == ""
								or ctx:text_after_cursor(1) == " "
								or ctx:text_after_cursor(1) == ")"
							then
								return true
							end
							return false
						end,
						close = function(ctx)
							if
								(ctx:text_before_cursor(1) == "(" or ctx:text_before_cursor(1) == ")")
								and ctx:text_after_cursor(1) == ")"
							then
								return true
							end
							return false
						end,
					},
				},
			},
			highlights = {
				enabled = false,
				cmdline = true,
				groups = {
					"TSRainbowBlue",
					"TSRainbowOrange",
					"TSRainbowGreen",
				},
				unmatched_group = "BlinkPairsUnmatched",
				matchparen = {
					enabled = false,
					-- known issue where typing won't update matchparen highlight, disabled by default
					cmdline = false,
					include_surrounding = true,
					group = "BlinkPairsMatchParen",
					priority = 250,
				},
			},
			debug = false,
		},
	},
	{
		"abecodes/tabout.nvim",
		lazy = true,
		enabled = false,
		config = function()
			require("tabout").setup({
				tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
				backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
				act_as_tab = true, -- shift content if tab out is not possible
				act_as_shift_tab = true, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
				default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
				default_shift_tab = "<C-d>", -- reverse shift default action,
				enable_backwards = true, -- well ...
				completion = false, -- if the tabkey is used in a completion pum
				tabouts = {
					{ open = "'", close = "'" },
					{ open = '"', close = '"' },
					{ open = "`", close = "`" },
					{ open = "(", close = ")" },
					{ open = "[", close = "]" },
					{ open = "{", close = "}" },
				},
				ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
				exclude = {}, -- tabout will ignore these filetypes
			})
		end,
		dependencies = { -- These are optional
			"nvim-treesitter/nvim-treesitter",
			"L3MON4D3/LuaSnip",
		},
		opt = true, -- Set this to true if the plugin is optional
		event = "InsertCharPre", -- Set the event to 'InsertCharPre' for better compatibility
		priority = 1000,
	},
}
