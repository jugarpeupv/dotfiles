local angularls_path = os.getenv("HOME") .. "/.local/share/nvim/mason/packages/angular-language-server"

local angular_cmd = {
  os.getenv("HOME") .. "/.local/share/nvim/mason/bin/ngserver",
	"--stdio",
	"--tsProbeLocations",
	table.concat({
		angularls_path,
		-- vim.uv.cwd() .. "/node_modules",
	}, ","),
	"--ngProbeLocations",
	table.concat({
		angularls_path .. "/node_modules/@angular/language-server/node_modules",
		--      vim.uv.cwd() .. "/node_modules",
		-- vim.uv.cwd(),
	}, ","),
}

return {
  cmd = angular_cmd,
  on_new_config = function(new_config, _)
  	new_config.cmd = angular_cmd
  end,
	filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" },
}
