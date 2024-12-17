return {
  {
    "pwntester/octo.nvim",
    -- commit = "c96a03d2aa4688f45fb8d58e832fdd37d104f12d",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      -- OR 'ibhagwan/fzf-lua',
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "Octo" },
    opts = {
      github_hostname = "github.com", -- Change to your own ghe host
      ssh_aliases = {
        ["github.com-mar"] = "github.com",
        ["github.com-work"] = "github.com",
        ["github.com-izertis"] = "github.com",
        ["github.com-personal"] = "github.com",
      }, -- SSH aliases. e.g. `ssh_aliases = {["github.com-work"] = "github.com"}`
    }
    -- config = function()
    --   require("octo").setup({
    --     -- github_hostname = "github.com", -- Change to your own ghe host
    --     ssh_aliases = {
    --       ["github.com-mar"] = "github.com",
    --       ["github.com-work"] = "github.com",
    --       ["github.com-izertis"] = "github.com",
    --       ["github.com-personal"] = "github.com",
    --     }, -- SSH aliases. e.g. `ssh_aliases = {["github.com-work"] = "github.com"}`
    --   })
    -- end,
  },
}
