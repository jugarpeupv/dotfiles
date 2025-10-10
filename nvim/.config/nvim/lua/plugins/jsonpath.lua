-- return {}
-- return {}
return {
  -- { "phelipetls/jsonpath.nvim", ft = { "json" } },
  {
    "mogelbrod/vim-jsonpath",
    ft = { "json", "jsonc" },
    config = function()
      vim.g.jsonpath_register = "*"

      vim.keymap.set("n", "<leader>cp", "<cmd>JsonPath<CR>", {})
    end,
  },
}
