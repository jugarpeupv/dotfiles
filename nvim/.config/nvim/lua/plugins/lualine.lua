-- return {}
return {
  "nvim-lualine/lualine.nvim",
  -- event = "VeryLazy",
  -- event = { "BufReadPost" },

  ft = { "DiffviewFiles" },
  event = { "TermOpen", "BufReadPre", "BufNewFile" },
  config = function()
    local colors = {
      blue = "#9CDCFE",
      -- blue = "#bb9af7",
      -- cyan = "#4EC9B0",
      -- cyan = "#94e2d5",
      -- cyan = "#bb9af7",
      -- cyan = "#9d7cd8",
      cyan = "#CBA6F7",
      -- cyan            = '#0db9d7',
      black = "#292e42",
      -- black           = '#1f2335',
      alternate_black = "#737aa2",
      white = "#737aa2",
      red = "#C586C0",
      blue_visual = "#264F78",
      violet = "#C586C0",
      grey = "#3B4252",
      -- red = "#ff5189",
      orange = "#CE9178",
    }

    local bubbles_theme = {
      normal = {
        a = { fg = colors.alternate_black, bg = colors.black },
        b = { fg = colors.alternate_black, bg = colors.black },
        c = { fg = colors.alternate_black, bg = colors.black },
        -- a = { fg = colors.alternate_black, bg = 'none'},
        -- b = { fg = colors.white, bg = 'none' },
        -- c = { fg = colors.white, bg = 'none' },
      },
      insert = { a = { fg = colors.alternate_black, bg = colors.black } },
      command = { a = { fg = colors.alternate_black, bg = colors.black } },
      visual = { a = { fg = colors.alternate_black, bg = colors.black } },
      replace = { a = { fg = colors.alternate_black, bg = colors.black } },
      inactive = {
        a = { fg = colors.alternate_black, bg = colors.black },
        b = { fg = colors.alternate_black, bg = colors.black },
        c = { fg = colors.alternate_black, bg = colors.black },
      },
      -- inactive = {
      --   a = { fg = colors.blue, bg = 'none' },
      --   b = { fg = colors.blue, bg = 'none' },
      --   c = { fg = colors.blue, bg = 'none' },
      -- },
    }

    local dirnameFormatFn = function()
      local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      local cwd = vim.fn.getcwd()
      local parent_bare_lualine_path = cwd .. "/../.bare"
      local exists_bare_dir = vim.fn.isdirectory(parent_bare_lualine_path)
      local parent_dir = vim.fn.fnamemodify(cwd .. "/..", ":p")

      if exists_bare_dir ~= 0 then
        return "  " .. parent_dir .. " "
      end

      return "  " .. dir_name .. " "
    end

    local dirname = {
      "dirname",
      -- color = { fg = "#C586C0" ,bg = "none" },
      fmt = dirnameFormatFn,
    }

    local filename = {
      "filename",
      file_status = true, -- Displays file status (readonly status, modified status)
      path = 1,        -- 0: Just the filename
      -- path = 0, -- 0: Just the filename
      -- 1: Relative path
      -- 2: Absolute path

      -- shorting_target = 100, -- Shortens path to leave 40 spaces in the window
      -- for other components. (terrible name, any suggestions?)
      symbols = {
        modified = "[!]", -- Text to show when the file is modified.
        -- readonly = "󰔉",    -- Text to show when the file is non-modifiable or readonly.
        readonly = "󰦝",
        unnamed = "󰔉", -- Text to show for unnamed buffers.
      },
      -- color = { fg = "#4EC9B0" ,bg = "none" },
    }

    local diagnostics = {
      "diagnostics",
      sources = { "nvim_lsp" },
      sections = { "error", "warn", "info", "hint" },
      diagnostics_color = {
        error = "DiagnosticVirtualTextErrorLine",
        warn = "DiagnosticVirtualTextWarnLine",
        info = "DiagnosticVirtualTextInfoLine",
        hint = "DiagnosticVirtualTextHintLine",
      },
      colored = false,
      update_in_insert = true,
      alwars_visible = false,
    }

    local diagnostics_inactive = {
      "diagnostics",
      sources = { "nvim_lsp" },
      sections = { "error", "warn", "info", "hint" },
      diagnostics_color = {
        error = "DiagnosticError",
        warn = "DiagnosticWarn",
        info = "DiagnosticInfo",
        hint = "DiagnosticHint",
      },
      colored = true,
      update_in_insert = true,
      alwars_visible = false,
      color = { bg = colors.black },
    }

    local lualine_component = require("lualine.components.branch.git_branch")

    local branch = {
      "branch",
      color = function(section)
        local cwd = vim.fn.getcwd()
        local parent_bare_lualine_path = cwd .. "/../.bare"
        local exists_bare_dir = vim.fn.isdirectory(parent_bare_lualine_path)

        local active_bufnr = vim.fn.bufnr("%")
        local branch = lualine_component.get_branch(active_bufnr)
        local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

        if dir_name ~= branch and vim.bo.filetype ~= "TelescopePrompt" and exists_bare_dir == 1 then
          return { fg = "#F38BA8" }
        end
        return { fg = colors.alternate_black }
      end,
    }

    local diff = {
      "diff",
      colored = true, -- Displays a colored diff status if set to true
      diff_color = {
        -- Same color values as the general color option can be used here.
        added = "DiffAdd",                                   -- Changes the diff's added color
        modified = "DiffChange",                             -- Changes the diff's modified color
        removed = "DiffDelete",                              -- Changes the diff's removed color you
      },
      symbols = { added = "+", modified = "~", removed = "-" }, -- Changes the symbols used by the diff.
      source = nil,                                          -- A function that works as a data source for diff.
      -- It must return a table as such:
      --   { added = add_count, modified = modified_count, removed = removed_count }
      -- or nil on failure. count <= 0 won't be displayed.
    }

    require("lualine").setup({
      options = {
        theme = bubbles_theme,
        -- theme = 'tokyonight',
        -- theme = 'catppuccin',
        -- theme = 'dracula',
        -- theme = 'vscode',
        -- theme = 'nord',
        -- theme = 'palenight',
        -- theme = 'seoul256',
        -- theme = 'onedark',
        -- theme = 'nightfly',
        -- theme = 'modus-vivendi',
        -- component_separators = '|',
        -- section_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        -- section_separators = { left = '', right = ''},
        -- section_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = ''},
        -- component_separators = { left = '', right = ''},
        component_separators = { left = " ", right = " " },
        disabled_filetypes = {
          -- statusline = { "alpha", "dashboard", "NvimTree", "Outline", "Diffview", "diffview" },
          -- 'NvimTree',
          statusline = { "alpha", "dashboard", "Outline", "Diffview", "diffview", "intro", "NvimTree" },
          winbar = {
            "help",
            "startify",
            "dashboard",
            "packer",
            "neogitstatus",
            "NvimTree",
            "Trouble",
            "alpha",
            "lir",
            "Outline",
            "spectre_panel",
            "toggleterm",
            "qf",
          },
        },
      },
      sections = {
        lualine_a = {
          { "mode", separator = { left = "", right = "" } },
          filename,
          -- diagnostics
          -- { 'mode', separator = { left = '' }, right_padding = 2 },
          -- { 'mode', separator = { left = '', right = '' } },
          -- { 'mode', separator = { left = '', right = '' } },
          -- { 'mode', separator = { left = '', right = '' } },
          -- { 'mode', separator = { left = '', right = '' } },
          -- { "mode", separator = { left = "", right = "" } },
        },
        lualine_b = { branch },
        lualine_c = {},
        lualine_x = { dirname, "filetype" },
        -- lualine_x = {},
        -- lualine_y = {},
        lualine_y = { "progress" },
        lualine_z = {
          -- { "location", separator = { left = "", right = "" } },
          -- { 'location', separator = { left = '', right = '' }, left_padding = 2 },
          -- { 'location', separator = { left = '', right = '' }, left_padding = 2 },
          -- { 'location', separator = { left = '', right = '' }, left_padding = 2 },
          -- { 'location', left_padding = 2 },
          -- { 'progress', 'location' }
          -- 'location'
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {
          -- { 'filename', right_padding = 2 },
          -- { filename },
          -- { "filename" },
          -- { 'filename', separator = { left = '' }, left_padding = 2 },
        },
        lualine_c = { filename },
        -- lualine_c = { dirname },
        -- lualine_x = { "filetype" },
        -- lualine_y = {
        --   "location",
        --   -- { 'location', separator = { left = '', right = '' }, left_padding = 2 },
        -- },
        -- lualine_x = { diff },
        lualine_x = { dirname },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      -- winbar = {
      --   lualine_a = { branch },
      --   lualine_b = {},
      --   lualine_c = { filename },
      --   lualine_x = {},
      --   lualine_y = {},
      --   lualine_z = {}
      -- },
      -- inactive_winbar = {
      --   lualine_a = {},
      --   lualine_b = {},
      --   lualine_c = { 'filename' },
      --   lualine_x = {},
      --   lualine_y = {},
      --   lualine_z = {}
      -- },
      extensions = {},
    })
  end,
}
