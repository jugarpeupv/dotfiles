return {
	"toppair/peek.nvim",
	-- ft = { "md", "markdown", "conf" },
	build = "deno task --quiet build:fast",
	enabled = function()
		local is_headless = #vim.api.nvim_list_uis() == 0
		if is_headless then
			return false
		end
		return true
	end,
	keys = {
		{
			"<leader>po",
			function()
				require("peek").open()
			end,
			{ noremap = true, silent = true },
		},
		{
			"<leader>pc",
			function()
				require("peek").close()
			end,
			{ noremap = true, silent = true },
		},
	},
	config = function()
		require("peek").setup({
			auto_load = true, -- whether to automatically load preview when
			close_on_bdelete = true, -- close preview window on buffer delete
			syntax = true, -- enable syntax highlighting, affects performance
			theme = "dark", -- 'dark' or 'light'
			update_on_change = true,
			app = "webview", -- 'webview', 'browser', string or a table of strings
			filetype = { "markdown" }, -- list of filetypes to recognize as markdown
			throttle_at = 200000, -- start throttling when file exceeds this
			throttle_time = "auto", -- minimum amount of time in milliseconds
		})
	end,
}
