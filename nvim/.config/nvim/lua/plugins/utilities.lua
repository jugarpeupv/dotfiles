return {
  { "heavenshell/vim-jsdoc", cmd = { "JsDoc" } },
  {
    "barrett-ruth/live-server.nvim",
    build = "pnpm add -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = true,
  },
  -- {
  --   "andrewferrier/wrapping.nvim",
  --   config = function()
  --     require("wrapping").setup()
  --   end,
  -- },
  {
    "danymat/neogen",
    keys = {
      {
        "<leader>nt",
        function()
          require("neogen").generate()
        end,
      },
    },
    config = function()
      require("neogen").setup({ enabled = true, snippet_engine = "luasnip" })
    end,

    -- Uncomment next line if you want to follow only stable versions
    -- version = "*"
  },
  -- {
  --   "chentoast/marks.nvim",
  --   event = "VeryLazy",
  --   opts = {},
  -- },
  -- {
  --   "MattesGroeger/vim-bookmarks",
  --   config = function()
  --     vim.g.bookmark_save_per_working_dir = 1
  --     vim.g.bookmark_auto_save = 1
  --     vim.g.bookmark_sign = ''
  --     vim.cmd([[highlight BookmarkSign guifg=#89B4FA]])
  --     vim.cmd([[" Finds the Git super-project directory.
  --       function! g:BMWorkDirFileLocation()
  --           let filename = 'bookmarks'
  --           let location = ''
  --           if isdirectory('.git')
  --               " Current work dir is git's work tree
  --               let location = getcwd().'/.git'
  --           else
  --               " Look upwards (at parents) for a directory named '.git'
  --               let location = finddir('info', '.;')
  --           endif
  --           if len(location) > 0
  --               return location.'/'.filename
  --           else
  --               return getcwd().'/.'.filename
  --           endif
  --       endfunction]])
  --     vim.keymap.set("n", "<leader>mm", "<cmd>Telescope vim_bookmarks all<cr>", { noremap = true, silent = true })
  --   end,
  -- },
  {
    "fnune/recall.nvim",
    version = "*",
    keys = {
      {
        mode = { "n" },
        -- "<leader>mm",
        "mm",
        "<cmd>lua require('recall').toggle()<CR>",
        { noremap = true, silent = true },
      },
      {
        mode = { "n" },
        -- "<leader>mn",
        "mn",
        "<cmd>lua require('recall').goto_next()<CR>",
        { noremap = true, silent = true },
      },
      {
        mode = { "n" },
        -- "<leader>mp",
        "mp",
        "<cmd>lua require('recall').goto_prev()<CR>",
        { noremap = true, silent = true },
      },
      {
        mode = { "n" },
        -- "<leader>mc",
        "mc",
        "<cmd>lua require('recall').clear()<CR>",
        { noremap = true, silent = true },
      },
      {
        mode = { "n" },
        -- "<leader>ml",
        "ml",
        "<cmd>Telescope recall<CR>",
        { noremap = true, silent = true },
      },
    },
    config = function()
      local recall = require("recall")
      recall.setup({
        sign = "",
        sign_highlight = "Function",

        telescope = {
          autoload = true,
          mappings = {
            unmark_selected_entry = {
              normal = "dd",
              -- insert = "<M-d>",
              insert = "<C-x>",
            },
          },
        },

        wshada = vim.fn.has("nvim-0.10") == 0,
      })
    end,
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
      { "<leader>ot", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
      -- Your setup opts here
    },
  },
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
  { "taybart/b64.nvim",      cmd = { "B64Encode", "B64Decode" } },
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
    keys = {
      {
        "<leader>va",
        function()
          require("jenkinsfile_linter").validate()
        end,
      },
    },
  },
}
