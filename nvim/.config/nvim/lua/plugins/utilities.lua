return {
  -- { "VidocqH/data-viewer.nvim" },
  -- { "Djancyp/regex.nvim" },
  -- {"https://github.com/gabrielpoca/replacer.nvim"},
  -- { "Wansmer/sibling-swap.nvim" },
  -- { "nvim-spider" }
  -- { "airblade/vim-matchquote" },
  -- { "ton/vim-bufsurf" },
  {
    "kwkarlwang/bufjump.nvim",
    -- event = "VeryLazy",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("bufjump").setup({
        -- forward_key = "<C-n>",
        -- backward_key = "<C-p>",
        -- on_success = nil
      })
      local opts = { silent=true, noremap=true }
      vim.api.nvim_set_keymap("n", "<C-b>", ":lua require('bufjump').backward()<cr>", opts)
      vim.api.nvim_set_keymap("n", "<C-f>", ":lua require('bufjump').forward()<cr>", opts)
      -- vim.api.nvim_set_keymap("n", "<M-i>", ":lua require('bufjump').forward()<cr>", opts)
      -- vim.api.nvim_set_keymap("n", "<M-o>", ":lua require('bufjump').backward_same_buf()<cr>", opts)
      -- vim.api.nvim_set_keymap("n", "<M-i>", ":lua require('bufjump').forward_same_buf()<cr>", opts)
    end,
  },
  -- { https://github.com/axieax/urlview.nvim }
  { "dstein64/vim-startuptime", cmd = { "StartupTime" } },
  -- { "dstein64/vim-startuptime", event = "VeryLazy" },
  {
    "b0o/schemastore.nvim",
    -- event = "VeryLazy",
    lazy = true,
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
    -- keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
    config = function()
      vim.g.tmux_navigator_disable_when_zoomed = 1
      vim.g.tmux_navigator_preserve_zoom = 1
    end,
  },

  { "wellle/targets.vim",       event = { "BufReadPost", "BufNewFile" } },
  { "junegunn/fzf",             build = "./install --all", cmd = "VeryLazy" },
  { "stsewd/fzf-checkout.vim", keys = { { "<leader>gt", "<cmd>GTags<CR>" } } },
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
  { "tpope/vim-dispatch",      lazy = true },
  { "kkharji/sqlite.lua",      lazy = true },
  {
    "ckipp01/nvim-jenkinsfile-linter",
    -- event = { "BufReadPost", "BufNewFile" },
    keys = { "<leader>va" },
    config = function()
      vim.keymap.set("n", "<leader>va", require("jenkinsfile_linter").validate, {})
    end,
  },
}
