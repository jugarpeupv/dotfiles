-- lazy.nvim
return {
	{
		"jugarpeupv/whatsapp.nvim",
		-- dir = vim.fn.expand("~/projects/whatsapp.nvim/wt-main"),
		build = "make build",
		enabled = true,
		cmd = { "Whatsapp" },
		keys = {
			{ "<leader>wa", "<cmd>Whatsapp<cr>" },
		},
		config = function()
			require("whatsapp").setup({
				encryption = "gpg",
				lock_on_focus_lost = true,
        lock_on_resume = true,     -- lock after a system suspend/wake
			})
		end,
	},
}
