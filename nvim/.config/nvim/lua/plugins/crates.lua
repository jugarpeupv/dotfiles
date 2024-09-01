return {
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup {
        completion = {
          cmp = {
            enabled = true,
            -- max_results = 5,
            -- min_chars = 2 -- The minimum number of charaters to type before completions begin appearing
          },
        },
        lsp = {
          enabled = true,
          -- on_attach = function(client, bufnr)
          --   -- the same on_attach function as for your other lsp's
          -- end,
          actions = true,
          completion = true,
          hover = true,
        },
      }
    end,
  },
}
