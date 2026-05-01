return {
	{
		-- "yousefakbar/notmuch.nvim",
    "jugarpeupv/notmuch.nvim",
		-- dir = "~/projects/notmuch.nvim/wt-main",
		-- dev = true,
		enabled = true,
		opts = {
			notmuch_db_path = os.getenv("HOME") .. "/Mail",
			maildir_sync_cmd = "mbsync izertis-channel",
      render_html_body = false,
			sync = {
				sync_mode = "buffer",
			},
			keymaps = {
				sendmail = "S",
				compose = "C",
				reply = "R",
        attachment_window = "M"
			},
		},
		keys = {
			-- { mode = { "n" }, "<leader>nn", "<cmd>Notmuch<cr>", { silent = true } },
			{
				mode = { "n" },
				"<leader>nP",
				":NmSearch tag:personal and tag:unread",
				{ noremap = true, silent = true },
			},
			{
				mode = { "n" },
				"<leader>ns",
				":NmSearch tag:izertis and subject:",
				{ noremap = true, silent = true },
			},
			{ mode = { "n" }, "<leader>no", "<cmd>Notmuch<cr>", { silent = true } },

			{
				mode = { "n" },
				"<leader>nn",
				"<cmd>NmSearch tag:inbox and tag:unread and tag:izertis and not tag:github<cr>",
				{ silent = true },
			},

			{
				mode = { "n" },
				"<leader>na",
				function()
					require("jg.custom.telescope").notmuch_picker()
				end,
				{ silent = true },
			},
		},
	},
}
