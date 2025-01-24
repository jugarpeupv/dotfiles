return {
  {
    "HakonHarnes/img-clip.nvim",
    -- keys = { "<leader>pi" },
    opts = {
      default = {
        use_absolute_path = false,
        prompt_for_file_name = false,
        show_dir_path_in_prompt = true,
        dir_path = function()
          -- return "assets/imgs" .. vim.fn.expand("%:t:r")
          return "assets/imgs"
        end,
        drag_and_drop = {
          enabled = true, ---@type boolean | fun(): boolean
          insert_mode = true,
        },
      }
      -- filetypes = {
      --   markdown = {
      --     -- relative_to_current_file = true,
      --   },
      -- },
      -- add options here
      -- or leave it empty to use the default settings
    },
    keys = {
      -- suggested keymap
      -- { "<leader>pi", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
      {
        "<leader>pi",
        function()
          require("img-clip").paste_image({ use_absolute_path = false })
        end,
        desc = "Paste image from system clipboard",
      },
    },
  },
}
