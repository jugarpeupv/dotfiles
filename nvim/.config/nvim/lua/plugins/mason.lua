-- return {}
return {
  -- { "jayp0521/mason-null-ls.nvim", event = "VeryLazy" },
  -- { "williamboman/mason-lspconfig.nvim", event = "VeryLazy" },
  -- { "zapling/mason-conform.nvim", after = "stevearc/conform.nvim" },
  -- {
  --   "jayp0521/mason-null-ls.nvim",
  --   enabled = function()
  --     local is_headless = #vim.api.nvim_list_uis() == 0
  --     if is_headless then
  --       return false
  --     end
  --     return true
  --   end,
  --   cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
  -- },
  {
    "williamboman/mason-lspconfig.nvim",
    enabled = function()
      local is_headless = #vim.api.nvim_list_uis() == 0
      if is_headless then
        return false
      end
      return true
    end,
    lazy = true,
    -- cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
  },
  {
    "williamboman/mason.nvim",
    -- cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    lazy = true,
    enabled = function()
      local is_headless = #vim.api.nvim_list_uis() == 0
      if is_headless then
        return false
      end
      return true
    end,
    config = function(_, opts)
      -- import mason plugin safely
      local mason_status, mason = pcall(require, "mason")
      if not mason_status then
        vim.notify("mason not found", vim.log.levels.WARN, { title = "Mason" })
      end

      -- import mason-lspconfig plugin safely
      local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
      if not mason_lspconfig_status then
        vim.notify("mason-lspconfig not found", vim.log.levels.WARN, { title = "Mason" })
      end

      -- import mason-null-ls plugin safely
      -- local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
      -- if not mason_null_ls_status then
      --   vim.notify("mason-null-ls not found", vim.log.levels.WARN, { title = "Mason" })
      -- end

      local conf = vim.tbl_deep_extend("keep", opts, {
        registries = {
          "github:nvim-java/mason-registry",
          "github:mason-org/mason-registry",
        },
      })

      -- enable mason
      mason.setup(conf)

      mason_lspconfig.setup({
        -- list of servers for mason to install
        ensure_installed = {
          "vtsls",
          -- "tsserver",
          "html",
          "cssls",
          "tailwindcss",
          "lua_ls",
          "angularls",
          "cssmodules_ls",
          "eslint",
        },
        -- auto-install configured servers (with lspconfig)
        automatic_installation = false, -- not the same as ensure_installed
      })

      -- mason_null_ls.setup({
      --   -- list of formatters & linters for mason to install
      --   ensure_installed = {
      --     "prettier", -- ts/js formatter
      --     "stylua", -- lua formatter
      --     "eslint_d", -- ts/js linter
      --   },
      --   -- auto-install configured formatters & linters (with null-ls)
      --   automatic_installation = false,
      -- })
    end,
  },
}
