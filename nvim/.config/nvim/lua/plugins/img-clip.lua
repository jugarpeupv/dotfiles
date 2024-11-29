return {
  {
    "HakonHarnes/img-clip.nvim",
    -- keys = { "<leader>pi" },
    opts = {
      filetypes = {
        markdown = {
          -- relative_to_current_file = true,
          dir_path = function()
            -- return "assets/imgs" .. vim.fn.expand("%:t:r")
            return "assets/imgs"
          end,
        },
      },
      -- add options here
      -- or leave it empty to use the default settings
    },
    keys = {
      -- suggested keymap
      { "<leader>pi", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  },
}
