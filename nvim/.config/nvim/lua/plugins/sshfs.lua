return {
	{
		"nosduco/remote-sshfs.nvim",
    enabled = false,
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    lazy = true,
    cmd = { "RemoteSSHFSConnect", "RemoteSSHFSLiveGrep", "RemoteSSHFSFindFiles" },
		opts = {
			-- Refer to the configuration section below
			-- or leave empty for defaults
		},
    config = function(_, opts)
      require("remote-sshfs").setup(opts)
      require("telescope").load_extension("remote-sshfs")
    end,
	},
}
