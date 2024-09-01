return {
  -- { "tpope/vim-dadbod", cmd = { "DB" } },
  -- { "kristijanhusak/vim-dadbod-ui" },
  -- { "kristijanhusak/vim-dadbod-completion" },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod",                     lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
    },
    keys = { "<leader>db" },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.dbs = {
        -- { name = 'dev', url = 'postgres://postgres:mypassword@localhost:5432/my-dev-db' }
        -- { name = 'staging', url = 'postgres://postgres:mypassword@localhost:5432/my-staging-db' },
        -- {
        --   name = 'production',
        --   url = function()
        --     return vim.fn.system('get-prod-url')
        --   end
        -- },
        { name = "mysql-dev", url = "mysql://root@localhost" },
      }
    end,
    config = function()
      vim.keymap.set("n", "<leader>db", "<cmd>DBUI<CR>", { silent = true })
    end,
  },
}
