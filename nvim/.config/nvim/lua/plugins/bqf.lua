return {
  {
    "stevearc/quicker.nvim",
    event = "FileType qf",
    enabled = true,
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {
      opts = {
        buflisted = false,
        number = true,
        relativenumber = false,
        signcolumn = "auto",
        winfixheight = true,
        wrap = false,
      },
      constrain_cursor = false,
      max_filename_width = function()
        return math.floor(math.min(55, vim.o.columns / 2))
      end,
      keys = {
        {
          ">",
          function()
            require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
          end,
          desc = "Expand quickfix context",
        },
        {
          "<",
          function()
            require("quicker").collapse()
          end,
          desc = "Collapse quickfix context",
        },
      },
    },
  },
  {
    "kevinhwang91/nvim-bqf",
    dependencies = {
      { "junegunn/fzf", build = "./install --all" },
    },
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
}
