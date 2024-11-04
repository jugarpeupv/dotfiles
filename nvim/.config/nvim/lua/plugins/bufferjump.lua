-- return {}
return {
  "kwkarlwang/bufjump.nvim",
  -- event = "VeryLazy",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("bufjump").setup({
      forward_key = "<M-i>",
      backward_key = "<M-o>",
      -- on_success = nil
    })
    -- local opts = { silent = true, noremap = true }
    -- vim.api.nvim_set_keymap("n", "<C-b>", ":lua require('bufjump').backward()<cr>", opts)
    -- vim.api.nvim_set_keymap("n", "<C-f>", ":lua require('bufjump').forward()<cr>", opts)
    -- vim.api.nvim_set_keymap("n", "<M-i>", ":lua require('bufjump').forward()<cr>", opts)
    -- vim.api.nvim_set_keymap("n", "<M-o>", ":lua require('bufjump').backward_same_buf()<cr>", opts)
    -- vim.api.nvim_set_keymap("n", "<M-i>", ":lua require('bufjump').forward_same_buf()<cr>", opts)
  end,
}
