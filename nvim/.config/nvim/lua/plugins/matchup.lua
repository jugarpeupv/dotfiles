-- return {}
return {
  "andymass/vim-matchup",
  -- event = { "CursorMoved" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  -- event = { "VeryLazy" },
  event = { "BufReadPost", "BufNewFile" },
  -- keys = { "%", mode = "n" },
  config = function()
    -- vim.cmd([[let g:matchup_matchparen_offscreen
    --       \ = {'method': 'popup', 'highlight': 'Comment'}]])
    -- vim.cmd[[let g:loaded_matchit = 1]]
    -- vim.g.matchup_transmute_enabled = 1
    -- vim.g.matchup_matchpref = {
    --   htmlangular = { tagnameonly = 1 },
    --   html = { tagnameonly = 1 },
    -- }

    vim.g.matchup_matchpref = {
      svelte = { tagnameonly = 1 },
      vue = { tagnameonly = 1 },
      typescriptreact = { tagnameonly = 1 },
      tsx = { tagnameonly = 1 },
      html = { tagnameonly = 1 },
      htmlangular = { tagnameonly = 1 },
    }

    vim.g.matchup_delim_nomids = 1
    vim.g.matchup_delim_noskips = 2
    vim.g.matchup_delim_start_plaintext = 0
    vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    -- vim.g.matchup_matchparen_offscreen = { method = "popup" }
    vim.g.matchup_matchparen_end_sign = "󱐋"
  end,
}
