-- return {}
return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    enabled = false,
    opts = {
      enabled = true,
      debug = false,
      -- library = {
      --   "nvim-cmp/lua/cmp/types",
      -- },
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true, enabled = false }, -- optional `vim.uv` typings
}
