return {
  -- {
  --   enabled = true,
  --   "cskeeters/javadoc.nvim",
  --   ft = "java", -- Lazy load this plugin as soon as we open a file with java filetype
  --   init = function()
  --     vim.g.javadoc_path = "/path/to/java_doc/api"
  --   end,
  --   keys = {
  --     { "gh", "<Plug>JavadocOpen", buffer = true, ft = "java", desc = "Open javadoc api to work under cursor" },
  --   },
  -- },
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    enabled = function()
      local is_headless = #vim.api.nvim_list_uis() == 0
      if is_headless then
        return false
      end
      return true
    end,
    dependencies = { "JavaHello/spring-boot.nvim", "mfussenegger/nvim-dap" },
  },
  {
    "andreluisos/nvim-javagenie",
    enabled = false,
    ft = { "java" },
    dependencies = {
      "grapp-dev/nui-components.nvim",
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "jugarpeupv/springboot-nvim",
    ft = { "java" },
    enabled = function()
      local is_headless = #vim.api.nvim_list_uis() == 0
      if is_headless then
        return false
      end
      return true
    end,
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-jdtls",
      "rebelot/terminal.nvim",
    },
    keys = {
      {
        mode = { "n" },
        "<leader>Jr",
        "<cmd>lua require('springboot-nvim').new_boot_run()<CR>",
        { noremap = true, silent = true, desc = "Spring Boot Run Project" },
      },
      {
        mode = { "n" },
        "<leader>Jc",
        "<cmd>lua require('springboot-nvim').generate_class()<CR>",
        { noremap = true, silent = true, desc = "Java Create Class" },
      },
      {
        mode = { "n" },
        "<leader>Ji",
        "<cmd>lua require('springboot-nvim').generate_interface()<CR>",
        { noremap = true, silent = true, desc = "Java Create Interface" },
      },
      {
        mode = { "n" },
        "<leader>Je",
        "<cmd>lua require('springboot-nvim').generate_enum()<CR>",
        { noremap = true, silent = true, desc = "Java Create Enum" },
      },
    },
    config = function()
      local springboot_nvim = require("springboot-nvim")
      springboot_nvim.setup({})
    end,
  },
  {
    "JavaHello/java-deps.nvim",
    ft = { "java" },
    lazy = true,
    enabled = function()
      local is_headless = #vim.api.nvim_list_uis() == 0
      if is_headless then
        return false
      end
      return true
    end,
    dependencies = {
      { "mfussenegger/nvim-jdtls" },
      -- {
      --   "simrat39/symbols-outline.nvim",
      --   config = function()
      --     require("symbols-outline").setup()
      --   end,
      -- },
    },
    config = function()
      require("java-deps").setup({})
    end,
  },
  {
    "JavaHello/spring-boot.nvim", --"eslam-allam/spring-boot.nvim"
    version = "*",
    enabled = function()
      local is_headless = #vim.api.nvim_list_uis() == 0
      if is_headless then
        return false
      end
      return true
    end,
    ft = { "java", "yaml", "jproperties" },
    dependencies = {
      "mfussenegger/nvim-jdtls",
    },
    opts = function()
      local home = os.getenv("HOME")
      -- mason for sonarlint-language path
      local mason_registery_status = pcall(require, "mason-registry")
      if not mason_registery_status then
        vim.notify("Mason registery not found", vim.log.levels.ERROR, { title = "Spring boot" })
        return
      end

      local opts = {}
      -- spring-boot.nvim resolves the language server jar automatically via
      -- mason-registry (get_ls_from_mason), tracking package renames and version
      -- bumps. Leave ls_path unset unless you need to pin a specific jar.
      -- ~/.local/share/nvim/mason/packages/spring-boot-tools/extension/language-server/spring-boot-language-server-1.59.0-SNAPSHOT-exec.jar
      -- opts.ls_path = os.getenv("MASON")
      -- .. "/packages/spring-boot-tools/extension/language-server/spring-boot-language-server-1.59.0-SNAPSHOT-exec.jar"


      -- jdtls opts.ls_path:  ~/.local/share/nvim/mason/packages/spring-boot-tools/extension/language-server
      -- opts.ls_path = "/home/sangram/.vscode/extensions/vmware.vscode-spring-boot-1.55.1"
      -- vim.notify("spring boot ls path : " .. opts.ls_path, vim.log.levels.INFO, {title = "Spring boot"})
      opts.java_cmd = (function()
        local java_home = vim.env.JAVA_HOME
        if java_home and java_home ~= "" then
          local bin = java_home .. "/bin/java"
          if vim.fn.executable(bin) == 1 then
            return bin
          end
        end
        local sdkman_dir = vim.env.SDKMAN_DIR or (os.getenv("HOME") .. "/.sdkman")
        local current = sdkman_dir .. "/candidates/java/current/bin/java"
        if vim.fn.executable(current) == 1 then
          return current
        end
        return "java"
      end)()
      -- opts.exploded_ls_jar_data = true
      opts.jdtls_name = "jdtls"
      opts.log_file = home .. "/.local/state/nvim/spring-boot-ls.log"
      return opts
    end,
  },
}
