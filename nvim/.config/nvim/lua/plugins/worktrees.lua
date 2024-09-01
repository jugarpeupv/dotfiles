-- return {}
return {
  -- "ThePrimeagen/git-worktree.nvim",
  "polarmutex/git-worktree.nvim",
  -- "nooproblem/git-worktree.nvim",
  -- version = "^2",
  branch = "main",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = { "<leader>wt", "<leader>wc" },
  config = function()
    vim.g.git_worktree_log_level = 1

    vim.g.git_worktree = {
      change_directory_command = "cd",
      update_on_change = true,
      update_on_change_command = "e .",
      clearjumps_on_change = true,
      confirm_telescope_deletions = true,
      autopush = false,
    }

    vim.keymap.set(
      { "n" },
      "<leader>wt",
      ":lua require('telescope').extensions.git_worktree.git_worktree()<cr>",
      { noremap = true, silent = true, expr = false }
    )
    vim.keymap.set(
      { "n" },
      "<leader>wc",
      ":lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>",
      { noremap = true, silent = true, expr = false }
    )

    local Hooks = require("git-worktree.hooks")

    local api_nvimtree = require("nvim-tree.api")

    Hooks.register(Hooks.type.SWITCH, function(path, prev_path)
      local prev_node_modules_path = prev_path .. "/node_modules"
      local prev_node_modules_exists = vim.fn.isdirectory(prev_node_modules_path)

      if prev_node_modules_exists ~= 0 then
        os.rename(prev_node_modules_path, path .. "/node_modules")
        api_nvimtree.tree.reload()
      end

      -- update .git/HEAD to the new branch so when you open a new terminal on root parent it shows the corrent branch
      local wt_utils = require("jg.custom.worktree-utils")
      local wt_switch_info = wt_utils.get_wt_info(path)
      if wt_switch_info == nil then
        return
      end
      wt_utils.update_git_head(wt_switch_info.wt_root_dir, wt_switch_info.wt_head)
    end)

    Hooks.register(Hooks.type.CREATE, function(path, branch)
      local relative_path = path
      local Path = require("plenary.path")
      local original_path = ""
      if not Path:new(path):is_absolute() then
        original_path = Path:new():absolute()
        if original_path:sub(- #"/") == "/" then
          original_path = string.sub(original_path, 1, string.len(original_path) - 1)
        end
      end
      local prev_node_modules_path = original_path .. "/node_modules"
      local worktree_path = original_path .. "/" .. relative_path
      local destination_path = worktree_path .. "/node_modules"

      local prev_node_modules_exists = vim.fn.isdirectory(prev_node_modules_path)
      if prev_node_modules_exists ~= 0 then
        os.rename(prev_node_modules_path, destination_path)
        api_nvimtree.tree.reload()
      end
    end)
  end,
}
