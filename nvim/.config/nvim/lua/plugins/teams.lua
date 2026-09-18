return {
	{
		"jugarpeupv/microsoft-teams.nvim",
		-- dir = "~/projects/ms-teams.nvim",
		-- dev = true,
		cmd = { "MSTeamsChats", "MSTeamsLogin", "MSTeamsFind", "MSTeamsTeams" },
		keys = {
			{ "<leader>ee", "<cmd>MSTeamsChats<cr>" },
			{ "<leader>ef", "<cmd>MSTeamsFind<cr>" },
		},
		config = function()
			local username = vim.fn.system("pass work_login | awk -F: '/^username:/{print $2}'"):gsub("%s+", "")
			require("ms-teams").setup({
				davmail = {
					enabled = true,
					username = username,
					auth_cmd = "davmail-token",
				},
				highlights = {
					unread = "MsTeamsUnreadMessages",
					search = "DiagnosticUnderlineError",
				},
        watch = {
          enabled = true,
          interval_ms = 300000,
          limit = 100,
          -- notifier = false,   -- no terminal-notifier / notify-send (nada al OS)
          notifier = "terminal-notifier", -- o "auto" (default)
          vim_notify = false, -- no segundo vim.notify dentro de nvim
          sound = false,
          mentions_only = true,
        },
				debug = false,
			})
		end,
	},
}
