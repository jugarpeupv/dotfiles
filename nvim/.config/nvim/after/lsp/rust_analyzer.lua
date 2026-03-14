return {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer" },
  settings = {
    ["rust-analyzer"] = {
      -- check = {
      --   command = "clippy", -- Use clippy for more detailed checks
      -- },
      diagnostics = {
        enable = true,
        experimental = {
          enable = true,
        },
      },
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
      },
      procMacro = {
        enable = true,
      },
      inlayHints = {
        enable = true,
        chainingHints = { enable = true },
        parameterHints = { enable = true },
        typeHints = { enable = true },
      },
    },
  },
}
