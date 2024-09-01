return {
  { "wellle/targets.vim",        event = { "BufReadPost", "BufNewFile" } },
  { "junegunn/fzf",              build = "./install --all",              event = { "VeryLazy" } },
  { "junegunn/fzf.vim",          event = { "VeryLazy" } },
  { "tpope/vim-repeat",          keys = { "." } },
  { "nvim-lua/plenary.nvim",     event = "VeryLazy" },
  { "tpope/vim-surround",        event = { "BufReadPost", "BufNewFile" } },
  { "windwp/nvim-ts-autotag",    after = "nvim-treesitter",              ft = "html" },
  { "tpope/vim-fugitive",        event = { "VeryLazy" } },
  { "tpope/vim-dispatch",        event = { "BufReadPost", "BufNewFile" } },
  { "kkharji/sqlite.lua",        event = { "BufReadPost", "BufNewFile" } },
  { "stsewd/fzf-checkout.vim",   event = { "VeryLazy" } },
  {
    "ckipp01/nvim-jenkinsfile-linter",
    event = { "BufReadPost", "BufNewFile" },
    keys = { "<leader>va" },
    config = function()
      vim.keymap.set("n", "<leader>va", require("jenkinsfile_linter").validate, {})
    end,
  },
  { "neoclide/jsonc.vim", ft = { "json" } },
}
