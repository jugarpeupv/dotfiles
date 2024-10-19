-- local jdtls_setup = require("jdtls.setup")
-- local function run(cmd)
--   local output = vim.fn.system(cmd)
--   if vim.v.shell_error ~= 0  then
--     error(('Command failed: ↓\n' .. cmd .. '\nOutput from command: ↓\n' .. output))
--   end
--   return output
-- end
require("spring_boot").setup({})



local bundles = {}

---
-- Include java-test bundle if present
---
local java_test_path = require("mason-registry").get_package("java-test"):get_install_path()
local java_test_bundle = vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n")
if java_test_bundle[1] ~= "" then
  vim.list_extend(bundles, java_test_bundle)
end

---
-- Include java-debug-adapter bundle if present
---
local java_debug_path = require("mason-registry").get_package("java-debug-adapter"):get_install_path()
local java_debug_bundle =
    vim.split(vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")
if java_debug_bundle[1] ~= "" then
  vim.list_extend(bundles, java_debug_bundle)
end

---
-- Include spring boot ls bundle if present
---
local spring_path = require("mason-registry")
  .get_package("spring-boot-tools")
  :get_install_path() .. "/extension/jars/*.jar"
local spring = vim.split(vim.fn.glob(spring_path), "\n", {})
vim.list_extend(bundles, spring)

-- vim.list_extend(bundles, require("spring_boot").java_extensions())


-- local is_inside_wt = run("git rev-parse --is-inside-work-tree")

--maybe add .git
local root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1])
-- local workspace_folder = "/Users/jgarcia/.local/share/eclipse/" .. root_dir:gsub("/", "-")
local workspace_folder = "/Users/jgarcia/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
local jar = vim.fn.glob(
  "/Users/jgarcia/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar",
  false,
  false
)
local lombok = "/Users/jgarcia/.local/share/nvim/mason/packages/lombok-nightly/lombok.jar"
local config = {
  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
      },
      project = {
        referencedLibraries = {
          "**/lib/*.jar",
        },
      },
      configuration = {
        runtimes = {
          {
            name = "JavaSE-11",
            path = vim.fn.expand("/Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home"),
          },
          {
            name = "JavaSE-17",
            path = vim.fn.expand("/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home"),
          },
          {
            name = "JavaSE-23",
            path = vim.fn.expand("/Library/Java/JavaVirtualMachines/jdk-23.jdk/Contents/Home"),
          },
        },
      },
    },
  },
  flags = {
    allow_incremental_sync = true,
  },
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  on_attach = function(client, bufnr)
    require("jg.custom.lsp-utils").attach_lsp_config(client, bufnr)
    require("jdtls").setup_dap({ hotcodereplace = "auto" })
    -- require("jdtls.dap").setup_dap_main_class_configs()
  end,
  --on_init = function(client)
  --  if client.config.settings then
  --    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  --  end
  --end,
  -- stylua: ignore
  cmd = {
    -- "java",
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1G",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-javaagent:" .. lombok,
    "-jar", jar,
    "-configuration", "/Users/jgarcia/.local/share/nvim/mason/packages/jdtls/config_linux",
    "-data", workspace_folder,
    -- "-Xbootclasspath/a:" .. lombok,
  },
  root_dir = root_dir,
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  },
}
require("jdtls").start_or_attach(config)



--------------------------------------------------------------------------------

local key_map = function(mode, key, result)
  vim.api.nvim_set_keymap(
    mode,
    key,
    result,
    {noremap = true, silent = true}
  )
end

-- run debug
local function get_test_runner(test_name, debug)
  if debug then
    return 'mvn test -Dmaven.surefire.debug -Dtest="' .. test_name .. '"'
  end
  return 'mvn test -Dtest="' .. test_name .. '"'
end

local function run_java_test_method(debug)
  local utils = require'jg.core.utils'
  local method_name = utils.get_current_full_method_name("\\#")
  vim.cmd('term ' .. get_test_runner(method_name, debug))
end

local function run_java_test_class(debug)
  local utils = require'jg.core.utils'
  local class_name = utils.get_current_full_class_name()
  vim.cmd('term ' .. get_test_runner(class_name, debug))
end

local function get_spring_boot_runner(profile, debug)
  local debug_param = ""
  if debug then
    debug_param = ' -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005" '
  end

  local profile_param = ""
  if profile then
    profile_param = " -Dspring-boot.run.profiles=" .. profile .. " "
  end

  return 'mvn spring-boot:run ' .. profile_param .. debug_param
end

local function run_spring_boot(debug)
  vim.cmd('15sp|term ' .. get_spring_boot_runner(nil, debug))
