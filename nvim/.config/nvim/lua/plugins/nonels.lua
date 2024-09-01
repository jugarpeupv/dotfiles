-- return {}
return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "LspInfo", "LspInstall", "LspUninstall" },
  config = function()
    local null_ls_status_ok, null_ls = pcall(require, "null-ls")
    if not null_ls_status_ok then
      return
    end
    -- Migrate to
    -- Formatting --> conform.nvim
    -- Linting --> nvim-lint

    local lSsources = {
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.formatting.black,
      -- null_ls.builtins.diagnostics.eslint,
      -- null_ls.builtins.diagnostics.eslint.with({
      --   condition = function(utils)
      --     return utils.root_has_file({ ".eslintrc.json", ".eslintignore" })
      --   end,
      -- }),
      -- null_ls.builtins.completion.spell,

      -- null_ls.builtins.formatting.sql,
      -- null_ls.builtins.diagnostics.sqlfluff.with({
      --   extra_args = { "--dialect", "mysql" }, -- change to your dialect
      -- }),
      -- null_ls.builtins.formatting.sqlfmt
      -- null_ls.builtins.formatting.prettierd.with({
      --   condition = function(utils)
      --     return utils.root_has_file({ ".prettierrc", ".prettierignore"})

      --   end,
      -- }),
      -- null_ls.builtins.formatting.eslint,
      -- null_ls.builtins.diagnostics.eslint.with({
      --   condition = function(utils)
      --     return utils.root_has_file({ ".eslintrc.json", ".eslintignore" })

      --   end,
      -- }),
      -- null_ls.builtins.completion.spell,
      -- null_ls.builtins.code_actions.eslint,
      -- null_ls.builtins.formatting.prettier.with({
      --   filetypes = {
      --     "javascript",
      --     "typescript",
      --     "css",
      --     "scss",
      --     "graphql",
      --   },
      --   extra_args = {
      --     "--single-quote",
      --     "--jsx-single-quote",
      --     "--print-width",
      --     "80",
      --     "--trailing-comma",
      --     "none",
      --   },
      -- }),
    }

    null_ls.setup({
      debug = false,
      sources = lSsources,
      should_attach = function(bufnr)
        local attach = vim.api.nvim_buf_get_option(bufnr, "filetype") ~= "yaml"
        return attach
      end,
    })
  end,
}
