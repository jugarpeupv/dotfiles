return {
	{
		"yousefakbar/notmuch.nvim",
		dir = "~/projects/notmuch.nvim/wt-main",
		dev = true,
		enabled = true,
		opts = {
			notmuch_db_path = os.getenv("HOME") .. "/Mail",
			maildir_sync_cmd = "mbsync izertis-channel",
			sync = {
				sync_mode = "terminal",
			},
			keymaps = {
				sendmail = "S",
				compose = "C",
				reply = "R",
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
				":NmSearch tag:izertis subject:",
				{ noremap = true, silent = true },
			},
			{ mode = { "n" }, "<leader><space>", "<cmd>Notmuch<cr>", { silent = true } },

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
