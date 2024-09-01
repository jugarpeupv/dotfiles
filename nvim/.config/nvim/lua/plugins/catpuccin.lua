-- return {}

return {
  {
    "catppuccin/nvim",
    -- dependencies = { "mg979/vim-visual-multi" },
    priority = 1000,

    -- event = "VeryLazy",
    --
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, or mocha
        transparent_background = true,
        color_overrides = {
          all = {
            surface0 = "#444444",
            surface1 = "#666666",
            surface2 = "#a3a7bc",
            surface3 = "#a3a7bc",

            -- yellow = "#36C0D8",
            yellow = "#89ddff",
            green = "#F2CDCD",
            maroon = "#FAB387",

            -- yellow = "#2ac3de",
            -- green = "#F2CDCD",
            -- maroon = "#FAB387",

            -- yellow = "#74C7EC",
            -- yellow = "#0db9d7",
            -- yellow = "#90dcd1",
            -- yellow = "#F9E2AF",
            -- yellow = "#F38BA8",
            -- yellow = "#F5C2E7",
            -- yellow = "#A6E3A1",
            -- yellow = "#74C7EC",
            -- yellow = "#89ddff",
            -- yellow = "#90dcd1",
            -- yellow = "#94E2D5",
            -- yellow = "#179299",
            -- yellow = "#74C7EC",
            -- yellow = "#37d3dc",

            -- yellow = "#41a6b5",
            -- yellow = "#8ee2cf",
            -- green = "#8ee2cf",
            -- red = "#ff007c",
            -- maroon = "#F38BA8",
            -- maroon = "#8ee2cf",
            -- maroon = "#CA9EE6"
            -- maroon = "#EBA0AC",
            -- maroon = "#F5C2E7",
            -- maroon = "#FD90E0"
            -- maroon = "#B4BEFE",
            -- maroon = "#ff007c",
            -- maroon = "#BAC2DE",
            -- maroon = "#89DCEB",
            -- maroon = "#8ee2cf",
            -- maroon = "#74C7EC"
            -- maroon = "#CBA6F7",

            --
            -- yellow = "#F2CDCD",
            -- green = "#a1dfcf",
            -- red = "#89ddff",
            -- maroon = "#CBA6F7",
            --
            --[[ green = "#a1dfcf", ]]
            -- yellow = "#2ac3de",

            -- yellow = "#89ddff",
            -- yellow = "#0db9d7",
            -- red = "#89ddff",
            -- maroon = "#F38BA8",
            --
            --
            -- yellow = "#0db9d7",
            -- maroon = "#2ac3de",
            -- maroon = "#7aa2f7",
            -- maroon = "#F38BA8",
            -- yellow = "#8ee2cf",
            -- red = "#89B4FA",
            -- teal = "#F9E2AF",
            -- sky = "#F5C2E7"
            -- maroon = "#89ddff",
            -- maroon = "#9d7cd8",
            -- maroon = "#c0caf5",
            -- text = "#c0caf5",
            -- text = "#bbc2e0"
          },
        },
        -- integrations = {},
        integrations = {
          neotest = true,
          markdown = true,
          dropbar = {
            enabled = true,
            color_mode = true, -- enable color for kind's texts, not just kind's icons
          },
          cmp = true,
          hop = true,
          gitsigns = true,
          harpoon = true,
          telescope = true,
          rainbow_delimiters = true,
          -- ts_rainbow2 = false,
          lsp_trouble = true,
          neotree = true,
          lsp_saga = true,
          mason = true,
          dap = true,
          -- native_lsp = true,
          navic = {
            enabled = false,
            custom_bg = "NONE",
          },
          nvimtree = true,
          dadbod_ui = true,
          treesitter = true,
          neogit = true,
          semantic_tokens = true,
          treesitter_context = true,
          illuminate = true,
          gitgutter = true,
        },
        show_end_of_buffer = true, -- show the '~' characters after the end of buffers
        -- term_colors = true,
        -- term_colors = true,
        term_colors = false,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        styles = {
          comments = {},
          conditionals = { "bold" },
          loops = { "bold" },
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        custom_highlights = function()
          return {
            StatusLine = { fg = "#cdd6f5", bg = "#292e42" },
            MatchParen = { bg = "#394b70", fg = "none" },
            IlluminatedWordText = { bg = "#394b70" },
            IlluminatedWordRead = { bg = "#394b70" },
            IlluminatedWordWrite = { bg = "#394b70" },
            illuminatedCurWord = { bg = "#394b70" },
            illuminatedWord = { bg = "#394b70" },
            -- Folded = { bg = "#1f2335", fg = "#737aa2" },
            -- Folded = { bg = "#292e42", fg = "#737aa2" },
            Folded = { bg = "#292e42" },
            LspInlayHint = { bg = "#0F2745", fg = "#737aa2" },
            NvimTreeBookmark = { fg = "#f2cdcd" },
            HlSearchNear = { fg = "#181826", bg = "#F38BA8" },
            HlSearchLensNear = { fg = "#181826", bg = "#F38BA8" },
            ["@markup.heading.1.marker"] = { fg = "#F5C2E7" },
            ["@markup.heading.1.markdow"] = { fg = "#F5C2E7" },
            ["@markup.heading.2.markdow"] = { fg = "#89ddff" },
            ["@markup.heading.3.markdow"] = { fg = "#94E2D5" },
            ["@markup.heading.4.markdow"] = { fg = "#F9E2AF" },
            Ignore = { fg = "#394b70" },
            NeotestPassed = { fg = "#8ee2cf" },
            EgrepifyFile = { fg = "#f2cdcd" },
            EgrepifyLnum = { fg = "#737aa2" },
            CursorLine = { bg = "#3b4261" },
            NvimTreeGitStagedIcon = { fg = "#8ee2cf" },
            -- MatchupVirtualText = { fg = "#6C7086" }
            MatchupVirtualText = { fg = "#747ebd" },
            GitSignsCurrentLineBlame = { fg = "black" },
            FloatBorder = { fg = "#394b70" },
            -- LineNR = { guifg = "#3b4261" },
          }
        end,
      })

      -- setup must be called before loading
      vim.cmd.colorscheme("catppuccin")
      vim.cmd([[hi gitcommitOverflow gui=italic]])

      vim.cmd([[highlight LineNR guifg=#3b4261]])
      vim.cmd([[highlight CursorLineNR guifg=#737aa2]])

      vim.cmd([[highlight IndentBlanklineChar guifg=#3b4251]])
      vim.cmd([[highlight IndentBlanklineContextChar guifg=#737aa2]])

      vim.api.nvim_set_hl(0, "@lsp.typemod.method.defaultLibrary.typescript", { link = "Function" })

      -- vim.cmd([[@ibl           xxx cleared]])
      vim.cmd([[highlight @ibl.indent.char.1  guifg=#3b4251]])
      vim.cmd([[highlight @ibl.whitespace.char.1 guifg=#3b4251]])
      vim.cmd([[highlight @ibl.scope.char.1 guifg=#737aa2]])
      vim.cmd([[highlight @ibl.scope.underline.1 guisp=#737aa2]])
      -- vim.cmd([[hi @markup.heading.gitcommit gui=none]])

      vim.cmd([[highlight IblIndent guifg=#3b4251]])
      vim.cmd([[highlight IblScope guifg=#737aa2]])

      vim.cmd([[highlight HarpoonBorder guifg=#394b70]])

      vim.cmd([[highlight TSRainbowRed guifg=#74C7EC]])
      vim.cmd([[highlight TSRainbowYellow guifg=#C6A0F6]])
      vim.cmd([[highlight TSRainbowBlue guifg=#89B4FA]])
      vim.cmd([[highlight TSRainbowOrange guifg=#74C7EC]])
      vim.cmd([[highlight TSRainbowGreen guifg=#C6A0F6]])
      vim.cmd([[highlight TSRainbowViolet guifg=#89B4FA]])
      vim.cmd([[highlight TSRainbowCyan guifg=#74C7EC]])

      vim.cmd([[highlight DiagnosticUnderlineWarn gui=undercurl guisp=#F9E2AF]])
      vim.cmd([[highlight DiagnosticUnderlineHint gui=underline guisp=#89ddff]])
      vim.cmd([[highlight DiagnosticUnderlineInfo gui=undercurl guisp=#89B4FA]])
      vim.cmd([[highlight DiagnosticUnderlineError gui=undercurl guisp=#f38bad]])

      vim.cmd([[hi DiffviewFilePanelRootPath guifg=#B4BEFE]])
      vim.cmd([[highlight DiffviewFilePanelTitle guifg=#B4BEFE]])
      vim.cmd([[highlight DiffviewFilePanelCounter guifg=#89B4FA]])
      vim.cmd([[highlight DiffviewFilePanelSelected guifg=none]])
      vim.cmd([[highlight TelescopeSelection guibg=#394b70 guifg=none gui=none]])
      vim.cmd([[highlight TelescopePreviewLine guibg=#394b70 gui=none]])
      vim.cmd([[highlight! CmpPmenu guibg=none]])
      vim.cmd([[highlight! CmpPmenuBorder guifg=#394b70]])
      vim.cmd([[highlight! PmenuSel guibg=#394b70]])

      --- -------------------- COMMON

      vim.cmd([[highlight DiffAdd gui=none guifg=none guibg=#103235]])
      vim.cmd([[highlight DiffChange gui=none guifg=none guibg=#272D43]])
      vim.cmd([[highlight DiffText gui=none guifg=none guibg=#394b70]])
      vim.cmd([[highlight DiffDelete gui=none guifg=none guibg=#3F2D3D]])
      vim.cmd([[highlight DiffviewDiffAddAsDelete guibg=#3f2d3d gui=none guifg=none]])
      vim.cmd([[highlight DiffviewDiffDelete gui=none guifg=#3B4252 guibg=none]])

      -- fugitive
      vim.cmd([[highlight diffAdded gui=none guifg=none guibg=#103235]])
      vim.cmd([[highlight diffRemoved gui=none guifg=none guibg=#3F2D3D]])

      --

      vim.cmd([[highlight DiffviewStatusDeleted gui=none guifg=#f38bad guibg=none]])
      vim.cmd([[highlight DiffviewStatusModified gui=none guifg=#89b4fa guibg=none]])
      vim.cmd([[highlight DiffviewStatusAdded gui=none guifg=#1abc9c guibg=none]])
      vim.cmd([[highlight DiffviewStatusUntracked gui=none guifg=#1abc9c guibg=none]])
      vim.cmd([[highlight DiffviewFilePanelInsertions gui=none guifg=#1abc9c guibg=none]])
      vim.cmd([[highlight DiffviewFilePanelDeletions gui=none guifg=#f38bad guibg=none]])

      --

      -- Left panel
      -- "DiffChange:DiffAddAsDelete",
      -- "DiffText:DiffDeleteText",
      vim.cmd([[highlight DiffAddAsDelete gui=none guifg=none guibg=#3F2D3D]])
      vim.cmd([[highlight DiffDeleteText gui=none guifg=none guibg=#4B1818]])

      -- Right panel
      -- "DiffChange:DiffAdd",
      -- "DiffText:DiffAddText",
      vim.cmd([[highlight DiffAddText gui=none guifg=none guibg=#1C5458]])
      vim.cmd([[highlight DiffDelete guifg=#011528]])

      vim.cmd([[highlight BufferLineTabSeparator gui=none guifg=#13182e]])
      vim.cmd([[highlight BufferLineTabSeparatorSelected gui=none guifg=#13182e]])
      vim.cmd([[highlight BufferLineTabSelected gui=none guibg=#394b70]])

      vim.cmd([[highlight InclineNormal  guibg=#292e42]])
      vim.cmd([[highlight InclineNormalNC  guibg=#292e42 guifg=#7C7F93]])
      vim.cmd([[highlight Winbar guifg=#bbc2e0]])
      vim.cmd([[highlight WinbarNC guifg=#7C7F93]])

      vim.cmd([[highlight TreesitterContextLineNumber guibg=#0F2745 guifg=#737aa2]])
      vim.cmd([[highlight TreesitterContext guifg=none guibg=none]])
      vim.cmd([[ hi WinSeparator guifg=#292e42 ]])
      vim.cmd([[hi NvimTreeFolderIcon guifg=#89B4FA]])
      vim.cmd([[highlight NvimTreeFolderArrowClosed guifg=#89B4FA]])
      vim.cmd([[highlight NvimTreeFolderArrowOpen guifg=#89B4FA]])
      vim.cmd([[highlight NvimTreeWinSeparator guifg=#292e42]])
      vim.cmd([[highlight NvimTreeIndentMarker guifg=#292e42]])
      vim.cmd([[highlight BufferLineOffsetSeparator guifg=#292e42]])
      vim.cmd([[highlight TelescopeBorder guifg=#394b70]])

      vim.cmd([[highlight DiagnosticWarn guifg=#F9E2AF]])
      vim.cmd([[highlight DiagnosticFloatingWarn guifg=#F9E2AF]])
      vim.cmd([[highlight DiagnosticSignWarn guifg=#F9E2AF]])
      vim.cmd([[hi DiagnosticError guifg=#F38BA8]])
      vim.cmd([[hi DiagnosticSignError guifg=#F38BA8]])

      vim.cmd([[highlight GitSignsAdd guifg=#2ac3de]])
      vim.cmd([[highlight GitSignsChange guifg=#F2CDCD]])
      vim.cmd([[highlight GitSignsChangeInLine guifg=#F2CDCD]])
      vim.cmd([[highlight GitSignsDelete guifg=#F38BA8]])
      vim.cmd([[hi TroublePreview guibg=#264F78 guifg=none]])
      -- vim.cmd([[hi TroubleFileName guibg=#394b70 guifg=#0c0c0c]])
      vim.cmd([[hi TroubleFileName guifg=#F5C2E7 guibg=none]])

      vim.cmd([[highlight DiagnosticHint guifg=#89DCEB]])
      vim.cmd([[highlight DiagnosticFloatingHint guifg=#89DCEB]])
      vim.cmd([[highlight DiagnosticSignHint guifg=#89DCEB]])
      vim.cmd([[highlight Visual gui=none cterm=none guibg=#264F78]])
      -- vim.cmd([[hi DiffviewFilePanelFileName guifg=#B4BEFE]])
      vim.cmd([[hi DiffviewFilePanelFileName guifg=#c0caf5]])
      vim.cmd([[hi @tag guifg=#F5C2E7]])
      vim.cmd([[hi @tag.attribute guifg=#B4BEFE]])
      -- vim.cmd([[hi @tag guifg=#B4BEFE]])
      -- vim.cmd([[hi @label guifg=#B4BEFE]])
      vim.cmd([[hi Error guifg=#F38BA8]])
      vim.cmd([[hi ErrorMsg guifg=#F38BA8]])
      -- vim.cmd([[hi @property guifg=#CDD6F4]])
      vim.cmd([[hi TreesitterContextBottom guifg=none gui=none]])

      -- vim.cmd([[hi @property.scss guifg=#89ddff]])
      -- vim.cmd([[hi @property.class.scss guifg=#89ddff]])
      vim.cmd([[hi @property.class.scss guifg=#CBA6F7]])
      -- vim.cmd([[hi @parameter guifg=#B4BEFE]])

      vim.cmd([[highlight @lsp.type.type guifg=#89ddff]])
      vim.cmd([[highlight @lsp.type.interface guifg=#89ddff]])
      vim.cmd([[highlight @attribute.typescript guifg=#89ddff]])
      -- vim.cmd([[highlight @lsp.typemod.variable.defaultLibrary.typescript guifg=#89ddff]])
      -- vim.cmd([[highlight @variable.builtin guifg=#89ddff]])
      vim.cmd([[highlight LspSignatureActiveParameter gui=none guifg=none guibg=#264F78]])
      vim.cmd([[highlight SignatureActiveParameter gui=none guifg=none guibg=#264F78]])

      vim.cmd([[highlight WarningMsg guifg=#F2CDCD]])

      vim.cmd([[highlight GitConflictAncestor guibg=#303446]])
      vim.cmd([[highlight GitConflictAncestorLabel guibg=#45475A]])
      vim.cmd([[highlight DiagnosticUnnecessary guifg=#747ebd]])
      vim.cmd([[highlight CopilotSuggestion gui=none]])

      vim.cmd([[highlight @keyword  gui=bold guifg=#CBA6F7]])
      vim.cmd([[highlight @keyword.return  gui=bold]])
      vim.cmd([[highlight @keyword.operator  gui=bold]])
      vim.cmd([[highlight @keyword.exception  gui=bold guifg=#F5C2E7]])

      vim.cmd([[highlight Constant gui=none cterm=none guibg=none blend=0]])
      vim.cmd([[highlight Title gui=none cterm=none guibg=none blend=0]])
      vim.cmd([[highlight NonText gui=none cterm=none guibg=none blend=0]])

      vim.cmd([[highlight VertSplit  guifg=#292e42]])
      vim.cmd([[highlight FloatBorder  guifg=#394b70]])
      vim.cmd([[highlight SagaBorder  guifg=#394b70]])
      vim.cmd([[highlight SagaTitle  guifg=#394b70]])
      vim.cmd([[highlight ctrlsfMatch guifg=#F2CDCD guibg=#394b70]])

      vim.cmd([[highlight @text.uri gui=none]])

      vim.cmd([[highlight QuickFixLine gui=none guibg=#264F78]])

      vim.cmd([[highlight TabLine guibg=none]])
      vim.cmd([[highlight TabLineSel guibg=none]])

      vim.api.nvim_set_hl(0, "DapUIPlayPauseNC", { link = "DapUIPlayPause" })
      vim.api.nvim_set_hl(0, "DapUIRestartNC", { link = "DapUIRestart" })
      vim.api.nvim_set_hl(0, "DapUIStopNC", { link = "DapUIStop" })
      vim.api.nvim_set_hl(0, "DapUIStepOverNC", { link = "DapUIStepOver" })
      vim.api.nvim_set_hl(0, "DapUIStepIntoNC", { link = "DapUIStepInto" })
      vim.api.nvim_set_hl(0, "DapUIStepBackNC", { link = "DapUIStepBack" })
      vim.api.nvim_set_hl(0, "DapUIStepOutNC", { link = "DapUIStepOut" })

      vim.cmd([[highlight DiagnosticVirtualTextWarn guifg=#DCDCAA guibg=#233745]])
      vim.cmd([[highlight DiagnosticVirtualTextInfo guifg=#2ac3de guibg=#192b38]])
      vim.cmd([[highlight DiagnosticVirtualTextError guifg=#db4b4b guibg=#362c3d]])
      vim.cmd([[highlight DiagnosticVirtualTextHint guifg=#89DCEB guibg=#233745]])

      vim.cmd([[hi EndOfBuffer guifg=#737aa2]])

      vim.cmd([[highlight DiagnosticVirtualTextWarnLine guifg=#DCDCAA guibg=#292e42]])
      vim.cmd([[highlight DiagnosticVirtualTextInfoLine guifg=#2ac3de guibg=#292e42]])
      vim.cmd([[highlight DiagnosticVirtualTextErrorLine guifg=#db4b4b guibg=#292e42]])
      vim.cmd([[highlight DiagnosticVirtualTextHintLine guifg=#89DCEB guibg=#292e42]])

      vim.cmd([[hi DiagnosticUnderlineHint gui=undercurl]])
      vim.cmd([[hi barbecue_modified guifg=#bbc2e0]])

      -- Name	Latte	Frappe	Macchiato	Mocha	Usage
      -- rosewater	#dc8a78	#F2D5CF	#F4DBD6	#F5E0DC	Winbar
      -- flamingo	#DD7878	#EEBEBE	#F0C6C6	#F2CDCD	Target word
      -- pink	#ea76cb	#F4B8E4	#F5BDE6	#F5C2E7	Just pink
      -- mauve	#8839EF	#CA9EE6	#C6A0F6	#CBA6F7	Tag
      -- red	#D20F39	#E78284	#ED8796	#F38BA8	Error
      -- maroon	#E64553	#EA999C	#EE99A0	#EBA0AC	Lighter red
      -- peach	#FE640B	#EF9F76	#F5A97F	#FAB387	Number
      -- yellow	#df8e1d	#E5C890	#EED49F	#F9E2AF	Warning
      -- green	#40A02B	#A6D189	#A6DA95	#A6E3A1	Diff add
      -- teal	#179299	#81C8BE	#8BD5CA	#94E2D5	Hint
      -- sky	#04A5E5	#99D1DB	#91D7E3	#89DCEB	Operator
      -- sapphire	#209FB5	#85C1DC	#7DC4E4	#74C7EC	Constructor
      -- blue	#1e66f5	#8CAAEE	#8AADF4	#89B4FA	Diff changed
      -- lavender	#7287FD	#BABBF1	#B7BDF8	#B4BEFE	CursorLine Nr
      -- text	#4C4F69	#c6d0f5	#CAD3F5	#CDD6F4	Default fg
      -- subtext1	#5C5F77	#b5bfe2	#B8C0E0	#BAC2DE	Indicator
      -- subtext0	#6C6F85	#a5adce	#A5ADCB	#A6ADC8	Float title
      -- overlay2	#7C7F93	#949cbb	#939AB7	#9399B2	Popup fg
      -- overlay1	#8C8FA1	#838ba7	#8087A2	#7F849C	Conceal color
      -- overlay0	#9CA0B0	#737994	#6E738D	#6C7086	Fold color
      -- surface2	#ACB0BE	#626880	#5B6078	#585B70	Default comment
      -- surface1	#BCC0CC	#51576d	#494D64	#45475A	Darker comment
      -- surface0	#CCD0DA	#414559	#363A4F	#313244	Darkest comment
      -- base	#EFF1F5	#303446	#24273A	#1E1E2E	Default bg
      -- mantle	#E6E9EF	#292C3C	#1E2030	#181825	Darker bg
      -- crust	#DCE0E8	#232634	#181926	#11111B	Darkest bg

      -- Tokyo night

      -- M.default = {
      --   none = "NONE",
      --   bg_dark = "#1f2335",
      --   bg = "#24283b",
      --   bg_highlight = "#292e42",
      --   terminal_black = "#414868",
      --   fg = "#c0caf5",
      --   fg_dark = "#a9b1d6",
      --   fg_gutter = "#3b4261",
      --   dark3 = "#545c7e",
      --   comment = "#565f89",
      --   dark5 = "#737aa2",
      --   blue0 = "#3d59a1",
      --   blue = "#7aa2f7",
      --   cyan = "#7dcfff",
      --   blue1 = "#2ac3de",
      --   blue2 = "#0db9d7",
      --   blue5 = "#89ddff",
      --   blue6 = "#b4f9f8",
      --   blue7 = "#394b70",
      --   magenta = "#bb9af7",
      --   magenta2 = "#ff007c",
      --   purple = "#9d7cd8",
      --   orange = "#ff9e64",
      --   yellow = "#e0af68",
      --   green = "#9ece6a",
      --   green1 = "#73daca",
      --   green2 = "#41a6b5",
      --   teal = "#1abc9c",
      --   red = "#f7768e",
      --   red1 = "#db4b4b",
      --   git = { change = "#6183bb", add = "#449dab", delete = "#914c54" },
      --   gitSigns = {
      --     add = "#266d6a",
      --     change = "#536c9e",
      --     delete = "#b2555b",
      --   },
      -- }
      --

      vim.g.terminal_color_0 = "#a3a7bc"
      vim.g.terminal_color_1 = "#F38BA8"
      vim.g.terminal_color_2 = "#94E2D5"
      vim.g.terminal_color_3 = "#F9E2AF"
      vim.g.terminal_color_4 = "#B4BEFE"
      vim.g.terminal_color_5 = "#CA9EE6"
      vim.g.terminal_color_6 = "#89DCEB"
      vim.g.terminal_color_7 = "#a3a7bc"
      vim.g.terminal_color_8 = "#a3a7bc"
      vim.g.terminal_color_9 = "#F38BA8"
      vim.g.terminal_color_10 = "#94E2D5"
      vim.g.terminal_color_11 = "#F9E2AF"
      vim.g.terminal_color_12 = "#89DCEB"
      vim.g.terminal_color_13 = "#F2CDCD"
      vim.g.terminal_color_14 = "#89DCEB"
      vim.g.terminal_color_15 = "#a3a7bc"

      vim.cmd([[
let g:fzf_colors =
\ { 'fg':      ['fg', 'Visual'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'TelescopeMatching'],
  \ 'fg+':     ['fg', 'Normal', 'Normal', 'Normal'],
  \ 'bg+':     ['bg', 'Normal', 'Normal'],
  \ 'hl+':     ['fg', 'TelescopeMatching'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
]])

      --     vim.cmd [[
      -- let g:fzf_colors =
      -- \ { 'fg':      ['fg', 'Visual'],
      --   \ 'bg':      ['bg', 'Normal'],
      --   \ 'hl':      ['fg', 'TelescopeMatching'],
      --   \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      --   \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      --   \ 'hl+':     ['fg', 'TelescopeMatching'],
      --   \ 'info':    ['fg', 'PreProc'],
      --   \ 'border':  ['fg', 'Ignore'],
      --   \ 'prompt':  ['fg', 'Conditional'],
      --   \ 'pointer': ['fg', 'Exception'],
      --   \ 'marker':  ['fg', 'Keyword'],
      --   \ 'spinner': ['fg', 'Label'],
      --   \ 'header':  ['fg', 'Comment'] }
      -- ]]

      vim.cmd([[let g:fzf_checkout_view_mode = 'inline']])
      vim.cmd([[let g:fzf_checkout_git_options = "--format='%(color:#c0caf5)%(refname:short)'"]])
      vim.cmd([[let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-q': 'fill_quickfix'}]])
    end,
  },
}
