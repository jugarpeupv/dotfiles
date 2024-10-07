return {
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    -- optionally, override the default options:
    event = "InsertEnter",
    config = function()
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    -- event = "User FilePost",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("colorizer").setup({
        yaml = { names = false },
        md = { names = false },
        markdown = { names = false },
        scss = { names = false },
        [".scss"] = { names = false },
        [".md"] = { names = false },
        ["*"] = { names = false },
      })
    end,
  },
}
