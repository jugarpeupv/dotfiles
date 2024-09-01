return {
  "nvimdev/lspsaga.nvim",
  after = "nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "LspInfo", "LspInstall", "LspUninstall" },
  config = function()
    require("lspsaga").setup({
      -- keybinds for navigation in lspsaga window
      move_in_saga = { prev = "<C-k>", next = "<C-j>" },
      -- use enter to open file with finder
      finder_action_keys = {
        open = "<CR>",
      },
      lightbulb = {
        enable = false,
        enable_in_insert = true,
        sign = true,
        sign_priority = 40,
        virtual_text = false,
      },
      code_action = {
        num_shortcut = true,
        show_server_name = false,
        extend_gitsigns = true,
        keys = {
          -- string | table type
          quit = { "q", "<ESC>" },
          exec = "<CR>",
        },
      },
      -- use enter to open file with definition preview
      definition_action_keys = {
        edit = "<CR>",
        exit = "<ESC>",
      },
      symbol_in_winbar = {
        enable = false,
        separator = "  ",
        hide_keyword = false,
        show_file = true,
        folder_level = 2,
        respect_root = false,
        color_mode = true,
        virtual_text = false,
      },
      -- ui = {
      --   kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
      -- },
      symbols_in_winbar = {
        enable = false,
        sign = false,
        virtual_text = false,
      },
      implement = {
        enable = false,
      },
      outline = {
        detail = false,
        layout = "float",
        max_height = 1,
        left_width = 0.4,
        keys = {
          quit = "<leader>q",
        },
      },
      -- ui = {
      --   -- currently only round theme
      --   theme = 'round',
      --   -- border type can be single,double,rounded,solid,shadow.
      --   border = 'single',
      --   winblend = 0,
      --   expand = '',
      --   collapse = '',
      --   preview = '',
      --   -- code_action = '',
      --   code_action = '💡',
      --   diagnostic = '🐞',
      --   -- diagnostic = '',
      --   incoming = ' ',
      --   outgoing = ' ',
      --   colors = {
      --     --float window normal bakcground color
      --     normal_bg = '#071b2e',
      --     --title background color
      --     title_bg = '#afd700',
      --     red = '#264F78',
      --     magenta = '#d1d4cf',
      --     orange = '#569CD6',
      --     yellow = '#DCDCAA',
      --     green = '#4f856a',
      --     cyan = '#36d0e0',
      --     blue = '#61afef',
      --     purple = '#CBA6F7',
      --     white = '#d1d4cf',
      --     -- black = '#1c1c19',
      --     black = '#071b2e'
      --   },
      --   kind = {},
      -- },
    })
  end,
}
