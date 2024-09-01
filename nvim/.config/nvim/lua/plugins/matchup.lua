-- -- return {}
return {
  "andymass/vim-matchup",
  -- event = { "CursorMoved" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  -- event = { "VeryLazy" },
  event = {"BufReadPost", "BufNewFile"},
  -- keys = { "%", mode = "n" },
  config = function()
    -- vim.cmd[[let g:loaded_matchit = 1]]
    -- vim.g.matchup_delim_nomids = 1
    vim.g.matchup_matchparen_offscreen = { method = "status" }
    vim.g.matchup_matchparen_end_sign = "󱐋"
  end,
}
