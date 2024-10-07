return {
  -- { "Djancyp/regex.nvim" },
  -- {"https://github.com/gabrielpoca/replacer.nvim"},
  -- { "Wansmer/sibling-swap.nvim" },
  -- { "nvim-spider" }
  -- { "airblade/vim-matchquote" },
  -- { "ton/vim-bufsurf" },
  -- {
  --   "kwkarlwang/bufjump.nvim",
  --   event = "VeryLazy"
  --   config = function()
  --     require("bufjump").setup({
  --       forward_key = "<C-n>",
  --       backward_key = "<C-p>",
  --       on_success = nil
  --     })
  --   end,
  -- },
  { "dstein64/vim-startuptime", event = "BufReadPost" },
  {
    "b0o/schemastore.nvim",
    event = "VeryLazy",
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    -- event = "VeryLazy",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("various-textobjs").setup({ useDefaultKeymaps = true })
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    config = function()
      vim.g.tmux_navigator_disable_when_zoomed = 1
      vim.g.tmux_navigator_preserve_zoom = 1
    end,
  },
}
