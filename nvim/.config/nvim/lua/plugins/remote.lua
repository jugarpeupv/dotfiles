return {
  "amitds1997/remote-nvim.nvim",
  version = "*", -- Pin to GitHub releases
  cmd = { "RemoteStart", "RemoteStop", "RemoteInfo", "RemoteCleanup", "RemoteConfigDel", "RemoteLog" },
  dependencies = {
    "MunifTanjim/nui.nvim", -- To build the plugin UI
  },
  config = true,
  opts = {
    progress_view = {
      type = "split",
    },
    offline_mode = {
      enabled = true,
      no_github = true,
      -- Add this only if you want to change the path where the Neovim releases are downloaded/located.
      -- Default location is the output of :lua= vim.fn.stdpath("cache") .. "/remote-nvim.nvim/version_cache"
      -- cache_dir = <custom-path>,
    },
    remote = {
      app_name = "nvim", -- This directly maps to the value NVIM_APPNAME. If you use any other paths for configuration, also make sure to set this.
      -- List of directories that should be copied over
      copy_dirs = {
        -- What to copy to remote's Neovim config directory
        config = {
          base = "/Users/jgarcia/dotfiles/nvim/.config/nvim",
          dirs = "*", -- Directories that should be copied over. "*" means all directories. To specify a subset, use a list like {"lazy", "mason"} where "lazy", "mason" are subdirectories}
          compression = {
            enabled = true,
            additional_opts = { "--exclude-vcs", "--exclude", "node_modules" },
          },
        },
        -- What to copy to remote's Neovim data directory
        data = {
          base = vim.fn.stdpath("data"),
          dirs = "*",
          -- dirs = {},
          compression = {
            enabled = true,
            additional_opts = { "--exclude-vcs", "--exclude", "mason", "--exclude", "lazy" },
          },
        },
        -- What to copy to remote's Neovim cache directory
        cache = {
          base = vim.fn.stdpath("cache"),
          -- dirs = "*",
          dirs = {},
          compression = {
            enabled = true,
            additional_opts = { "--exclude-vcs", "--exclude", "node_modules" },
          },
        },
        -- What to copy to remote's Neovim state directory
        state = {
          base = vim.fn.stdpath("state"),
          dirs = "*",
          compression = {
            enabled = true,
            additional_opts = { "--exclude-vcs", "--exclude", "node_modules" },
          },
        },
      },
    },
    client_callback = function(port, workspace_config)
      -- local window_name = workspace_config.devpod_source_opts.name
      print("Neovim listening on port: ", port)
      local copy_text = ("nvim --server localhost:%s --remote-ui"):format(port)

      vim.fn.setreg("+", copy_text)

      -- local cmd = ""
      -- if vim.env.TERM == "xterm-kitty" then
      --   -- cmd = ("kitty -e nvim --server localhost:%s --remote-ui"):format(port)
      --   cmd = ("tmux new-window -n %s \\; send-keys 'nvim --server localhost:%s --remote-ui' C-m \\; select-window -t %s; exit"):format(window_name, port, window_name)
      -- end
      -- vim.fn.jobstart(cmd, {
      --   detach = true,
      --   on_exit = function(job_id, exit_code, event_type)
      --     print("Client", job_id, "exited with code", exit_code, "Event type:", event_type)
      --   end,
      -- })
    end,
  },
}
