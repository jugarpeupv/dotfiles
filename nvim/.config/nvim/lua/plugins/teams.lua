return {
	{
		dir = "~/projects/ms-teams.nvim",
		dev = true,
		cmd = { "MSTeamsChats", "MSTeamsLogin", "MSTeamsFind" , "MSTeamsTeams"},
		keys = {
			{ "<leader>ee", "<cmd>MSTeamsChats<cr>" },
			{ "<leader>ef", "<cmd>MSTeamsFind<cr>" },
		},
		config = function()
			require("ms-teams").setup({
				watch = { enabled = true, interval_ms = 120000 },
        debug = false,
			})
		end,
	},
}
