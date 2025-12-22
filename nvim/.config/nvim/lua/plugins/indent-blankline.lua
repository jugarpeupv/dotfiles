-- return {}
return {
	{
		"saghen/blink.indent",
    enabled = false,
    -- event = { "VeryLazy" },
    event = { "LspAttach" },
    -- event = { "BufReadPost", "BufNewFile" },
		-- keys = {
		-- 	{ "<C-d>" },
		-- 	{ "<C-u>" },
		-- },
		--- @module 'blink.indent'
		--- @type blink.indent.Config
    opts = {
      blocked = {
        -- default: 'terminal', 'quickfix', 'nofile', 'prompt'
        buftypes = { include_defaults = true },
        -- default: 'lspinfo', 'packer', 'checkhealth', 'help', 'man', 'gitcommit', 'dashboard', ''
        filetypes = { include_defaults = true },
      },
      mappings = {
        -- which lines around the scope are included for 'ai': 'top', 'bottom', 'both', or 'none'
        border = 'both',
        -- set to '' to disable
        -- textobjects (e.g. `y2ii` to yank current and outer scope)
        object_scope = 'ii',
        object_scope_with_border = 'ai',
        -- motions
        goto_top = '[i',
        goto_bottom = ']i',
      },
      static = {
        enabled = true,
        char = '▏',
        whitespace_char = nil, -- inherits from `vim.opt.listchars:get().space` when `nil` (see `:h listchars`)
        priority = 1,
        -- specify multiple highlights here for rainbow-style indent guides
        -- highlights = { 'BlinkIndentRed', 'BlinkIndentOrange', 'BlinkIndentYellow', 'BlinkIndentGreen', 'BlinkIndentViolet', 'BlinkIndentCyan' },
        highlights = { 'IndentBlanklineChar' },
        -- highlights = { 'BlinkIndentRed' },
      },
      scope = {
        enabled = true,
        char = '▏',
        priority = 1000,
        -- set this to a single highlight, such as 'BlinkIndent' to disable rainbow-style indent guides
        -- highlights = { 'BlinkIndentScope' },
        -- optionally add: 'BlinkIndentRed', 'BlinkIndentCyan', 'BlinkIndentYellow', 'BlinkIndentGreen'
        -- highlights = { 'BlinkIndentOrange', 'BlinkIndentViolet', 'BlinkIndentBlue' },
        highlights = { 'IndentBlanklineContextChar' },
        -- enable to show underlines on the line above the current scope
        underline = {
          enabled = true,
          -- optionally add: 'BlinkIndentRedUnderline', 'BlinkIndentCyanUnderline', 'BlinkIndentYellowUnderline', 'BlinkIndentGreenUnderline'
          -- highlights = { 'BlinkIndentOrangeUnderline', 'BlinkIndentVioletUnderline', 'BlinkIndentBlueUnderline' },
          highlights = { 'IndentBlanklineContextCharUnderline' },
        },
      },
    }
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		enabled = false,
		event = "LspAttach",
		-- keys = {
		-- 	{ "<C-d>" },
		-- 	{ "<C-u>" },
		-- },
		config = function()
			-- require("indent_blankline").setup {
			--   -- char = '┊',
			--   space_char_blankline = " ",
			--   show_trailing_blankline_indent = false,
			--   -- use_treesitter = true,
			--   -- use_treesitter_scope = true,
			--   show_end_of_line = true,
			--   show_current_context = true,
			--   -- show_current_context_start = true,
			-- }

			require("ibl").setup({
				scope = {
					enabled = true,
					show_start = false,
					show_end = true,
					injected_languages = true,
					-- highlight = { "Function", "Label" },
					-- char = "|",
					-- char = "┋",
					char = "▏",
					-- char = "│",
					-- char = "▕",
					priority = 500,
				},
				indent = {
					char = "▏",
					-- tab_char = ">"
					-- tab_char = "",
					repeat_linebreak = true,
					-- tab_char = "┋",
					-- tab_char = ">",
					-- tab_char = { "a", "b", "c" },
					-- char = "┋"
				},
				whitespace = { remove_blankline_trail = false },
				exclude = {
					filetypes = { "dashboard" },
					buftypes = { "terminal" },
				},
			})

			-- vim.opt.list = true
			-- vim.opt.listchars = "eol:↵,trail:·,tab:  "
			-- vim.opt.listchars = "eol:↵,trail:·,tab:  "
			-- vim.opt.listchars = "trail:·,tab: >>"
			-- vim.cmd[[set listchars=trail:·,precedes:«,extends:»,tab:▸\]]
			-- vim.opt.listchars = "trail:·,tab: "
			-- vim.opt.listchars = "trail:·,tab: ,space:⋅ "
			-- vim.opt.listchars = "space:⋅,tab: "

			-- require("indent_blankline").setup {
			--   -- char = '┊',
			--   space_char_blankline = " ",
			--   show_trailing_blankline_indent = false,
			--   -- use_treesitter = true,
			--   -- use_treesitter_scope = true,
			--   show_end_of_line = true,
			--   show_current_context = true,
			--   -- show_current_context_start = true,
			-- }
		end,
	},
}
