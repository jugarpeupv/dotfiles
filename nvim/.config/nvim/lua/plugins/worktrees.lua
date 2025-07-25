-- return {}
return {
  --Create local branch to track remote branch
  -- git branch --track feature/mytest origin/feature/mytest

  -- "ThePrimeagen/git-worktree.nvim",
  -- "polarmutex/git-worktree.nvim",
  -- "jugarpeupv/git-worktree.nvim",
  -- version = "^2",
  "jugarpeupv/git-worktree.nvim",
  -- dir='~/projects/git-worktree.nvim',
  -- dev = true,
  branch = "main",
  -- dependencies = { "nvim-lua/plenary.nvim" },
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
    local update_on_switch = Hooks.builtins.update_current_buffer_on_switch
    -- local config = require("git-worktree.config")

    local send_cmd_to_all_terms = function(cmd_text)
      local function get_all_terminals()
        local terminal_chans = {}
        for _, chan in pairs(vim.api.nvim_list_chans()) do
          if chan["mode"] == "terminal" and chan["pty"] ~= "" then
            table.insert(terminal_chans, chan)
          end
        end
        table.sort(terminal_chans, function(left, right)
          return left["buffer"] < right["buffer"]
        end)
        if #terminal_chans == 0 then
          return nil
        end
        return terminal_chans
      end

      local send_to_terminal = function(terminal_chan, term_cmd_text)
        vim.api.nvim_chan_send(terminal_chan, term_cmd_text .. "\n")
      end

      local terminals = get_all_terminals()
      if terminals and next(terminals) == nil then
        return nil
      end

      if terminals == nil then
        return nil
      end

      for _, terminal in pairs(terminals) do
        send_to_terminal(terminal["id"], cmd_text)
      end

      return true
    end

    ---------------------------------------------------
    local terminal_send_cmd = function(cmd_text)
      local function get_first_terminal()
        local terminal_chans = {}
        for _, chan in pairs(vim.api.nvim_list_chans()) do
          if chan["mode"] == "terminal" and chan["pty"] ~= "" then
            table.insert(terminal_chans, chan)
          end
        end
        table.sort(terminal_chans, function(left, right)
          return left["buffer"] < right["buffer"]
        end)
        if #terminal_chans == 0 then
          return nil
        end
        return terminal_chans[1]["id"]
      end

      local send_to_terminal = function(terminal_chan, term_cmd_text)
        vim.api.nvim_chan_send(terminal_chan, term_cmd_text .. "\n")
      end

      local terminal = get_first_terminal()
      if not terminal then
        return nil
      end

      if not cmd_text then
        vim.ui.input({ prompt = "Send to terminal: " }, function(input_cmd_text)
          if not input_cmd_text then
            return nil
          end
          send_to_terminal(terminal, input_cmd_text)
        end)
      else
        send_to_terminal(terminal, cmd_text)
      end
      return true
    end

    Hooks.register(Hooks.type.SWITCH, function(path, prev_path)
      local wt_utils = require("jg.custom.worktree-utils")
      local api_nvimtree = require("nvim-tree.api")
      -- print("[WT-SWITCH] path: " .. path)
      -- print("[WT-SWITCH] prev_path: " .. prev_path)
      local prev_node_modules_path = prev_path .. "/node_modules"
      local prev_node_modules_exists = vim.fn.isdirectory(prev_node_modules_path)

      -- Copy over node_modules folder if it exists
      if prev_node_modules_exists ~= 0 then
        os.rename(prev_node_modules_path, path .. "/node_modules")
        -- api_nvimtree.tree.reload()
      end

      -- new code
      -- print("[WT-SWITCH] prev_path: ", prev_path)
      -- print("[WT-SWITCH] worktree_prev_git_path: ", prev_path .. "/.git")
      local ignored_root_files = wt_utils.get_ignored_root_files(prev_path, prev_path .. "/.git")
      -- print("[WT-SWITCH] ignored_root_files: ", vim.inspect(ignored_root_files))

      for _, file in ipairs(ignored_root_files) do
        local prev_file_path = prev_path .. "/" .. file
        local prev_file_exists = vim.fn.filereadable(prev_file_path)
        if prev_file_exists ~= 0 then
          os.rename(prev_file_path, path .. "/" .. file)
        end
      end
      -- end new code



      api_nvimtree.tree.reload()
      -- update .git/HEAD to the new branch so when you open a new terminal on root parent it shows the corrent branch

      -- TODO: The first time a branch is created on .git working dir, wt_switch_info is {}
      local wt_switch_info = wt_utils.get_wt_info(path)
      if next(wt_switch_info) == nil then
        -- print("[WT-SWITCH] wt_switch_info: " .. vim.inspect(wt_switch_info))
        return
      end
      wt_utils.update_git_head(wt_switch_info.wt_root_dir, wt_switch_info.wt_head)

      -- Send command to the terminal to change the directory
      -- Toggleterm
      local cmd = "cmd='cd " .. path .. "'" .. "open=0"
      local toggleterm_status, toggleterm = pcall(require, "toggleterm")
      if toggleterm_status then
        toggleterm.exec_command(cmd)
      end
      -- Nvim terminal
      if not toggleterm_status then
        -- terminal_send_cmd("cd " .. path)
        send_cmd_to_all_terms("cd " .. path)
      end

      -- Write to disk new pointing branch
      local file_utils = require("jg.custom.file-utils")
      local wt_root_dir_with_ending = wt_switch_info.wt_root_dir .. "/"
      local my_table = {
        penultimate_wt = prev_path,
        last_active_wt = wt_switch_info.wt_dir,
      }
      file_utils.write_bps(file_utils.get_bps_path(wt_root_dir_with_ending), my_table)

      -- Update current file opened
      if vim.bo.filetype == "NvimTree" then
        return
      else
        update_on_switch(path, prev_path)
      end
    end)

    Hooks.register(Hooks.type.CREATE, function(path, branch, upstream)
      -- print("[WT-CREATE] branch: " .. branch)
      -- if upstream ~= nil then
      --   print("[WT-CREATE] upstream: " .. upstream)
      -- end
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
      -- print("[WT-CREATE] prev_node_modules_path: " .. prev_node_modules_path)
      -- print("[WT-CREATE] worktree_path: " .. worktree_path)
      -- print("[WT-CREATE] destination_path: " .. destination_path)

      local prev_node_modules_exists = vim.fn.isdirectory(prev_node_modules_path)
      if prev_node_modules_exists ~= 0 then
        os.rename(prev_node_modules_path, destination_path)
        local api_nvimtree = require("nvim-tree.api")
        api_nvimtree.tree.reload()
      end

      local file_utils = require("jg.custom.file-utils")
      -- print("[WT-CREATE] path: " .. original_path)
      local my_table = {
        penultimate_wt = "",
        last_active_wt = worktree_path,
      }
      file_utils.write_bps(file_utils.get_bps_path(original_path .. "_"), my_table)
    end)

    Hooks.register(Hooks.type.DELETE, function(path)
      local api_nvimtree = require("nvim-tree.api")
      api_nvimtree.tree.reload()

      -- local wt_utils = require("jg.custom.worktree-utils")
      -- local file_utils = require("jg.custom.file-utils")
      --
      -- -- we cant move node_modules because they are already removed
      --
      -- local root_dir
      -- if string.find(path, "wt") then
      --   root_dir = path:match("(.+)wt/.*")
      -- else
      --   root_dir = path:match("(.*/).-$")
      -- end
      -- print("[WT-DELETE] path: " .. path)
      -- print("[WT-DELETE] root_dir: ", root_dir)
      -- local bps_path = file_utils.get_bps_path(root_dir)
      -- local data = file_utils.load_bps(bps_path)
      -- local api_nvimtree = require("nvim-tree.api")
      -- print("[WT-DELETE] data: " .. vim.inspect(data))
      -- if data == nil then
      --   api_nvimtree.tree.reload()
      --   return
      -- end
      -- local penultimate_wt = data.penultimate_wt
      -- api_nvimtree.tree.change_root(penultimate_wt)
      --
      -- -- Write to disk new last active worktree pointing to penultimate worktree
      -- local my_table = {
      --   penultimate_wt = penultimate_wt,
      --   last_active_wt = penultimate_wt,
      -- }
      -- file_utils.write_bps(file_utils.get_bps_path(root_dir), my_table)

      -- -- update .git/HEAD to the new branch so when you open a new terminal on root parent it shows the correct branch
      -- local wt_switch_info = wt_utils.get_wt_info(penultimate_wt)
      -- if wt_switch_info == nil then
      --   return
      -- end
      -- wt_utils.update_git_head(wt_switch_info.wt_root_dir, wt_switch_info.wt_head)
      --
      -- -- Send command to the terminal to change the directory
      -- local cmd = "cmd='cd " .. penultimate_wt .. "'" .. "open=0"
      -- local toggleterm_status, toggleterm = pcall(require, "toggleterm")
      -- if toggleterm_status then
      --   toggleterm.exec_command(cmd)
      -- end
      -- if not toggleterm_status then
      --   -- terminal_send_cmd("cd " .. penultimate_wt)
      --   send_cmd_to_all_terms("cd " .. penultimate_wt)
      -- end

      -- Update onChange command
      -- vim.cmd(config.update_on_change_command)
    end)
  end,
}
