return {
  {
    "jugarpeupv/pass.nvim",
    dev = true,
    dir = "~/projects/pass.nvim/wt-main",
    dependencies = { "folke/snacks.nvim" }, -- optional
    keys = {
      { mode = { "n" }, "<leader>pa", "<cmd>Pass<cr>" },
    },
    cmd = "Pass",
  },
}
