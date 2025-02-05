return {
  -- {
  --     'mrloop/telescope-git-branch.nvim'
  -- },
  {
    "isakbm/gitgraph.nvim",
    dependencies = { "sindrets/diffview.nvim" },
    keys = {
      {
        "<leader>gL",
        function()
          require("gitgraph").draw({}, { all = true, max_count = 5000 })
        end,
        desc = "GitGraph - Draw",
      },
    },
    ---@type I.GGConfig
    opts = {
      hooks = {
        -- Check diff of a commit
        on_select_commit = function(commit)
          vim.notify("DiffviewOpen " .. commit.hash .. "^!")
          vim.cmd(":DiffviewOpen " .. commit.hash .. "^!")
        end,
        -- Check diff from commit a -> commit b
        on_select_range_commit = function(from, to)
          vim.notify("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
          vim.cmd(":DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
        end,
      },
    },
  },

  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    config = function()
      vim.cmd("command! -nargs=* G Git <args>")
    end,
  },
  {
    "rbong/vim-flog",
    lazy = true,
    cmd = { "Flog", "Flogsplit", "Floggit" },
    dependencies = {
      "tpope/vim-fugitive",
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
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
          delay = 200,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = "  <author>, <author_time:%Y-%m-%d> - <summary>",
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 10000, -- Disable if file is longer than this (in lines)
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
        on_attach = function(bufnr)
          local function map(mode, lhs, rhs, opts)
            opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
          end

          -- Navigation
          map("n", "<leader>sj", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
          map("n", "<leader>sk", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

          -- Actions
          map("n", "<leader>gT", "<cmd>Gitsigns toggle_current_line_blame<CR>")
        end,
      })
    end,
  },
}
