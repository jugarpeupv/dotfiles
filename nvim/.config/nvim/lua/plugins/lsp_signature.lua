return {
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    enabled = false,
    opts = {
      floating_window = false, -- show hint in a floating window, set to false for virtual text only mode
      bind = true,
      toggle_key = "<M-lt>", -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
      hint_enable = false, -- virtual hint enable
      wrap = true,         -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
      -- floating_window_above_cur_line = true,
      -- auto_close_after = 2,
      -- move_cursor_key = "<M-lt>",
      hint_prefix = {
        above = "↙ ", -- when the hint is on the line above the current line
        current = "← ", -- when the hint is on the same line
        below = "↖ ", -- when the hint is on the line below the current line
      },
      -- hint_inline = function()
      --   return 'eol'
      -- end, -- show hint inline in current line
    },
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },
}
