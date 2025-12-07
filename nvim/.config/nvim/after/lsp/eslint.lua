return {
  cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/vscode-eslint-language-server", "--stdio" },
  handlers = {
    ["eslint/noLibrary"] = function(err, params, ctx, config)
      vim.print("[eslint] No ESLint library found for this project.")
      return {}
    end,
  },
  settings = {
    quiet = false,
    validate = "on",
    -- run = "onSave",
    -- experimental = {
    --   useFlatConfig = true
    -- },
  },
}
