return {
  "Wansmer/treesj",
  keys = { "sj" },
  dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
  config = function()
    require("treesj").setup({ use_default_keymaps = false, max_join_length = 240 })
    vim.keymap.set("n", "<leader>so", function()
      require("treesj").toggle({ split = { recursive = true } })
    end)
  end,
}
