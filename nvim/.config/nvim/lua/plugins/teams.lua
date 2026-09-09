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
      local username = vim.fn.system("pass izertis_login | awk -F: '/^username:/{print $2}'"):gsub("%s+", "")
			require("ms-teams").setup({
				davmail = {
					enabled = true,
          username = username,
					auth_cmd = "davmail-token",
				},
				watch = { enabled = true, interval_ms = 120000 },
				debug = false,
			})
		end,
	},
}
