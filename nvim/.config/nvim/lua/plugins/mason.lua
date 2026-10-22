-- return {}
return {
  {
    "williamboman/mason.nvim",
    lazy = true,
    cmd = { "Mason" },
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
      -- local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
      -- if not mason_lspconfig_status then
      --   vim.notify("mason-lspconfig not found", vim.log.levels.WARN, { title = "Mason" })
      -- end

      -- import mason-null-ls plugin safely
      -- local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
      -- if not mason_null_ls_status then
      --   vim.notify("mason-null-ls not found", vim.log.levels.WARN, { title = "Mason" })
      -- end

      local conf = vim.tbl_deep_extend("keep", opts, {
        ui = {
          border = 'rounded',
        },
        registries = {
          "github:nvim-java/mason-registry",
          "github:mason-org/mason-registry",
        },
      })

      mason.setup(conf)
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = true,
    cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
    dependencies = { "williamboman/mason.nvim" },
    enabled = function()
      local is_headless = #vim.api.nvim_list_uis() == 0
      if is_headless then
        return false
      end
      return true
    end,
    opts = {
      ensure_installed = {
        -- LSP servers
        "clangd",
        "angular-language-server",
        "bash-language-server",
        "eslint-lsp",
        "gh-actions-language-server",
        "jdtls",
        "json-lsp",
        "prisma-language-server",
        "lua-language-server",
        "nxls",
        "ruby-lsp",
        "vtsls",
        "clang-format",
        "rust-analyzer",
        "gopls",
        "marksman",
        "postgres-language-server",
        "sql-formatter",
        "sqlls",
        "pgformatter",
        -- Non-LSP / java tooling
        "actionlint",
        "java-debug-adapter",
        "java-test",
        "lombok-nightly",
        "spring-boot-tools",
        "vscode-java-dependency",
        "vscode-spring-boot-tools",
      },
      auto_update = false,
      run_on_start = true,
    },
  },
}
