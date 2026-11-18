return {
	{
		"flokkq/calc.nvim",
		cmd = "CalcOpen",
		enabled = true,
		version = "v0.3.0",
    keys = {
      { "<leader>ca", "<cmd>CalcOpen<cr>", mode = "n", desc = "CalcOpen" },
    },
	},
  {
    "necrom4/calcium.nvim",
    cmd = { "Calcium" },
    enabled = true,
    opts = {},
    keys = {
      -- example keymap
      {
        "<leader>cA",
        ":Calcium<CR>",
        desc = "Calculate",
        mode = { "n", "v" },
        silent = true,
      },
    },
  },
	{
		"jbyuki/quickmath.nvim",
		cmd = "Quickmath",
    enabled = false,
		keys = {
			{ "<leader>ca", "<cmd>enew<cr><cmd>Quickmath<cr>", mode = "n", desc = "Quickmath" },
		},
	},
}
