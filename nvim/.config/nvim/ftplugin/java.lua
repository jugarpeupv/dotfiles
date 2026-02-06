local home = os.getenv("HOME")

local mason_root_path = os.getenv("HOME") .. "/.local/share/nvim/mason"
local bundles = {}

-- Include java-test bundle if present
local java_test_path = mason_root_path .. "/packages/java-test"

local java_test_bundle = vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n")
if java_test_bundle[1] ~= "" then
	vim.list_extend(bundles, java_test_bundle)
end

-- Include java-debug-adapter bundle if present
local java_debug_path = mason_root_path .. "/packages/java-debug-adapter"
local java_debug_bundle =
	vim.split(vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")
if java_debug_bundle[1] ~= "" then
	vim.list_extend(bundles, java_debug_bundle)
end

-- Include spring boot ls bundle if present
vim.list_extend(bundles, require("spring_boot").java_extensions())

-- Include vscode-java-dependency bundle if present (Java project libs visualizer)
local java_dependency_bundle = vim.split(
	vim.fn.glob(
		home
			.. "/projects/vscode-java-dependency/jdtls.ext/com.microsoft.jdtls.ext.core/target/com.microsoft.jdtls.ext.core-*.jar"
	),
	"\n"
)
if java_dependency_bundle[1] ~= "" then
	vim.list_extend(bundles, java_dependency_bundle)
end

-- local root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", "mvnw" }, { upward = true })[1])
local root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", "mvnw" })[1])

local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local mason_path = vim.fn.stdpath("data") .. "/mason"
local jdtls_path = mason_path .. "/packages/jdtls"
local jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher.jar")

local lombok = home .. "/.local/share/nvim/mason/packages/lombok-nightly/lombok.jar"

local config = {
	settings = {
		java = {
			eclipse = {
				downloadSources = true,
			},
			maven = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
			},
			references = {
				includeDecompiledSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referenceCodeLens = {
				enabled = true,
			},
			inlayHints = {
				parameterNames = {
					enabled = "all",
				},
			},
			signatureHelp = {
				enabled = true,
				description = {
					enabled = true,
				},
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
		},
	},
	flags = {
		allow_incremental_sync = true,
	},
	capabilities = require("blink.cmp").get_lsp_capabilities(),
	on_attach = function(client, bufnr)
		require("jdtls").setup_dap({ hotcodereplace = "auto" })
		require("jg.custom.lsp-utils").attach_lsp_config(client, bufnr)
		require("jdtls.dap").setup_dap_main_class_configs()

		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = { "*.java" },
      group = vim.api.nvim_create_augroup('bufwritejavacodelens', { clear = true }),
			callback = function()
				local _, _ = pcall(vim.lsp.codelens.refresh)
			end,
		})

		local create_command = vim.api.nvim_buf_create_user_command
		create_command(bufnr, "JavaProjects", require("java-deps").toggle_outline, {
			nargs = 0,
		})
	end,
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xms1G",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. lombok,
		"-jar",
		jar,
		"-configuration",
		home .. "/.local/share/nvim/mason/packages/jdtls/config_mac_arm",
		"-data",
		workspace_folder,
	},
	root_dir = root_dir,
	init_options = {
		bundles = bundles,
		extendedClientCapabilities = extendedClientCapabilities,
	},
}

require("jdtls").start_or_attach(config)

--------------------------------------------------------------------------------

-- -- run debug
-- local function get_test_runner(test_name, debug)
-- 	if debug then
-- 		return 'mvn test -Dmaven.surefire.debug -Dtest="' .. test_name .. '"'
-- 	end
-- 	return 'mvn test -Dtest="' .. test_name .. '"'
-- end
--
-- local function run_java_test_method(debug)
-- 	local utils = require("jg.core.utils")
-- 	local method_name = utils.get_current_full_method_name("\\#")
-- 	vim.cmd("term " .. get_test_runner(method_name, debug))
-- end
--
-- local function run_java_test_class(debug)
-- 	local utils = require("jg.core.utils")
-- 	local class_name = utils.get_current_full_class_name()
-- 	vim.cmd("term " .. get_test_runner(class_name, debug))
-- end
--
-- local function get_spring_boot_runner(profile, debug)
-- 	local debug_param = ""
-- 	if debug then
-- 		debug_param =
-- 			' -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8000" '
-- 	end
--
-- 	local profile_param = ""
-- 	if profile then
-- 		profile_param = " -Dspring-boot.run.profiles=" .. profile .. " "
-- 	end
--
-- 	return "mvn spring-boot:run " .. profile_param .. debug_param
-- end
--
-- local function run_spring_boot(debug)
-- 	vim.cmd("15sp|term " .. get_spring_boot_runner(nil, debug))
-- end
--
-- vim.keymap.set("n", "<leader>Tm", function()
-- 	run_java_test_method()
-- end)
-- vim.keymap.set("n", "<leader>TM", function()
-- 	run_java_test_method(true)
-- end)
-- vim.keymap.set("n", "<leader>Tc", function()
-- 	run_java_test_class()
-- end)
-- vim.keymap.set("n", "<leader>TC", function()
-- 	run_java_test_class(true)
-- end)
-- vim.keymap.set("n", "<F9>", function()
-- 	run_spring_boot()
-- end)
-- vim.keymap.set("n", "<F10>", function()
-- 	run_spring_boot(true)
-- end)
--
-- -- live reload with gradle
-- -- first terminal
-- -- ./gradlew build --continuous --parallel --build-cache --configuration-cache
-- -- second terminal
-- -- ./gradlew bootRun --continuous --parallel --build-cache --configuration-cache
--
-- -- MAVEN
-- -- mvn spring-boot:run -Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=8000"
--
-- -- GRADLE
-- -- build.gradle
-- -- bootRun {
-- --   debugOptions {
-- --     enabled = true
-- --     port = 8000
-- --     server = true
-- --     suspend = false
-- --   }
-- -- }
-- -- Then run:
-- -- ./gradlew bootRun --debug-jvm
--
-- -- Then dap.continue() and select Attach to process:
-- --
--
-- -- local _, _ = pcall(vim.lsp.codelens.refresh)
-- -- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
-- --   pattern = { "*.java" },
-- --   callback = function()
-- --     local _, _ = pcall(vim.lsp.codelens.refresh)
-- --   end,
-- -- })
