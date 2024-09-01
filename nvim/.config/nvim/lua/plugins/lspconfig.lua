-- return {}
return {
  -- {
  --   "mrcjkb/rustaceanvim",
  --   version = "^4", -- Recommended
  --   lazy = false, -- This plugin is already lazy
  -- },
  {
    "neovim/nvim-lspconfig",
    -- event = "VeryLazy",
    -- event = "User FilePost",
    -- event = { "LspAttach" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    event = { "BufReadPost", "BufNewFile" },
    -- cmd = { "LspInfo" },
    dependencies = {
      {
        "antosha417/nvim-lsp-file-operations",
        config = function()
          require("lsp-file-operations").setup()
        end,
      },
      { "hrsh7th/nvim-cmp" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "jayp0521/mason-null-ls.nvim" },
      -- { "nanotee/sqls.nvim" },
      {
        "yioneko/nvim-vtsls",
        -- cmd = { "LspInfo", "LspInstall", "LspUninstall" },
        config = function()
          require("vtsls").config({
            refactor_auto_rename = true,
          })
        end,
      },
    },
    config = function()
      -- import lspconfig plugin safely
      local on_attach = require("jg.custom.lsp-utils").attach_lsp_config
      local lspconfig_status, lspconfig = pcall(require, "lspconfig")
      if not lspconfig_status then
        return
      end

      -- import cmp-nvim-lsp plugin safely
      local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if not cmp_nvim_lsp_status then
        print("cmp_nvim_lsp could not be loaded")
        return
      end

      -- import typescript plugin safely
      -- local typescript_setup, typescript = pcall(require, "typescript")
      -- if not typescript_setup then
      --   return
      -- end

      local root_pattern = require("lspconfig.util").root_pattern

      local calculate_angularls_root_dir = function()
        local function read_file(file_path)
          local file = io.open(file_path, "r")
          if not file then
            return nil
          end

          local content = file:read("*a")
          file:close()

          return content
        end

        -- Function to check if a specific dependency is present in the package.json file
        local function has_dependency(package_json_content, dependency_name)
          local package_data = vim.json.decode(package_json_content)
          local dependencies = package_data.dependencies

          return dependencies and dependencies[dependency_name] ~= nil
        end

        -- Example usage
        local package_json_path = "package.json"
        if pcall(read_file, package_json_path) then
          local package_json_content = read_file(package_json_path)

          if package_json_content then
            local dependency_name = "@angular/core"
            local hasAngularCore = has_dependency(package_json_content, dependency_name)

            if hasAngularCore then
              return root_pattern("angular.json", "nx.json", "project.json")
            else
              return root_pattern("inventado")
            end
          else
            return root_pattern("inventado")
          end
        else
          return root_pattern("inventado")
        end
      end

      -- used to enable autocompletion (assign to every lsp server config)
      local capabilities = cmp_nvim_lsp.default_capabilities()
      -- capabilities.textDocument.foldingRange = {
      --   dynamicRegistration = false,
      --   lineFoldingOnly = true,
      -- }

      -- Change the Diagnostic symbols in the sign column (gutter)
      -- (not in youtube nvim video)
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      local signs_diag = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        -- { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignHint", text = "󰠠" },
        -- { name = "DiagnosticSignInfo", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      }

      local config = {
        virtual_text = false,
        -- virtual_text = { spacing = 4, prefix = "●" },
        -- virtual_text = { spacing = 4, prefix = "" },
        -- virtual_text = { spacing = 4, prefix = " " },

        signs = {
          active = signs_diag,
        },
        update_in_insert = true,
        -- update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          focusable = true,
          -- style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      }

      vim.diagnostic.config(config)

      -- vim.cmd([[autocmd! ColorScheme * highlight FloatBorder guifg=#394b70]])
      local border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
      }

      -- To instead override globally
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or border
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end

      -- ################### SERVER CONFIGURATIONS

      -- configure html server
      lspconfig["html"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "myangular", "html", "templ" },
      })

      require("lspconfig").vtsls.setup({
        settings = {
          typescript = {
            preferences = {
              -- other preferences...
              importModuleSpecifier = "relative",
              importModuleSpecifierEnding = "minimal",
            },
            inlayHints = {

              --           includeInlayEnumMemberValueHints = false,
              --           includeInlayFunctionLikeReturnTypeHints = false,
              --           includeInlayFunctionParameterTypeHints = true,
              --           includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
              --           includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              --           includeInlayPropertyDeclarationTypeHints = false,
              --           includeInlayVariableTypeHints = false,
              parameterNames = { enabled = "all" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = false },
              enumMemberValues = { enabled = true },
            },
          },
        },
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- require'lspconfig'.html.setup{
      --   capabilities = capabilities,
      --   on_attach = on_attach,
      -- }

      -- configure typescript server with plugin
      -- typescript.setup({
      --   server = {
      --     capabilities = capabilities,
      --     on_attach = on_attach,
      --     -- root_dir = root_pattern("tsconfig.base.json", "package.json", "jsconfig.json", ".git", "tsconfig.json"),
      --     -- root_dir = root_pattern("tsconfig.base.json", "package.json", ".git"),
      --     -- root_dir = root_pattern("tsconfig.base.json", ".git"),
      --     -- root_dir = root_pattern("tsconfig.json","tsconfig.base.json", ".git"),
      --     root_dir = root_pattern("tsconfig.base.json", "package.json", "jsconfig.json", ".git"),
      --     settings = {
      --       javascript = {
      --         inlayHints = {
      --           includeInlayEnumMemberValueHints = true,
      --           includeInlayFunctionLikeReturnTypeHints = false,
      --           includeInlayFunctionParameterTypeHints = true,
      --           includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
      --           includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      --           includeInlayPropertyDeclarationTypeHints = false,
      --           includeInlayVariableTypeHints = false,
      --         },
      --       },
      --       typescript = {
      --         inlayHints = {
      --           includeInlayEnumMemberValueHints = false,
      --           includeInlayFunctionLikeReturnTypeHints = false,
      --           includeInlayFunctionParameterTypeHints = true,
      --           includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
      --           includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      --           includeInlayPropertyDeclarationTypeHints = false,
      --           includeInlayVariableTypeHints = false,
      --         },
      --       },
      --     },
      --   },
      -- })

      -- configure css server
      lspconfig["cssls"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- lspconfig.sqlls.setup({
      --   capabilities = capabilities,
      --   on_attach = on_attach,
      --   filetypes = { 'sql' },
      --   root_dir = function(_)
      --     return vim.loop.cwd()
      --   end,
      -- })

      -- lspconfig.sqls.setup({
      --   capabilities = capabilities,

      --   on_attach = function(client, bufnr)
      --     require("sqls").on_attach(client, bufnr)
      --     require("jg.custom.lsp-utils").attach_lsp_config(client, bufnr)
      --   end,
      --   -- settings = {
      --   --   sqls = {
      --   --     connections = {
      --   --       {
      --   --         alias = "auth",
      --   --         driver = "mysql",
      --   --         -- mysql://root@localhost/auth
      --   --         -- dataSourceName = 'mysql://root@localhost/auth',
      --   --         -- dataSourceName = 'mysql://root@tcp(127.0.0.1:3306)/auth',
      --   --         -- dataSourceName = 'root:root@tcp(127.0.0.1:13306)/world',
      --   --         proto = "tcp",
      --   --         user = "root",
      --   --         passwd = "",
      --   --         host = "127.0.0.1",
      --   --         port = "3306",
      --   --         dbName = "auth",
      --   --       },
      --   --     },
      --   --   },
      --   -- },
      --   -- on_attach = on_attach,
      --   filetypes = { "sql", "mysql", "plsql" },
      --   root_dir = function(_)
      --     return vim.loop.cwd()
      --   end,
      -- })

      lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- lspconfig["pyright"].setup({
      --   capabilities = capabilities,
      --   on_attach = on_attach,
      -- })

      -- configure tailwindcss server
      lspconfig["tailwindcss"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        root_dir = root_pattern(
          "tailwind.config.js",
          "tailwind.config.ts",
          "postcss.config.js",
          "postcss.config.ts"
        ),
      })

      local ok, mason_registry = pcall(require, "mason-registry")
      if not ok then
        vim.notify("mason-registry could not be loaded")
        return
      end

      local angularls_path = mason_registry.get_package("angular-language-server"):get_install_path()

      local angular_cmd = {
        "ngserver",
        "--stdio",
        "--tsProbeLocations",
        table.concat({
          angularls_path,
          vim.uv.cwd(),
        }, ","),
        "--ngProbeLocations",
        table.concat({
          angularls_path .. "/node_modules/@angular/language-server",
          vim.uv.cwd(),
        }, ","),
      }

      lspconfig["angularls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = angular_cmd,
        on_new_config = function(new_config, _)
          new_config.cmd = angular_cmd
        end,
        filetypes = { "typescript", "myangular", "html", "typescriptreact", "typescript.tsx" },
        -- root_dir = root_pattern("angular.json", "project.json"),
        -- root_dir = root_pattern("angular.json", "nx.json"),
        root_dir = calculate_angularls_root_dir(),
      })

      lspconfig["groovyls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        handlers = {
          ["textDocument/publishDiagnostics"] = function() end,
        },
        cmd = {
          "java",
          "-jar",
          "/Users/jgarcia/.config/groovy-language-server/build/libs/groovy-language-server-all.jar",
          -- "~/.local/share/nvim/mason/packages/groovy-language-server/build/libs/groovy-language-server-all.jar",
        },
      })

      lspconfig["bashls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      local capabilities_json_ls = vim.lsp.protocol.make_client_capabilities()
      capabilities_json_ls.textDocument.completion.completionItem.snippetSupport = true

      lspconfig["eslint"].setup({
        root_dir = function(filename, bufnr)
          if string.find(filename, "node_modules/") then
            return nil
          end
          -- return require("lspconfig.server_configurations.eslint").default_config.root_dir(filename, bufnr)
          local root_dir = require("lspconfig.server_configurations.eslint").default_config.root_dir(filename)
          return root_dir
        end,
        -- root_dir = function(filename)
        --   if string.find(filename, "node_modules/") then
        --     return nil
        --   end
        --   return require("lspconfig.server_configurations.eslint").default_config.root_dir(filename)
        -- end,
        -- settings = {
        --   codeAction = {
        --     disableRuleComment = {
        --       enable = true,
        --       location = "separateLine",
        --     },
        --     showDocumentation = {
        --       enable = true,
        --     },
        --   },
        --   codeActionOnSave = {
        --     enable = false,
        --     mode = "all",
        --   },
        --   experimental = {
        --     useFlatConfig = false,
        --   },
        --   format = true,
        --   -- nodePath = "",
        --   onIgnoredFiles = "off",
        --   problems = {
        --     shortenToSingleLine = false,
        --   },
        --   quiet = false,
        --   rulesCustomizations = {},
        --   run = "onType",
        --   useESLintClass = false,
        --   validate = "on",
        --   workingDirectory = {
        --     mode = "location",
        --   },
        -- },
        on_attach = on_attach,
        capabilities = capabilities,
        -- filetypes = {
        --   "javascript",
        --   "html",
        --   "javascriptreact",
        --   "javascript.jsx",
        --   "typescript",
        --   "typescriptreact",
        --   "typescript.tsx",
        --   "vue",
        --   "svelte",
        --   "astro",
        -- },
      })

      -- lspconfig["yamlls"].setup {
      --   on_attach = on_attach,
      --   capabilities = capabilities,
      --   settings = {
      --     yaml = {
      --       schemaStore = {
      --         -- You must disable built-in schemaStore support if you want to use
      --         -- this plugin and its advanced options like `ignore`.
      --         enable = false,
      --         -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
      --         url = "",
      --       },
      --       schemas = require('schemastore').yaml.schemas(),
      --     },
      --   },
      -- }

      require("lspconfig").yamlls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          yaml = {
            schemaStore = {
              enable = false,
              url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
          },
          -- yaml = {
          --   schemas = {
          --     ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          --   },
          --   -- schemas = require('schemastore').yaml.schemas(),
          -- },
        },
      })

      lspconfig["jsonls"].setup({
        -- filetypes = { "json", "jsonc" },
        on_attach = on_attach,
        capabilities = capabilities_json_ls,
        -- capabilities = capabilities,
        filetypes = { "json", "jsonc", "json5" },
        settings = {
          json = {
            schemas = require("schemastore").json.schemas({
              -- extra = {
              --   {
              --     description = 'My custom JSON schema',
              --     fileMatch = 'project.json',
              --     name = 'project.json',
              --     url = 'https://github.com/nrwl/nx/blob/master/packages/nx/schemas/project-schema.json',
              --   }
              -- }
              -- ignore = {
              --   -- 'catalog-info.yaml',
              --   -- 'mkdocs.yml'
              -- }
            }),
            validate = { enable = true },
          },
        },
      })

      lspconfig["rust_analyzer"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            diagnostics = {
              enable = true,
            },
          },
        },
      })

      -- lspconfig["jdtls"].setup({
      --   on_attach = on_attach,
      --   capabilities = capabilities,
      -- })

      lspconfig["dockerls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      require("lspconfig").docker_compose_language_service.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- require("lspconfig").cssmodules_ls.setup({
      --   on_attach = on_attach,
      --   capabilities = capabilities,
      -- })

      -- require'lspconfig'.markdown_oxide.setup{
      --   on_attach = on_attach,
      --   capabilities = capabilities,
      -- }

      lspconfig["marksman"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- require("lspconfig").nxls.setup({
      --   capabilities = capabilities,
      --   on_attach = on_attach,
      -- })

      -- require("lspconfig").emmet_language_server.setup({
      --   capabilities = capabilities,
      --   on_attach = on_attach,
      -- })

      -- require'lspconfig'.emmet_language_server.setup{}

      require("lspconfig").emmet_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- configure lua server (with special settings)
      -- lspconfig["lua_ls"].setup({
      --   capabilities = capabilities,
      --   on_attach = on_attach,
      --   settings = { -- custom settings for lua
      --     Lua = {
      --       -- make the language server recognize "vim" global
      --       diagnostics = {
      --         globals = { "vim", "jit", "bit", "Config" },
      --       },
      --       workspace = {
      --         -- make language server aware of runtime files
      --         library = {
      --           [vim.fn.expand("$VIMRUNTIME/lua")] = true,
      --           [vim.fn.stdpath("config") .. "/lua"] = true,
      --         },
      --       },
      --     },
      --   },
      -- })

      require("lspconfig").clangd.setup({
        on_attach = on_attach,
        capabilities = cmp_nvim_lsp.default_capabilities(),
        cmd = {
          "clangd",
          "--offset-encoding=utf-16",
        },
      })

      require("lspconfig").clangd.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      require("lspconfig").lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if
              not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc")
          then
            client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
              Lua = {

                diagnostics = {
                  globals = { "vim", "jit", "bit", "Config" },
                },
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  -- (most likely LuaJIT in the case of Neovim)
                  version = "LuaJIT",
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME,
                    -- [vim.fn.stdpath("config") .. "/lua"] = true,
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                  },
                  -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                  -- library = vim.api.nvim_get_runtime_file("", true)
                },
              },
            })

            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
          end
          return true
        end,
      })

      -- Set global defaults for all servers
      lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
        capabilities = vim.tbl_deep_extend(
          "force",
          vim.lsp.protocol.make_client_capabilities(),
          -- returns configured operations if setup() was already called
          -- or default operations if not
          require("lsp-file-operations").default_capabilities()
        ),
      })
    end,
  },
}
