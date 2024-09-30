return {
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    opts = {
      floating_window = false, -- show hint in a floating window, set to false for virtual text only mode
      toggle_key = "<M-lt>", -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
      hint_enable = false, -- virtual hint enable
    },
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },
}
