-- return {}
return {
	{
		"haya14busa/vim-asterisk",
		dependencies = {
			{
				"kevinhwang91/nvim-hlslens",
				config = function()
					require("hlslens").setup({
						auto_enable = true,
						nearest_only = true,
						nearest_float_when = "never",
						calm_down = true,
					})
				end,
			},
		},
		keys = {
			{ "?", mode = "n" },
			{ "/", mode = "n" },
			{
				"n",
				mode = "n",
				[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
			},
			{
				"N",
				mode = "n",
				[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
			},
			{
				"*",
				mode = { "n", "x" },
				[[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]],
				{ noremap = true, silent = true },
			},
			{
				"#",
				mode = { "n", "x" },
				[[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]],
				{ noremap = true, silent = true },
			},
			{
				"g*",
				mode = { "n", "x" },
				[[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]],
				{ noremap = true, silent = true },
			},
			{
				"g#",
				mode = { "n", "x" },
				[[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]],
				{ noremap = true, silent = true },
			},
		},
	},
}
