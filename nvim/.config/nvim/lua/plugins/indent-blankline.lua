-- return {}
return {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufReadPost",
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
        show_end = true,
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
        -- tab_char = "",
        repeat_linebreak = true,
        -- tab_char = "┋",
        -- tab_char = ">",
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
}
