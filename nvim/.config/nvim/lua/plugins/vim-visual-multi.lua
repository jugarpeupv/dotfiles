return {
  {
    "mg979/vim-visual-multi",
    -- keys = { { "<M-e>" }, { "<M-r>", mode = { "n", "v" } } },
    -- event = "VeryLazy",
    -- event = { "BufRead", "BufNewFile" },
    init = function()
      vim.cmd([[highlight! VM_Mono guibg=#004b72]])
      vim.cmd([[highlight! VM_Extend guibg=#004b72]])
      vim.g.VM_Mono_hl = "Visual"
      vim.g.VM_Mono = "Visual"
      vim.g.VM_Extend = "Visual"
      vim.g.VM_Extend_hl = "Visual"
      vim.g.VM_Insert_hl = "Visual"
      vim.g.VM_default_mappings = 0
      -- vim.g.VM_set_statusline = 0
      -- vim.g.VM_silent_exit = 1
      -- vim.g.VM_quit_after_leaving_insert_mode = 1
      vim.g.VM_show_warnings = 0
      vim.g.VM_maps = {
        -- ["Undo"] = "u",
        -- ["Redo"] = "<C-r>",
        ["Find Under"] = "<M-e>",
        ["Select All"] = "<M-a>",
        -- ["Find Subword Under"] = "<M-e>",
        -- ["Skip Region"] = "<C-s>",
        ["Select h"] = "<S-Left>",
        ["Select l"] = "<S-Right>",
        ["Add Cursor Up"] = "<C-Up>",
        ["Add Cursor Down"] = "<C-Down>",
        ["Select Operator"] = "gs"
        -- ["Mouse Cursor"] = "<C-LeftMouse>",
        -- ["Mouse Column"] = "<C-RightMouse>",
      }
      -- vim.g.VM_custom_remaps = {
      --   ["<C-c>"] = "<Esc>",
      -- }
      -- vim.g.VM_highlight_matches = ""
    end,
    -- config = function()
    --   vim.cmd([[highlight! VM_Mono guibg=#004b72]])
    --   vim.cmd([[highlight! VM_Extend guibg=#004b72]])
    --   vim.g.VM_Mono_hl = "Visual"
    --   vim.g.VM_Mono = "Visual"
    --   vim.g.VM_Extend = "Visual"
    --   vim.g.VM_Extend_hl = "Visual"
    --   vim.g.VM_Insert_hl = "Visual"
    --   vim.g.VM_default_mappings = 0
    --   vim.g.VM_maps = {}
    --   vim.g.VM_maps["Find Under"] = "<M-e>"
    --   vim.g.VM_maps["Find Subword Under"] = "<M-e>"
    --   vim.g.VM_maps["Select Operator"] = "gs"
    --   vim.g.VM_maps["Select All"] = "<M-r>"
    --   -- vim.g.VM_maps["Add Cursor Down"] = "<C-S-D-Down>"
    --   -- vim.g.VM_maps["Add Cursor Up"] = "<C-S-D-Up>"
    --   -- vim.cmd[[let g:VM_maps["Add Cursor Down"]             = '<C-Down>']]
    --   -- vim.cmd[[let g:VM_maps["Add Cursor Up"]               = '<C-Up>']]
    --
    --   -- vim.cmd[[let g:VM_maps["Select Cursor Down"]          = '<M-C-Down>']]
    --   -- vim.cmd[[let g:VM_maps["Select Cursor Down"]          = '<M-C-Up>']]
    --   -- vim.cmd[[let g:VM_maps["Add Cursor Down"]             = '<C-S-D-Down>']]
    --   -- vim.cmd[[let g:VM_maps["Add Cursor Up"]               = '<C-S-D-Up>']]
    -- end,
  },
}
