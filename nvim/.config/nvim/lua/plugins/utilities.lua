return {
  -- https://github.com/johmsalas/text-case.nvim
  -- { "VidocqH/data-viewer.nvim" },
  -- { "Djancyp/regex.nvim" },
  -- {"https://github.com/gabrielpoca/replacer.nvim"},
  -- { "Wansmer/sibling-swap.nvim" },
  -- { "nvim-spider" }
  -- { "airblade/vim-matchquote" },
  -- { "ton/vim-bufsurf" },
  {
    "gbprod/yanky.nvim",
    dependencies = {
      { "kkharji/sqlite.lua" },
    },
    opts = {

      ring = { storage = "sqlite" },
      highlight = {
        on_put = false,
        on_yank = false,
        timer = 500,
      },
      textobj = {
        enabled = true,
      },
    },
    keys = {
      { "<leader>cl", function() require("telescope").extensions.yank_history.yank_history({ }) end, mode = { "n", "x" }, desc = "Open Yank History" },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
      -- { "p", "<Plug>(YankyPutAfterFilter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
      -- { "P", "<Plug>(YankyPutBeforeFilter)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
      { "<M-e>", "<Plug>(YankyPreviousEntry)", desc = "Select previous entry through yank history" },
      { "<M-r>", "<Plug>(YankyNextEntry)", desc = "Select next entry through yank history" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
      { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
      { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },
      { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
      { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
    }
  },

  {
    "lambdalisue/vim-suda",
    cmd = { "SudaWrite", "SudaRead" },
  },
  {
    "chrisgrieser/nvim-spider",
    keys = {
      {
        "w",
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { "n", "o", "x" },
      },

      {
        "b",
        "<cmd>lua require('spider').motion('b')<CR>",
        mode = { "n", "o", "x" },
      },

      {
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { "n", "o", "x" },
      },
    },
    opts = {
      skipInsignificantPunctuation = true,
      consistentOperatorPending = true, -- see "Consistent Operator-pending Mode" in the README
      subwordMovement = true,
      customPatterns = {},           -- check "Custom Movement Patterns" in the README for details
    },
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
      -- example: `as` for outer subword, `is` for inner subword
      vim.keymap.set({ "o", "x" }, "as", '<cmd>lua require("various-textobjs").subword("outer")<CR>')
      vim.keymap.set({ "o", "x" }, "is", '<cmd>lua require("various-textobjs").subword("inner")<CR>')
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    -- event = "VeryLazy",
    keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
    config = function()
      vim.g.tmux_navigator_disable_when_zoomed = 1
      vim.g.tmux_navigator_preserve_zoom = 1
    end,
  },

  { "wellle/targets.vim",       event = { "BufReadPost", "BufNewFile" } },
  {
    "junegunn/fzf",
    build = "./install --all",
    keys = {
      { "<leader>gt", "<cmd>GTags<CR>" },
      {
        mode = { "n" },
        "<leader>ga",
        "<cmd>G add .<cr>",
        { silent = true, noremap = true },
      },
      {
        mode = { "n" },
        "<Leader>gS",
        "<cmd>G stash<cr>",
        { silent = true, noremap = true },
      },
      {
        mode = { "n" },
        "<Leader>gO",
        "<cmd>G stash pop<cr>",
        { silent = true, noremap = true },
      },

      {
        mode = { "n" },
        "<Leader>gP",
        "<cmd>G! push<cr>",
        { silent = true, noremap = true },
      },
      {
        mode = { "n" },
        "<leader>gf",
        "<cmd>G! fetch --all -v<cr>",
        { silent = true, noremap = true },
      },
      {
        mode = { "n" },
        "<Leader>gp",
        "<cmd>G! pull<cr>",
        { silent = true, noremap = true },
      },
      {
        mode = { "n" },
        "<Leader>gC",
        "<cmd>G checkout . | G clean -fd<cr>",
        { silent = true, noremap = true },
      },
      {
        mode = { "n" },
        "<Leader>gl",
        "<cmd>G log -20<cr>",
        { silent = true, noremap = true },
      },
    },
  },
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
    keys = { "<leader>jv" },
    config = function()
      vim.keymap.set("n", "<leader>va", require("jenkinsfile_linter").validate, {})
    end,
  },
}