end

vim.keymap.set("n", "<leader>tm", function() run_java_test_method() end)
vim.keymap.set("n", "<leader>TM", function() run_java_test_method(true) end)
vim.keymap.set("n", "<leader>tc", function() run_java_test_class() end)
vim.keymap.set("n", "<leader>TC", function() run_java_test_class(true) end)
vim.keymap.set("n", "<F9>", function() run_spring_boot() end)
vim.keymap.set("n", "<F10>", function() run_spring_boot(true) end)


------------------------------------------------

-- local bundles = {}
--
-- ---
-- -- Include java-test bundle if present
-- ---
-- local java_test_path = require("mason-registry").get_package("java-test"):get_install_path()
-- local java_test_bundle = vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n")
-- if java_test_bundle[1] ~= "" then
--   vim.list_extend(bundles, java_test_bundle)
-- end
--
-- ---
-- -- Include java-debug-adapter bundle if present
-- ---
-- local java_debug_path = require("mason-registry").get_package("java-debug-adapter"):get_install_path()
-- local java_debug_bundle =
--     vim.split(vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")
-- if java_debug_bundle[1] ~= "" then
--   vim.list_extend(bundles, java_debug_bundle)
-- end
--
-- -- -- local java_test_path = require("mason-registry").get_package("java-test"):get_install_path() .. "server/*.jar"
-- -- local spring_path = require("mason-registry").get_package("spring-boot-tools"):get_install_path() .. "/jars/*.jar"
-- -- print("spring_path", spring_path)
-- --
-- -- local spring = vim.split(vim.fn.glob(spring_path, 1), "\n")
-- -- -- local java_test = vim.split(vim.fn.glob(java_test_path, 1), "\n")
-- -- -- print("java_test", vim.inspect(java_test))
-- -- print("spring", vim.inspect(spring))
-- --
-- -- -- vim.list_extend(bundles, java_test)
-- -- vim.list_extend(bundles, spring)
-- -- print("bundles", vim.inspect(bundles))
--
-- local workspace_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1])
--
-- local config = {
--   -- cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls") },
--   cmd = {
--
--     -- 💀
--     "java", -- or '/path/to/java17_or_newer/bin/java'
--     -- depends on if `java` is in your $PATH env variable and if it points to the right version.
--
--     "-Declipse.application=org.eclipse.jdt.ls.core.id1",
--     "-Dosgi.bundles.defaultStartLevel=4",
--     "-Declipse.product=org.eclipse.jdt.ls.core.product",
--     "-Dlog.protocol=true",
--     "-Dlog.level=ALL",
--     "-Xmx1g",
--     "--add-modules=ALL-SYSTEM",
--     "--add-opens",
--     "java.base/java.util=ALL-UNNAMED",
--     "--add-opens",
--     "java.base/java.lang=ALL-UNNAMED",
--
--     -- 💀
--     -- '-jar', '/path/to/jdtls_install_location/plugins/org.eclipse.equinox.launcher_VERSION_NUMBER.jar',
--     "-jar",
--     vim.fn.expand(
--       "~/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar"
--     ),
--
--     -- 💀
--     -- '-configuration', '/path/to/jdtls_install_location/config_SYSTEM',
--     "-configuration",
--     vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/config_mac_arm"),
--     -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
--     -- Must point to the                      Change to one of `linux`, `win` or `mac`
--     -- eclipse.jdt.ls installation            Depending on your system.
--
--     -- 💀
--     -- See `data directory configuration` section in the README
--     -- '-data', '/path/to/unique/per/project/workspace/folder'
--     "-data",
--     workspace_dir,
--   },
--   root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
--   settings = {
--     java = {
--       configuration = {
--         -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
--         -- And search for `interface RuntimeOption`
--         -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
--         runtimes = {
--           {
--             name = "JavaSE-11",
--             path = vim.fn.expand("/Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home"),
--           },
--           {
--             name = "JavaSE-17",
--             path = vim.fn.expand("/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home"),
--           },
--           {
--             name = "JavaSE-23",
--             path = vim.fn.expand("/Library/Java/JavaVirtualMachines/jdk-23.jdk/Contents/Home"),
--           },
--         },
--       },
--     },
--   },
--   init_options = {
--     -- bundles = bundles,
--     bundles = {}
--   },
-- }
--
-- require("jdtls").start_or_attach(config)
--
-- -- local java_cmd = vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls")
-- -- print("java_cmd: " .. java_cmd)
--
-- -- local config = {
-- --   cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls") },
-- --   root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1])
-- -- }
-- --
-- -- require("jdtls").start_or_attach(config)
