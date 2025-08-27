-- return {}
-- return {}
return {
  -- { "phelipetls/jsonpath.nvim", ft = { "json" } },
  {
    "mogelbrod/vim-jsonpath",
    ft = { "json", "jsonc" },
    config = function()
      vim.g.jsonpath_register = "*"
    end,
  },
}
