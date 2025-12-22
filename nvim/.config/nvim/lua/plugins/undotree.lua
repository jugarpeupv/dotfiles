return {
  {
    "mbbill/undotree",
    -- cmd = { 'UndotreeShow', 'UndotreeToggle' },
    event = "VeryLazy",
    -- event = { "BufReadPost", "BufNewFile" },
    lazy = true,
    keys = {
      { "<leader>uu", vim.cmd.UndotreeToggle},
      { "<leader>us", vim.cmd.UndotreeShow}
    },
    config = function()
      -- I am using this to clear the jumps list so that when we hit <C-o> we do not jump to nvimtree
      -- vim.cmd("clearjumps")
      vim.cmd([[
        if has("persistent_undo")
           let target_path = expand('~/.undodir')

            " create the directory and any parent directories
            " if the location does not exist.
            if !isdirectory(target_path)
                call mkdir(target_path, "p", 0700)
            endif

            let &undodir=target_path
            set undofile
        endif
      ]])
      -- vim.keymap.set('n', '<leader><F5>', vim.cmd.UndotreeToggle)
      vim.g.undotree_WindowLayout = 3
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
}
