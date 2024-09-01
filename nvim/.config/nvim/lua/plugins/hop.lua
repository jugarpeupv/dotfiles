return {
  {
    "phaazon/hop.nvim",
    -- event = "VeryLazy",
    cmd = { "HopWord" },
    branch = "v1",
    -- keys = { { "<leader>w", mode = "n" } },
    config = function()
      require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
    end,
  },
}
