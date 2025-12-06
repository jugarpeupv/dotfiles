-- return {}
return {
  -- "kwkarlwang/bufjump.nvim",
  "jugarpeupv/bufjump.nvim",
  enabled = true,
  keys = {
    { "<M-i>" },
    { "<M-o>" },
    { "<D-i>" },
    { "<D-o>" },
  },
  -- event = "VeryLazy",
  -- event = { "BufReadPost", "BufNewFile" },
  config = function()

    local function is_inside_tmux()
      return os.getenv("TMUX") ~= nil
    end

    local function get_mi_key()
      if is_inside_tmux() then
        return "<M-i>"
      else
        return "<D-i>"
      end
    end

    local function get_mo_key()
      if is_inside_tmux() then
        return "<M-o>"
      else
        return "<D-o>"
      end
    end

    require("bufjump").setup({
      forward_key = get_mi_key(),
      backward_key = get_mo_key(),
      -- on_success = nil
      on_success = function()
        vim.cmd([[execute "normal! g`\"zz"]])
      end,
    })
    -- local opts = { silent = true, noremap = true }
    -- vim.api.nvim_set_keymap("n", "<C-b>", ":lua require('bufjump').backward()<cr>", opts)
    -- vim.api.nvim_set_keymap("n", "<C-f>", ":lua require('bufjump').forward()<cr>", opts)
    -- vim.api.nvim_set_keymap("n", "<M-i>", ":lua require('bufjump').forward()<cr>", opts)
    -- vim.api.nvim_set_keymap("n", "<M-o>", ":lua require('bufjump').backward_same_buf()<cr>", opts)
    -- vim.api.nvim_set_keymap("n", "<M-i>", ":lua require('bufjump').forward_same_buf()<cr>", opts)
  end,
}
