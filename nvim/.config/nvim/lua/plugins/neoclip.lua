return {
  {
    "AckslD/nvim-neoclip.lua",
    event = { "BufReadPost", "BufNewFile" },
    -- keys = { "<leader>cl" },
    -- dependencies = {
    --   { "kkharji/sqlite.lua", module = "sqlite" },
    --   -- you'll need at least one of these
    --   -- {'nvim-telescope/telescope.nvim'},
    --   -- {'ibhagwan/fzf-lua'},
    -- },
    config = function()
      require("neoclip").setup({
        history = 200,
        enable_persistent_history = true,
        length_limit = 1048576,
        continuous_sync = true,
        db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
        filter = nil,
        preview = true,
        prompt = nil,
        -- default_register = "+",
        default_register = { '+', '*', '"' },
        default_register_macros = "q",
        enable_macro_history = false,
        content_spec_column = false,
        disable_keycodes_parsing = false,
        on_select = {
          move_to_front = false,
          close_telescope = true,
        },
        on_paste = {
          set_reg = false,
          move_to_front = false,
          close_telescope = true,
        },
        on_replay = {
          set_reg = false,
          move_to_front = false,
          close_telescope = true,
        },
        on_custom_action = {
          close_telescope = true,
        },
        keys = {
          telescope = {
            i = {
              select = "<cr>",
              paste = "<c-p>",
              paste_behind = "<c-r>",
              replay = "<c-q>", -- replay a macro
              delete = "<c-d>", -- delete an entry
              edit = "<c-e>", -- edit an entry
              custom = {},
            },
            n = {
              select = "<cr>",
              paste = "p",
              --- It is possible to map to more than one key.
              -- paste = { 'p', '<c-p>' },
              paste_behind = "P",
              replay = "q",
              delete = "d",
              edit = "e",
              custom = {},
            },
          },
          fzf = {
            select = "default",
            paste = "ctrl-p",
            paste_behind = "ctrl-r",
            custom = {},
          },
        },
      })
    end,
  },
}
