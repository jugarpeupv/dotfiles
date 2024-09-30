return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  keys = {
    { "<leader>rm", "<cmd>RenderMarkdown toggle<CR>" },
  },
  opts = {
    enabled = false,
  },
  dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
}
