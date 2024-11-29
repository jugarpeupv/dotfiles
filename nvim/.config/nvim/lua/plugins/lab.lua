-- return {}
return {
  -- "0x100101/lab.nvim",
  "jugarpeupv/lab.nvim",
  build = "cd js && npm ci",
  keys = {
    { mode = { "n" }, "<leader>la", "<CMD>Lab code run<CR>" },
    { mode = { "n" }, "<leader>ls", "<CMD>Lab code stop<CR>" },
  },
  opts = {
    code_runner = {
      enabled = true,
    },
    quick_data = {
      enabled = false,
    }
  }
  -- event = "WinEnter",
  -- event = "VeryLazy",
  -- cmd = { "Lab" },
  -- config = function()
  --   require("lab").setup({
  --     code_runner = {
  --       enabled = true,
  --     },
  --     quick_data = {
  --       enabled = false,
  --     },
  --   })
  -- end,
}
