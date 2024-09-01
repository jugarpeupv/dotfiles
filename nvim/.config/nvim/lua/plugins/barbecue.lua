-- return {
--   "utilyre/barbecue.nvim",
--   name = "barbecue",
--   version = "*",
--   dependencies = {
--     "SmiteshP/nvim-navic",
--     "nvim-tree/nvim-web-devicons",   -- optional dependency
--   },
--   opts = {
--     -- configurations go here
--   },
-- }

-- return {}

-- Dropbar.nvim is another alternative

-- return {}

-- return {
--   "Bekaboo/dropbar.nvim",
--   -- optional, but required for fuzzy finder support
--   dependencies = {
--     "nvim-telescope/telescope-fzf-native.nvim",
--   },
-- }

return {
  "jugarpe/barbecue.nvim",
  name = "barbecue",
  branch = "feature/preserveIconOnBufferModified",
  -- event = "VeryLazy",
  event = { "BufReadPost", "BufNewFile" },
  -- version = "*",
  dependencies = {
    "SmiteshP/nvim-navic",
  },
  dev = true,
  opts = {
    -- configurations go here
  },
  config = function()
    local status_ok, bb = pcall(require, "barbecue")
    if not status_ok then
      return
    end

    bb.setup({
      attach_navic = function()
        local filetype = vim.api.nvim_buf_get_option(0, "filetype")
        if filetype == "json" then
          return true
        end
        return false
      end,
      show_navic = function()
        local filetype = vim.api.nvim_buf_get_option(0, "filetype")
        if filetype == "json" then
          return true
        end
        return false
      end,
      -- attach_navic = true,
      -- show_navic = true,
      show_modified = true,
      -- create_autocmd = false,
      lead_custom_section = function(bufnr, _)
        local icons = {
          -- Error = '',
          Error = '',
          Warn = '',
          Info = '',
          -- Info = '',
          -- Hint = '',
          Hint = '󰠠',
        }

        local bufferModified = vim.api.nvim_buf_get_option(bufnr, "modified")

        local label = {}
        for severity, icon in pairs(icons) do
          local n = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity[string.upper(severity)] })
          if n > 0 then
            table.insert(label, { icon .. ' ' .. n .. ' ', 'DiagnosticSign' .. severity })
          end
        end
        -- if (bufferModified) then
        --   table.insert(label, { ' ● ', 'VisualNC' })
        -- end
        return label
      end,
      -- lead_custom_section = function(bufnr, _)
      --   local icons = {
      --     -- Error = '',
      --     Error = '',
      --     Warn = '',
      --     -- Info = '',
      --     Info = '',
      --     -- Hint = '',
      --     Hint = '󰠠',
      --   }

      --   local label = {}
      --   for severity, icon in pairs(icons) do
      --     local n = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity[string.upper(severity)] })
      --     if n > 0 then
      --       table.insert(label, { icon .. ' ' .. n .. ' ', 'DiagnosticSign' .. severity })
      --     end
      --   end
      --   return label
      -- end,
      exclude_filetypes = {
        -- "netrw",
        "toggleterm",
        "NvimTree",
        "Diff",
        'dirvish',
        'help',
        'dashboard',
        'fugitive',
        'diffview',
        ' ',
        '',
        'DiffviewFiles',
        'NvimTree',
        'startify',
        'dashboard',
        'packer',
        'neogitstatus',
        'Trouble',
        'alpha',
        'lir',
        'Outline',
        'spectre_panel',
        'toggleterm',
        'qf',
      },
      show_dirname = true,
      show_basename = true,
      symbols = {
        modified = "",
        -- modified = "●",
        -- modified = " "
        -- modified = "",
        -- modified = " ",
        -- modified = "",
        -- modified = "󰪥"
        -- modified = "󰧞",
        -- modified = "󰧟",
        -- modified = "[!]",
      },
      theme = {
        -- this highlight is used to override other highlights
        -- you can take advantage of its `bg` and set a background throughout your winbar
        -- (e.g. basename will look like this: { fg = "#c0caf5", bold = true })
        normal = { fg = "#c0caf5" },

        -- these highlights correspond to symbols table from config
        ellipsis = { fg = "#737aa2" },
        separator = { fg = "#737aa2" },
        modified = { fg = "#3b4261" },

        -- these highlights represent the _text_ of three main parts of barbecue
        dirname = { fg = "#737aa2" },
        basename = { bold = false },
        context = { fg = "#737aa2" },

        -- these highlights are used for context/navic icons
        -- context_file = { fg = "#ac8fe4" },
        -- context_module = { fg = "#ac8fe4" },
        -- context_namespace = { fg = "#ac8fe4" },
        -- context_package = { fg = "#ac8fe4" },
        -- context_class = { fg = "#ac8fe4" },
        -- context_method = { fg = "#ac8fe4" },
        -- context_property = { fg = "#ac8fe4" },
        -- context_field = { fg = "#ac8fe4" },
        -- context_constructor = { fg = "#ac8fe4" },
        -- context_enum = { fg = "#ac8fe4" },
        -- context_interface = { fg = "#ac8fe4" },
        -- context_function = { fg = "#ac8fe4" },
        -- context_variable = { fg = "#ac8fe4" },
        -- context_constant = { fg = "#ac8fe4" },
        -- context_string = { fg = "#ac8fe4" },
        -- context_number = { fg = "#ac8fe4" },
        -- context_boolean = { fg = "#ac8fe4" },
        -- context_array = { fg = "#ac8fe4" },
        -- context_object = { fg = "#ac8fe4" },
        -- context_key = { fg = "#ac8fe4" },
        -- context_null = { fg = "#ac8fe4" },
        -- context_enum_member = { fg = "#ac8fe4" },
        -- context_struct = { fg = "#ac8fe4" },
        -- context_event = { fg = "#ac8fe4" },
        -- context_operator = { fg = "#ac8fe4" },
        -- context_type_parameter = { fg = "#ac8fe4" },
      },
    }
    )
  end

}
