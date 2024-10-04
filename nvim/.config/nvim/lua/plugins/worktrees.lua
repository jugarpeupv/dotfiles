-- return {}
return {
  --Create local branch to track remote branch
  -- git branch --track feature/mytest origin/feature/mytest

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
      print("[WT-SWITCH] path: " .. path)
      local prev_node_modules_path = prev_path .. "/node_modules"
      local prev_node_modules_exists = vim.fn.isdirectory(prev_node_modules_path)

      -- Copy over node_modules folder if it exists
      if prev_node_modules_exists ~= 0 then
        os.rename(prev_node_modules_path, path .. "/node_modules")
        api_nvimtree.tree.reload()
      end

      -- update .git/HEAD to the new branch so when you open a new terminal on root parent it shows the corrent branch

      -- TODO: The first time a branch is created on .git working dir, wt_switch_info is {}
      local wt_utils = require("jg.custom.worktree-utils")
      local wt_switch_info = wt_utils.get_wt_info(path)
      if next(wt_switch_info) == nil then
        return
      end
      wt_utils.update_git_head(wt_switch_info.wt_root_dir, wt_switch_info.wt_head)

      -- Send command to the terminal to change the directory
      local cmd = "cmd='cd " .. path .. "'" .. "open=0"
      require("toggleterm").exec_command(cmd)

      -- Write to disk new pointing branch
      local file_utils = require("jg.custom.file-utils")
      local wt_root_dir_with_ending = wt_switch_info.wt_root_dir .. "/"
      local my_table = {
        penultimate_wt = prev_path,
        last_active_wt = wt_switch_info.wt_dir,
      }
      file_utils.write_bps(file_utils.get_bps_path(wt_root_dir_with_ending), my_table)
    end)

    Hooks.register(Hooks.type.CREATE, function(path, branch, upstream)
      -- print("[WT-CREATE] branch: " .. branch)
      if upstream ~= nil then
        print("[WT-CREATE] upstream: " .. upstream)
      end
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

    Hooks.register(Hooks.type.DELETE, function(path)
      local wt_utils = require("jg.custom.worktree-utils")
      local file_utils = require("jg.custom.file-utils")

      -- we cant move node_modules because they are already removed

      -- remove last element of the path
      local root_dir = path:match("(.*/).-$")
      local bps_path = file_utils.get_bps_path(root_dir)
      local data = file_utils.load_bps(bps_path)
      if data == nil then
        return
      end
      local penultimate_wt = data.penultimate_wt
      api_nvimtree.tree.change_root(penultimate_wt)

      -- Write to disk new last active worktree pointing to penultimate worktree
      local my_table = {
        penultimate_wt = penultimate_wt,
        last_active_wt = penultimate_wt
      }
      file_utils.write_bps(file_utils.get_bps_path(root_dir), my_table)

      -- update .git/HEAD to the new branch so when you open a new terminal on root parent it shows the correct branch
      local wt_switch_info = wt_utils.get_wt_info(penultimate_wt)
      if wt_switch_info == nil then
        return
      end
      wt_utils.update_git_head(wt_switch_info.wt_root_dir, wt_switch_info.wt_head)

      -- Send command to the terminal to change the directory
      local cmd = "cmd='cd " .. penultimate_wt .. "'" .. "open=0"
      require("toggleterm").exec_command(cmd)
    end)

  end,
}
