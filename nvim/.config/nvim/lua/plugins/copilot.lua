-- return {}
return {
  "zbirenbaum/copilot.lua",
  enabled = false,
  cmd = "Copilot",
  event = "InsertEnter",
  -- event = { "BufReadPost" },
  -- enabled = false,
  -- enabled = function()
  --   local is_headless = #vim.api.nvim_list_uis() == 0
  --   if is_headless then
  --     return false
  --   end
  --   return true
  -- end,
  config = function()
    require("copilot").setup({
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          -- this keymap is open to use, option control
          -- open = "<M-CR>",
          open = "<D-CR>",
        },
        layout = {
          position = "bottom", -- | top | left | right
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 10,
        keymap = {
          -- accept = "<TAB>",
          accept = false,
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
        ["grug-far"] = false,
        ["grug-far-history"] = false,
        ["grug-far-help"] = false,
      },
      server = {
        type = "nodejs",
        custom_server_filepath = os.getenv("HOME") .. "/.local/share/nvim/mason/packages/copilot-language-server/node_modules/@github/copilot-language-server/dist/language-server.js"
      },
      copilot_model = "gpt-4o-copilot",
      -- copilot_node_command = os.getenv("HOME") .. "/.nvm/versions/node/v22.11.0/bin/node", -- Node.js version must be > 18.x
      server_opts_overrides = {},
    })
  end,
}
