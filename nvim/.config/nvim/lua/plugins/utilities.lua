return {
  -- lazy.nvim
  {
    "gennaro-tedesco/nvim-jqx",
    event = { "BufReadPost" },
    ft = { "json", "yaml" },
  },
  {
    "sontungexpt/url-open",
    -- event = "VeryLazy",
    keys = { { "gx", "<esc>:URLOpenUnderCursor<cr>" } },
    cmd = "URLOpenUnderCursor",
    config = function()
      local status_ok, url_open = pcall(require, "url-open")
      if not status_ok then
        return
      end
      url_open.setup({
        highlight_url = {
          all_urls = {
            enabled = false,
            fg = "#21d5ff", -- "text" or "#rrggbb"
            -- fg = "text", -- text will set underline same color with text
            bg = nil, -- nil or "#rrggbb"
            underline = true,
          },
          cursor_move = {
            enabled = false,
            fg = "#199eff", -- "text" or "#rrggbb"
            -- fg = "text", -- text will set underline same color with text
            bg = nil, -- nil or "#rrggbb"
            underline = true,
          },
        },
      })
    end,
  },
  -- https://github.com/johmsalas/text-case.nvim
  -- { "VidocqH/data-viewer.nvim" },
  -- { "Djancyp/regex.nvim" },
  -- {"https://github.com/gabrielpoca/replacer.nvim"},
  -- { "Wansmer/sibling-swap.nvim" },
  -- { "nvim-spider" }
  -- { "airblade/vim-matchquote" },
  -- { "ton/vim-bufsurf" },
  { "taybart/b64.nvim",         cmd = { "B64Encode", "B64Decode" } },
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

  { "wellle/targets.vim",      event = { "BufReadPost", "BufNewFile" } },
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
  { "tpope/vim-repeat",       keys = { "." } },
  { "nvim-lua/plenary.nvim",  lazy = true },
  { "tpope/vim-surround",     event = { "BufReadPost", "BufNewFile" } },
  { "windwp/nvim-ts-autotag", ft = "html" },
  { "tpope/vim-dispatch",     lazy = true },
  { "kkharji/sqlite.lua",     lazy = true },
  {
    "ckipp01/nvim-jenkinsfile-linter",
    -- event = { "BufReadPost", "BufNewFile" },
    keys = { "<leader>jv" },
    config = function()
      vim.keymap.set("n", "<leader>va", require("jenkinsfile_linter").validate, {})
    end,
  },
}
