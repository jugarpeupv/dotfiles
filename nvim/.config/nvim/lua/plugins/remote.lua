return {
  "amitds1997/remote-nvim.nvim",
  version = "*",                   -- Pin to GitHub releases
  -- keys = { { "n" } }
  cmd = { "RemoteStart", "RemoteStop", "RemoteInfo", "RemoteCleanup", "RemoteConfigDel", "RemoteLog" },
  dependencies = {
    "nvim-lua/plenary.nvim",       -- For standard functions
    "MunifTanjim/nui.nvim",        -- To build the plugin UI
    "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
  },
  config = true,
  -- opts = {
  --   devpod = {
  --     binary = "devpod", -- Binary to use for devpod
  --     docker_binary = "docker", -- Binary to use for docker-related commands
  --     ---@diagnostic disable-next-line:param-type-mismatch
  --     -- ssh_config_path = utils.path_join(utils.is_windows, vim.fn.stdpath("data"), constants.PLUGIN_NAME, "ssh_config"), -- Path where devpod SSH configurations should be stored
  --     search_style = "current_dir_only", -- How should devcontainers be searched
  --     -- For dotfiles, see https://devpod.sh/docs/developing-in-workspaces/dotfiles-in-a-workspace for more information
  --     dotfiles = {
  --       path = nil, -- Path to your dotfiles which should be copied into devcontainers
  --       install_script = nil -- Install script that should be called to install your dotfiles
  --     },
  --     gpg_agent_forwarding = false, -- Should GPG agent be forwarded over the network
  --     container_list = "all", -- How should docker list containers ("running_only" or "all")
  --   },
  -- }
}
