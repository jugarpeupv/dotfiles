return {
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      -- OR 'ibhagwan/fzf-lua',
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "Octo" },
    config = function()
      require("octo").setup({
        ssh_aliases = {
          ["github.com-mar"] = "github.com",
          ["github.com-work"] = "github.com",
          ["github.com-izertis"] = "github.com",
          ["github.com-personal"] = "github.com",
        }, -- SSH aliases. e.g. `ssh_aliases = {["github.com-work"] = "github.com"}`
      })
    end,
  },
}
