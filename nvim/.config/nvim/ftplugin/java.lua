-- local java_debug_adapter_path = require("mason-registry").get_package("java-debug-adapter"):get_install_path()
--     .. "com.microsoft.java.debug.plugin-*.jar"
--
-- local bundles = {
--   vim.fn.glob(java_debug_adapter_path, 1),
-- }
--
--
-- ---
-- -- Include java-test bundle if present
-- ---
-- local java_test_path = require('mason-registry')
--   .get_package('java-test')
--   :get_install_path()
--
-- local java_test_bundle = vim.split(
--   vim.fn.glob(java_test_path .. '/extension/server/*.jar'),
--   '\n'
-- )
--
-- if java_test_bundle[1] ~= '' then
--   vim.list_extend(bundles, java_test_bundle)
-- end
--
-- ---
-- -- Include java-debug-adapter bundle if present
-- ---
-- local java_debug_path = require('mason-registry')
--   .get_package('java-debug-adapter')
--   :get_install_path()
--
-- local java_debug_bundle = vim.split(
--   vim.fn.glob(java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar'),
--   '\n'
-- )
--
-- if java_debug_bundle[1] ~= '' then
--   vim.list_extend(bundles, java_debug_bundle)
-- end
--
--
-- -- local java_test_path = require("mason-registry").get_package("java-test"):get_install_path() .. "server/*.jar"
-- local spring_path = require("mason-registry").get_package("spring-boot-tools"):get_install_path() .. "/jars/*.jar"
-- print("spring_path", spring_path)
--
-- local spring = vim.split(vim.fn.glob(spring_path, 1), "\n")
-- -- local java_test = vim.split(vim.fn.glob(java_test_path, 1), "\n")
-- -- print("java_test", vim.inspect(java_test))
-- print("spring", vim.inspect(spring))
--
-- -- vim.list_extend(bundles, java_test)
-- vim.list_extend(bundles, spring)
-- print("bundles", vim.inspect(bundles))
--
-- local config = {
--   cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls") },
--   root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
--   init_options = {
--     bundles = bundles,
--   },
-- }

local java_cmd = vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls")
print("java_cmd: " .. java_cmd)

local config = {
  cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls") },
  root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1])
}

require("jdtls").start_or_attach(config)
