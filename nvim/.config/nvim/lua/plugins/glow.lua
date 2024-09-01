return {
  {
    "ellisonleao/glow.nvim",
    config = true,
    cmd = "Glow",
    keys = {
      {
        "<leader>gw",
        mode = { "n" },
        function()
          vim.cmd("Glow")
        end,
      },
    },
    opts = { border = "single", width = 100, height = 100, width_ratio = 1, height_ratio = 1 },
  },
}
