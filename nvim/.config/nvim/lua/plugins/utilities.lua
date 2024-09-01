return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    config = function()
      -- require("indent_blankline").setup {
      --   -- char = '┊',
      --   space_char_blankline = " ",
      --   show_trailing_blankline_indent = false,
      --   -- use_treesitter = true,
      --   -- use_treesitter_scope = true,
      --   show_end_of_line = true,
      --   show_current_context = true,
      --   -- show_current_context_start = true,
      -- }

      require("ibl").setup({
        scope = {
          enabled = true,
          show_start = true,
          show_end = false,
          injected_languages = true,
          -- highlight = { "Function", "Label" },
          -- char = "|",
          -- char = "┋",
          char = "▏",
          -- char = "│",
          -- char = "▕",
          priority = 500,
        },
        indent = {
          char = "▏",
          -- tab_char = ">"
          tab_char = "",
          repeat_linebreak = true,
          -- tab_char = "┋"
          -- tab_char = { "a", "b", "c" },
          -- char = "┋"
        },
        whitespace = { remove_blankline_trail = false },
        exclude = {
          filetypes = { "dashboard" },
          buftypes = { "terminal" },
        },
      })

      -- vim.opt.list = true
      -- vim.opt.listchars = "eol:↵,trail:·,tab:  "
      -- vim.opt.listchars = "eol:↵,trail:·,tab:  "
      -- vim.opt.listchars = "trail:·,tab: >>"
      -- vim.cmd[[set listchars=trail:·,precedes:«,extends:»,tab:▸\]]
      -- vim.opt.listchars = "trail:·,tab: "
      -- vim.opt.listchars = "trail:·,tab: ,space:⋅ "
      -- vim.opt.listchars = "space:⋅,tab: "

      -- require("indent_blankline").setup {
      --   -- char = '┊',
      --   space_char_blankline = " ",
      --   show_trailing_blankline_indent = false,
      --   -- use_treesitter = true,
      --   -- use_treesitter_scope = true,
      --   show_end_of_line = true,
      --   show_current_context = true,
      --   -- show_current_context_start = true,
      -- }
    end,
  },
  {
    "b0o/schemastore.nvim",
    event = "VeryLazy",
  },
  {
    "LunarVim/bigfile.nvim",
    -- event = "VeryLazy",
    event = { "BufReadPre" },
    config = function()
      -- default config
      require("bigfile").setup({
        filesize = 2, -- size of the file in MiB, the plugin round file sizes to the closest MiB
        -- pattern = function(bufnr, filesize_mib)
        --   -- you can't use `nvim_buf_line_count` because this runs on BufReadPre
        --   local file_contents = vim.fn.readfile(vim.api.nvim_buf_get_name(bufnr))
        --   local file_length = #file_contents
        --   local filetype = vim.filetype.match({ buf = bufnr })
        --   if file_length > 2000 then
        --     return true
        --   end
        -- end,
        features = { -- features to disable
          "indent_blankline",
          "illuminate",
          "lsp",
          "treesitter",
          "syntax",
          "matchparen",
          "vimopts",
          "filetype",
        },
      })
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    -- event = "VeryLazy",
    -- event = {},
    ft = { "qf" },
    config = function()
      require("bqf").setup({
        magic_window = true,
        func_map = {},
        filter = {
          fzf = {
            action_for = {},
            extra_opts = {},
          },
        },
        auto_enable = true,
        auto_resize_height = true, -- highly recommended enable
        preview = {
          border = "single",
          buf_label = true,
          delay_syntax = 10,
          -- should_preview_cb = function()
          --   return false
          -- end,
          show_title = true,
          win_height = 0,
          win_vheight = 0,
          winblend = 0,
          wrap = true,
          show_scroll_bar = true,
          auto_preview = false,
        },
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- import gitsigns plugin safely
      local setup, gitsigns = pcall(require, "gitsigns")
      if not setup then
        return
      end

      -- configure/enable gitsigns
      -- gitsigns.setup()

      gitsigns.setup({
        -- signs = {
        --   add = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
        --   change = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
        --   -- add          = { hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'    },
        --   -- change       = { hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
        --   delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        --   topdelete = {
        --     hl = "GitSignsDelete",
        --     text = "‾",
        --     numhl = "GitSignsDeleteNr",
        --     linehl = "GitSignsDeleteLn",
        --   },
        --   changedelete = {
        --     hl = "GitSignsChange",
        --     text = "~",
        --     numhl = "GitSignsChangeNr",
        --     linehl = "GitSignsChangeLn",
        --   },
        --   -- untracked    = { hl = 'GitSignsAdd'   , text = '┆', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'    },
        --   untracked = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
        -- },
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          interval = 1000,
          follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
          delay = 300,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = "  <author>, <author_time:%Y-%m-%d> - <summary>",
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          border = "single",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
        -- yadm = {
        --   enable = false,
        -- },
      })
    end,
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
    -- cmd = {
    --   "TmuxNavigateLeft",
    --   "TmuxNavigateDown",
    --   "TmuxNavigateUp",
    --   "TmuxNavigateRight",
    --   "TmuxNavigatePrevious",
    -- },
    -- keys = {
    --   { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
    --   -- { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
    --   -- { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
    --   { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
    --   { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    -- },
    config = function()
      vim.g.tmux_navigator_disable_when_zoomed = 1
      vim.g.tmux_navigator_preserve_zoom = 1
    end,
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    -- optionally, override the default options:
    event = "InsertEnter",
    config = function()
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    -- event = "User FilePost",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("colorizer").setup({
        yaml = { names = false },
        md = { names = false },
        markdown = { names = false },
        scss = { names = false },
        [".scss"] = { names = false },
        [".md"] = { names = false },
        ["*"] = { names = false },
      })
    end,
  }
}
