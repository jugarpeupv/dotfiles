return {
  filetypes = { "yaml", "yml", "yaml.github" },
  cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/yaml-language-server", "--stdio" },
  editor = {
    formatOnType = false,
  },
  format = {
    enable = true,
  },
  settings = {
    yaml = {
      validate = true,
      hover = true,
    },
  },
}
