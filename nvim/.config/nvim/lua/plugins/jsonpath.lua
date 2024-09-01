-- return {}
-- return {}
return {
  -- { "phelipetls/jsonpath.nvim", ft = { "json" } },
  {
    "mogelbrod/vim-jsonpath",
    ft = { "json" },
    config = function()
      vim.g.jsonpath_register = "*"
    end,
  },
}
