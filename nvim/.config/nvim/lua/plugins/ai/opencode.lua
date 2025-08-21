return {
	{
		"NickvanDyke/opencode.nvim",
		dependencies = { "folke/snacks.nvim" },
		---@type opencode.Config
		opts = {
			-- Your configuration, if any
			terminal = {
				win = {
					-- "right" seems like a better default than snacks.terminal's "float" default...
					position = "right",
					-- Stay in the editor after opening the terminal
					enter = true,
				},
				env = {
					-- Other themes have visual bugs in embedded terminals: https://github.com/sst/opencode/issues/445
					OPENCODE_THEME = "system",
				},
			},
		},
    -- stylua: ignore
    keys = {
      { mode = { "n", "t", "v" }, '<M-z>', function() require('opencode').toggle() end, desc = 'Toggle embedded opencode', },
      -- { '<leader>oa', function() require('opencode').ask() end, desc = 'Ask opencode', mode = 'n', },
      -- { '<leader>oa', function() require('opencode').ask('@selection: ') end, desc = 'Ask opencode about selection', mode = 'v', },
      -- { '<leader>op', function() require('opencode').select_prompt() end, desc = 'Select prompt', mode = { 'n', 'v', }, },
      -- { '<leader>on', function() require('opencode').command('session_new') end, desc = 'New session', },
      -- { '<leader>oy', function() require('opencode').command('messages_copy') end, desc = 'Copy last message', },
      { '<S-C-u>',    function() require('opencode').command('messages_half_page_up') end, desc = 'Scroll messages up', },
      { '<S-C-d>',    function() require('opencode').command('messages_half_page_down') end, desc = 'Scroll messages down', },
    },
	},
}
