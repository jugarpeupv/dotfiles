-- return {}
return {
  {
    "akinsho/git-conflict.nvim",
    dependencies = { "sindrets/diffview.nvim" },
    -- "CWood-sdf/git-conflict.nvim",
    -- version = "*",
    branch = "main",
    -- cmd = { "DiffviewOpen" },

    keys = {
      { "<leader>gd", mode = "n" },
      { "<leader>gv", mode = { "n", "v" } },
      { "<leader>cc", mode = "n" },
      { "<leader>ll", mode = "n" },
      { "<leader>l5", mode = "n" },
      { "<leader>l0", mode = "n" },
    },
    config = function()
      require("git-conflict").setup({
        -- default_mappings = true,    -- disable buffer local mapping created by this plugin
        default_mappings = false,
        list_opener = "copen",
        debug = false,
        -- default_mappings = {
        --   ours = 'o',
        --   theirs = 't',
        --   none = '0',
        --   both = 'b',
        --   next = 'n',
        --   prev = 'p',
        -- },
        disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
        highlights = {
          -- They must have background color, otherwise the default color will be used
          incoming = "DiffText",
          current = "DiffAdd",
        },
      })

      vim.cmd([[hi GitConflictIncoming gui=none]])
      vim.cmd([[hi GitConflictCurrent gui=none]])
    end,
  },
}
