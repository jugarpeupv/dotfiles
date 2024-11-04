return {
  {
    "mg979/vim-visual-multi",
    keys = { { "<C-n>", mode = { "n", "v" } } },
    -- event = { "BufRead", "BufNewFile" },
    config = function()
      vim.cmd([[highlight! VM_Mono guibg=#004b72]])
      vim.cmd([[highlight! VM_Extend guibg=#004b72]])
      vim.g.VM_Mono_hl = "Visual"
      vim.g.VM_Mono = "Visual"
      vim.g.VM_Extend = "Visual"
      vim.g.VM_Extend_hl = "Visual"
      vim.g.VM_Insert_hl = "Visual"
      -- vim.g.VM_default_mappings = 0
      -- vim.g.VM_maps = {}
      -- vim.g.VM_maps["Find Under"] = "<C-n>"
      -- vim.g.VM_maps["Find Subword Under"] = "<C-n>"
      -- vim.g.VM_maps["Add Cursor Down"] = "<C-S-D-Down>"
      -- vim.g.VM_maps["Add Cursor Up"] = "<C-S-D-Up>"
      -- vim.cmd[[let g:VM_maps["Add Cursor Down"]             = '<C-Down>']]
      -- vim.cmd[[let g:VM_maps["Add Cursor Up"]               = '<C-Up>']]

      -- vim.cmd[[let g:VM_maps["Select Cursor Down"]          = '<M-C-Down>']]
      -- vim.cmd[[let g:VM_maps["Select Cursor Down"]          = '<M-C-Up>']]
      -- vim.cmd[[let g:VM_maps["Add Cursor Down"]             = '<C-S-D-Down>']]
      -- vim.cmd[[let g:VM_maps["Add Cursor Up"]               = '<C-S-D-Up>']]
    end,
  },
}
