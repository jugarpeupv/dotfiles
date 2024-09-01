return {

  {
    "mbbill/undotree",
    -- cmd = { 'UndotreeShow', 'UndotreeToggle' },
    -- event = "VeryLazy",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
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
      vim.keymap.set("n", "<leader>ux", vim.cmd.UndotreeToggle)
      vim.keymap.set("n", "<leader>ud", vim.cmd.UndotreeShow)
    end,
  },
}
