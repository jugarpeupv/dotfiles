return {
  { "wellle/targets.vim",      event = { "BufReadPost", "BufNewFile" } },
  -- { "junegunn/fzf",       build = "./install --all",              event = { "VeryLazy" } },
  {
    "junegunn/fzf.vim",
    keys = {
      { mode = { "n" }, "<leader>ga", "<cmd>G add .<cr>",                    { silent = true, noremap = true } },
      { mode = { "n" }, "<Leader>gS", "<cmd>G stash<cr>",                    { silent = true, noremap = true } },
      { mode = { "n" }, "<Leader>gO", "<cmd>G stash pop<cr>",                { silent = true, noremap = true } },

      { mode = { "n" }, "<Leader>gP", "<cmd>G! push<cr>",                    { silent = true, noremap = true } },
      { mode = { "n" }, "<leader>gf", "<cmd>G! fetch --all -v<cr>",          { silent = true, noremap = true } },
      { mode = { "n" }, "<Leader>gp", "<cmd>G! pull<cr>",                    { silent = true, noremap = true } },
      { mode = { "n" }, "<Leader>gC", "<cmd>G checkout . | G clean -fd<cr>", { silent = true, noremap = true } },
      { mode = { "n" }, "<Leader>gl", "<cmd>G log -20<cr>",                  { silent = true, noremap = true } },
    },
  },
  { "tpope/vim-repeat",        keys = { "." } },
  { "nvim-lua/plenary.nvim",   lazy = true },
  { "tpope/vim-surround",      event = { "BufReadPost", "BufNewFile" } },
  { "windwp/nvim-ts-autotag",  ft = "html" },
  { "tpope/vim-fugitive",      cmd = { "G" } },
  { "tpope/vim-dispatch",      lazy = true },
  { "kkharji/sqlite.lua",      lazy = true },
  { "stsewd/fzf-checkout.vim", keys = { { "<leader>gt", "<cmd>GTags<CR>" } } },
  {
    "ckipp01/nvim-jenkinsfile-linter",
    -- event = { "BufReadPost", "BufNewFile" },
    keys = { "<leader>va" },
    config = function()
      vim.keymap.set("n", "<leader>va", require("jenkinsfile_linter").validate, {})
    end,
  },
  -- { "neoclide/jsonc.vim", ft = { "json" } },
}
