return {

  {
    "HiPhish/rainbow-delimiters.nvim",
    after = "nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    -- cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    config = function()
      -- This module contains a number of default definitions
      -- local rainbow_delimiters = require("rainbow-delimiters")

      vim.g.rainbow_delimiters = {
        -- strategy = {
        --   [""] = rainbow_delimiters.strategy["global"],
        --   vim = rainbow_delimiters.strategy["local"],
        -- },
        -- query = {

        --   [""] = "rainbow-delimiters",
        --   lua = "rainbow-blocks",
        -- },
        -- priority = {
        --   [""] = 110,
        --   lua = 210,
        -- },
        highlight = {
          "TSRainbowRed",
          "TSRainbowYellow",
          "TSRainbowBlue",
          "TSRainbowOrange",
          "TSRainbowGreen",
          "TSRainbowViolet",
          "TSRainbowCyan",
        },
      }
    end,
  },
}
