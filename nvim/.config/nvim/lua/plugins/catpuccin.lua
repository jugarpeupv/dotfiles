-- return {}

return {
	{
		"catppuccin/nvim",
		-- dependencies = { "mg979/vim-visual-multi" },
		priority = 1000,
		-- lazy = true,

		-- event = "VeryLazy",
		--
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, or mocha
				transparent_background = true,
				color_overrides = {
					all = {
						-- surface0 = "#444444",
						-- surface1 = "#666666",
						-- surface2 = "#a3a7bc",
						-- surface3 = "#a3a7bc",
						yellow = "#89ddff",
						green = "#94E2D5",
						maroon = "#FAB387",
					},
				},
				-- integrations = {},
				integrations = {
					blink_cmp = true,
					gitgraph = true,
					neotest = true,
					render_markdown = true,
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
					octo = true,
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
				term_colors = true,
				-- term_colors = true,
				-- term_colors = false,
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
						Boolean = { fg = "#F38BA8" },
						Number = { fg = "#F38BA8" },
						NormalFloat = { fg = "none", bg = "none" },
						GitHeader = { bg = "none" },
						GitFooter = { bg = "none" },
						GitAppBar = { bg = "none" },
						String = { fg = "#F2CDCD" },
						["@module.hurl"] = { fg = "#89ddff", style = { } },
						["@keyword.ghactions"] = { fg = "#89ddff" },
						["@property.ghactions"] = { fg = "#cdd6f5" },
						["@module.builtin.ghactions"] = { fg = "#89ddff" },
						["@function.call.bash"] = { fg = "#C6A0F6", style = {} },
						["@function.builtin.bash"] = { fg = "#C6A0F6", style = {} },
						["@variable.parameter.bash"] = { fg = "#F5C2E7" },
            ["@string.special.url.comment"] = { style = { "underline" } },
						-- StatusLine = { fg = "#737aa2", bg = "#292e42" },
						fzf1 = { fg = "#737aa2", bg = "#292e42" },
						fzf2 = { fg = "#737aa2", bg = "#292e42" },
						fzf3 = { fg = "#737aa2", bg = "#292e42" },
						StatusLine = { fg = "#737aa2", bg = "#292e42" },
						-- NvimTreeStatusLine  = { fg = "#737aa2", bg = "#292e42" },
						-- NvimTreeStatusLineNC  = { fg = "#737aa2", bg = "#292e42" },
						NvimTreeStatusLine  = { fg = "#737aa2", bg = "none" },
						NvimTreeStatusLineNC  = { fg = "#737aa2", bg = "none" },
						MatchParen = { bg = "#394b70", fg = "#F5E0DC" },
						IlluminatedWordText = { bg = "#394b70" },
						IlluminatedWordRead = { bg = "#394b70" },
						IlluminatedWordWrite = { bg = "#394b70" },
						illuminatedCurWord = { bg = "#394b70" },
            Cursor  = { bg = "#a9b1d6" },
						illuminatedWord = { bg = "#394b70" },
						RenderMarkdownCode = { bg = "#1f2335" },
						-- Folded = { bg = "#1f2335", fg = "#737aa2" },
						-- Folded = { bg = "#292e42", fg = "#737aa2" },
						Folded = { bg = "#292e42" },
						-- LspInlayHint = { bg = "#0F2745", fg = "#737aa2" },
						LspInlayHint = { fg = "#737aa2" },
						-- Comment = { fg = "#737aa2" },
						NvimDapVirtualText = { fg = "#737aa2" },
						DapUIDecoration = { fg = "#89B4FA" },
						NvimTreeBookmark = { fg = "#f2cdcd" },
						HlSearchNear = { fg = "#181826", bg = "#F38BA8" },
						HlSearchLensNear = { fg = "#181826", bg = "#F38BA8" },
						GrugFarResultsMatch = { bg = "#394b70" },
						["@string.special.symbol.ruby"] = { fg = "#B4BEFE" },
						["@markup.heading.1.marker"] = { fg = "#F5C2E7" },
						["@markup.heading.1.markdown"] = { fg = "#F5C2E7" },
						["@markup.heading.2.markdown"] = { fg = "#89ddff" },
						["@markup.heading.3.markdown"] = { fg = "#94E2D5" },

						["@lsp.typemod.interface.defaultLibrary.typescript"] = { fg = "#F38BA8" },
						["@type.builtin.typescript"] = { fg = "#89ddfe" },
						["@string.special.url.html"] = { fg = "#F5C2E7", bg = "none", style = {} },
						["@markup.heading.4.markdown"] = { fg = "#B4BEFE" },
						Ignore = { fg = "#394b70" },
						NeotestPassed = { fg = "#8ee2cf" },
						["@property.scss"] = { fg = "#B4BEFE" },
						["@lsp.typemod.class.declaration.typescript"] = { fg = "#B4BEFE" },
						["@lsp.typemod.method.declaration.typescript"] = { fg = "#B4BEFE" },
						["@lsp.typemod.variable.readonly.typescript"] = { fg = "#CAD3F5" },
						EgrepifyFile = { fg = "#f2cdcd" },
						EgrepifyLnum = { fg = "#737aa2" },
						CursorLine = { bg = "#3b4261" },
						["@property.yaml"] = { fg = "#B4BEFE" },
						-- CursorLine = { bg = "#2c3148" },
						NvimTreeCursorLine = { bg = "#3b4261" },
						NvimTreeGitStagedIcon = { fg = "#8ee2cf" },
						-- MatchupVirtualText = { fg = "#6C7086" }
						MatchupVirtualText = { fg = "#747ebd" },
						-- GitSignsCurrentLineBlame = { fg = "#747ebd" },
						-- GitSignsCurrentLineBlame = { fg = "#0f1219" },
						GitSignsCurrentLineBlame = { fg = "#B4BEFE" },
						FloatBorder = { fg = "#394b70" },
						FloatTitle = { fg = "#394b70", bg = "none" },
						BlinkCmpKindSnippet = { fg = "#747ebd" },
						-- BlinkCmpKindVariable = { fg = "#CDD6F4" },
						BlinkCmpKindVariable = { fg = "#F5C2E7" },
						BlinkCmpMenuBorder = { fg = "#394b70" },
						AvanteSidebarWinSeparator = { fg = "#394b70" },
						AvanteTaskCompleted = { fg = "#8ee2cf" },
						AvanteStateSpinnerSucceeded = { bg = "#8ee2cf", fg = "black" },
						-- remove bold from gui, use style = {}
						BlinkCmpMenuSelection = { bg = "#394b70", style = {} },
						LspReferenceText = { bg = "#264f78" },

						BlinkCmpDocBorder = { fg = "#394b70" },
						BlinkCmpSignatureHelpBorder = { fg = "#394b70" },

						-- VIRA
						viraTitles = { fg = "#F5E0DC" },
						["@lsp.type.enumMember.typescript"] = { fg = "#F5C2E7" },
						viraDetailsStatusInProgress = { fg = "#F38BA8" },
						viraDetailsEpic = { fg = "#F5C2E7" },
						viraDetailsTypeStory = { fg = "#8ee2cf" },
						viraDetails = { fg = "#89ddff" },
						viraDetailsDates = { fg = "#89ddff" },
						viraCommentAuthor = { fg = "#89ddff" },
						viraCommentDate = { fg = "#89ddff" },
						viraCommentOpen = { fg = "#89ddff" },
						viraIssuesDescription = { fg = "#F5C2E7" },
						viraIssuesIssue = { fg = "#89ddff" },
						viraIssuesUsername = { fg = "#8ee2cf" },
						viraIssuesStatus = { fg = "#F38BA8" },
						viraIssuesDates = { fg = "#B4BEFE" },

						-- Avante
						AvanteTitle = { bg = "#94E2D5", fg = "#1e222a" },
						AvanteReversedTitle = { fg = "#94E2D5" },

						AvanteThirdTitle = { bg = "#F2CDCD", fg = "#1e222a" },
						AvanteReversedThirdTitle = { fg = "#F2CDCD" },
					}
				end,
			})

			-- setup must be called before loading
			vim.cmd.colorscheme("catppuccin")
			vim.cmd([[hi gitcommitOverflow gui=none]])

			vim.cmd([[hi AvanteConflictIncoming gui=none guibg=#103235]])
			vim.cmd([[hi AvanteConflictCurrent gui=none guibg=#394b70]])
			vim.cmd([[highlight LineNR guifg=#3b4261]])
			vim.cmd([[highlight CursorLineNR guifg=#737aa2]])

			vim.cmd([[highlight IndentBlanklineChar guifg=#3b4251]])
			vim.cmd([[highlight IndentBlanklineContextChar guifg=#737aa2]])

			vim.api.nvim_set_hl(0, "@lsp.typemod.method.defaultLibrary.typescript", { link = "Function" })

			vim.api.nvim_set_hl(0, "TelescopePathSeparator", { link = "TelescopeNormal" })

			vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Function" })

			-- vim.cmd([[hi RenderMarkdownCode guibg=none guifg=none gui=none]])
			-- vim.cmd([[hi RenderMarkdownCode guibg=#1f2335]])
			-- vim.cmd([[hi RenderMarkdownCode guibg=none cterm=none gui=none ctermbg=none]])
			-- vim.cmd([[hi RenderMarkdownCode guibg=#00122e]])
			-- vim.cmd([[hi RenderMarkdownH3Bg guibg=#4a716b]])
			-- vim.cmd([[hi RenderMarkdownH4Bg guibg=#6c7298]])
			-- vim.cmd([[hi RenderMarkdownH2Bg guibg=#3A6477]])
			-- vim.cmd([[hi RenderMarkdownCode guibg=#03162f]])
			-- vim.cmd([[hi RenderMarkdownCode guibg=#16485A]])
			-- vim.cmd([[hi RenderMarkdownCode guibg=#0f3846]])

			vim.cmd([[hi RenderMarkdownH1 guifg=#F5C2E7]])
			vim.cmd([[hi RenderMarkdownH2 guifg=#89ddff]])
			vim.cmd([[hi RenderMarkdownH3 guifg=#94E2D5]])
			vim.cmd([[hi RenderMarkdownH4 guifg=#B4BEFE]])
			-- vim.cmd([[hi RenderMarkdownH5 guifg=#6c7298]])
			-- vim.cmd([[hi RenderMarkdownH6 guifg=#36394d]])

			vim.cmd([[hi DiffviewFilePanelSelected guibg=#394b70 ]])

			vim.cmd([[hi RenderMarkdownH1Bg guibg=#492a33]])
			vim.cmd([[hi RenderMarkdownH2Bg guibg=#528599]])
			vim.cmd([[hi RenderMarkdownH3Bg guibg=#675161]])
			vim.cmd([[hi RenderMarkdownH4Bg guibg=#526c96]])
			vim.cmd([[hi RenderMarkdownH5Bg guibg=#6c7298]])
			vim.cmd([[hi RenderMarkdownH6Bg guibg=#36394d]])

			-- vim.cmd([[hi RenderMarkdownCode guibg=#23233d]])
			-- vim.cmd([[hi RenderMarkdownCodeInline guibg=#0F2745 guifg=none]])
			vim.cmd([[hi RenderMarkdownCodeInline guibg=#0F2745 guifg=#94E2D5]])

			-- vim.cmd([[hi RenderMarkdownCode guibg=none]])
			-- vim.cmd([[hi RenderMarkdownCode guibg=#00122e]])
			-- vim.cmd([[hi RenderMarkdownCodeInline]])
			vim.cmd([[hi RenderMarkdown_Inverse_RenderMarkdownCode guifg=#394b70]])
			vim.cmd([[hi RenderMarkdown_DevIconBash_RenderMarkdownSign guifg=#94E2D5 gui=none]])
			vim.cmd([[hi DevIconBash guifg=#94E2D5 gui=none]])
			vim.cmd([[hi DevIconJsonc guifg=#F5C2E7 gui=none]])

			-- vim.cmd([[@ibl           xxx cleared]])
			vim.cmd([[highlight @ibl.indent.char.1  guifg=#3b4251]])
			vim.cmd([[highlight @ibl.whitespace.char.1 guifg=#3b4251]])
			vim.cmd([[highlight @ibl.scope.char.1 guifg=#737aa2]])
			vim.cmd([[highlight @ibl.scope.underline.1 guisp=#737aa2]])
			vim.cmd([[hi @markup.strong gui=bold guifg=#F5C2E7]])

			vim.cmd([[hi @markup.heading gui=none guifg=#89B4FA]])
			vim.cmd([[hi @markup.heading.gitcommit gui=none guifg=#89B4FA]])
			vim.cmd([[hi gitcommitSummary cterm=none gui=none guifg=#f5e0dd]])

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

			vim.cmd([[highlight DiagnosticUnderlineWarn gui=undercurl guisp=#F5E0DC]])
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

			vim.cmd([[hi CmpItemKindField guifg=#f38ba9]])
			vim.cmd([[highlight! PmenuSel guibg=#394b70 gui=none]])

			--- -------------------- COMMON

			vim.cmd([[highlight DiffAdd gui=none guifg=none guibg=#103235]])
			vim.cmd([[highlight DiffChange gui=none guifg=none guibg=#272D43]])
			-- vim.cmd([[highlight DiffText gui=none guifg=none guibg=#394b70]])

			vim.cmd([[highlight DiffText gui=none guifg=none guibg=#456f80]])
			vim.cmd([[highlight DiffDelete gui=none guifg=none guibg=#3F2D3D]])
			-- vim.cmd([[highlight DiffDelete guifg=#011528]])

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
			vim.cmd([[highlight DiffDeleteText gui=none guifg=none guibg=#7b3038]])

			-- Right panel
			-- "DiffChange:DiffAdd",
			-- "DiffText:DiffAddText",
			vim.cmd([[highlight DiffAddText gui=none guifg=none guibg=#456f80]])

			-- start Gitsigns
			vim.cmd([[highlight GitSignsAddPreview gui=none guifg=none guibg=#103235]])
			vim.cmd([[highlight GitSignsDeletePreview gui=none guifg=none guibg=#3F2D3D]])
			-- vim.cmd([[highlight GitSignsAdd guifg=#2ac3de]])
			vim.cmd([[highlight GitSignsAdd guifg=#30969f]])
			vim.cmd([[highlight GitSignsChange guifg=#F2CDCD]])
			vim.cmd([[highlight GitSignsChangeInLine guifg=#F2CDCD]])
			vim.cmd([[highlight GitSignsDelete guifg=#F38BA8]])
			vim.cmd([[highlight GitSignsDeleteVirtLn guibg=#3F2D3D guifg=none]])

			vim.cmd([[hi GitSignsStagedAddLn  guibg=#103235]])
			vim.cmd([[hi GitSignsStagedUntrackedLn  guibg=#103235]])
			vim.cmd([[hi GitSignsStagedAddCul  guifg=#94E2D5]])
			vim.cmd([[hi GitSignsStagedUntracked  guifg=#94E2D5]])
			vim.cmd([[hi GitSignsStagedAdd  guifg=#94E2D5]])
			vim.cmd([[hi GitSignsStagedUntrackedNr  guifg=#94E2D5]])
			vim.cmd([[hi GitSignsStagedUntrackedCul  guifg=#94E2D5]])
			vim.cmd([[hi GitSignsStagedAddNr  guifg=#94E2D5]])
			vim.cmd([[hi GitSignsStagedDelete  guifg=#F38BA8]])
			vim.cmd([[hi GitSignsStagedTopdelete  guifg=#F38BA8]])
			vim.cmd([[hi GitSignsStagedDeleteNr  guifg=#F38BA8]])
			vim.cmd([[hi GitSignsStagedTopdeleteNr  guifg=#F38BA8]])
			vim.cmd([[hi GitSignsStagedDeleteCul  guifg=#F38BA8]])
			vim.cmd([[hi GitSignsStagedTopdeleteCul  guifg=#F38BA8]])
			vim.cmd([[hi GitSignsStagedChangeLn  guibg=#272d43]])
			vim.cmd([[hi GitSignsStagedChangedeleteLn  guibg=#272d43]])
			vim.cmd([[hi GitSignsStagedTopdeleteLn  guibg=#3f2d3d]])
			vim.cmd([[hi GitSignsStagedChangeNr  guifg=#F2CDCD]])
			vim.cmd([[hi GitSignsStagedChangedeleteNr  guifg=#F2CDCD]])
			vim.cmd([[hi GitSignsStagedChangeCul  guifg=#F2CDCD]])
			vim.cmd([[hi GitSignsStagedChangedeleteCul  guifg=#F2CDCD]])
			vim.cmd([[hi GitSignsStagedChange  guifg=#F2CDCD]])
			vim.cmd([[hi GitSignsStagedChangedelete  guifg=#F2CDCD]])

			-- end Gitsigns

			vim.cmd([[highlight BufferLineTabSeparator gui=none guifg=#13182e]])
			vim.cmd([[highlight BufferLineTabSeparatorSelected gui=none guifg=#13182e]])
			vim.cmd([[highlight BufferLineTabSelected gui=none guibg=#394b70]])

			vim.cmd([[highlight InclineNormal  guibg=#292e42]])
			vim.cmd([[highlight InclineNormalNC  guibg=#292e42 guifg=#7C7F93]])
			vim.cmd([[highlight Winbar guifg=#bbc2e0]])
			vim.cmd([[highlight WinbarNC guifg=#7C7F93]])

			-- vim.cmd([[highlight TreesitterContextLineNumber guibg=#0F2745 guifg=#737aa2]])
			vim.cmd([[highlight TreesitterContextLineNumber guibg=#00122e guifg=#737aa2]])
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

			vim.cmd([[hi TroublePreview guibg=#264F78 guifg=none]])
			-- vim.cmd([[hi TroubleFileName guibg=#394b70 guifg=#0c0c0c]])
			vim.cmd([[hi TroubleFileName guifg=#F5C2E7 guibg=none]])

			vim.cmd([[highlight DiagnosticHint guifg=#89DCEB]])
			vim.cmd([[highlight DiagnosticFloatingHint guifg=#89DCEB]])
			vim.cmd([[highlight DiagnosticSignHint guifg=#89DCEB]])
			vim.cmd([[highlight Visual gui=none cterm=none guibg=#264F78]])
			-- vim.cmd([[hi DiffviewFilePanelFileName guifg=#B4BEFE]])
			vim.cmd([[hi DiffviewFilePanelFileName guifg=#c0caf5]])
			vim.cmd([[hi @tag guifg=#74C7EC]])
			vim.cmd([[hi @tag.delimiter.angular guifg=#74C7EC]])
			vim.cmd([[hi @tag.delimiter guifg=#74C7EC]])
			-- vim.cmd([[hi @tag guifg=#89ddfe]])
			-- vim.cmd([[hi @tag.delimiter.angular guifg=#89ddfe]])
			-- vim.cmd([[hi @tag.delimiter guifg=#89ddfe]])

			vim.cmd([[hi @tag.attribute guifg=#B4BEFE]])
			-- vim.cmd([[hi @tag guifg=#B4BEFE]])
			-- vim.cmd([[hi @label guifg=#B4BEFE]])
			vim.cmd([[hi Error gui=none guifg=#F38BA8]])
			vim.cmd([[hi ErrorMsg gui=none guifg=#F38BA8]])
			-- vim.cmd([[hi @property guifg=#CDD6F4]])
			vim.cmd([[hi TreesitterContextBottom guifg=none gui=none]])

			-- vim.cmd([[hi @property.scss guifg=#89ddff]])
			-- vim.cmd([[hi @property.class.scss guifg=#89ddff]])
			vim.cmd([[hi @property.class.scss guifg=#CBA6F7]])
			-- vim.cmd([[hi @parameter guifg=#B4BEFE]])

			vim.cmd([[highlight @lsp.type.type guifg=#89ddff]])
			vim.cmd([[highlight @lsp.type.interface guifg=#89ddff]])
			vim.cmd([[highlight @attribute.typescript guifg=#89ddff]])

			vim.cmd([[hi @variable.member.lua guifg=#B4BEFE]])
			vim.cmd([[hi @variable.member guifg=#B4BEFE]])
			vim.cmd([[hi @variable guifg=#CAD3F5]])
			vim.cmd([[hi @variable.angular guifg=#B4BEFE]])

			-- vim.cmd([[highlight @lsp.typemod.variable.defaultLibrary.typescript guifg=#89ddff]])
			-- vim.cmd([[highlight @variable.builtin guifg=#89ddff]])
			vim.cmd([[highlight LspSignatureActiveParameter gui=none guifg=none guibg=#264F78]])
			vim.cmd([[highlight SignatureActiveParameter gui=none guifg=none guibg=#264F78]])

			vim.cmd([[highlight WarningMsg guifg=#F2CDCD]])

			vim.cmd([[hi DiagnosticUnnecessary guibg=none guifg=none gui=italic,undercurl guisp=#949cbb]])
			vim.cmd([[highlight CopilotSuggestion gui=none]])

			vim.cmd([[highlight @keyword  gui=bold guifg=#CBA6F7]])
			vim.cmd([[highlight @keyword.return  gui=bold]])
			vim.cmd([[highlight @keyword.operator  gui=bold]])
			vim.cmd([[highlight @keyword.exception  gui=bold guifg=#F5C2E7]])
			vim.cmd([[highlight @keyword.jsdoc  gui=none guifg=#CBA6F7]])

			vim.cmd([[highlight Constant gui=none cterm=none guibg=none blend=0]])
			vim.cmd([[highlight Title gui=none cterm=none guibg=none blend=0]])
			vim.cmd([[highlight NonText gui=none cterm=none guibg=none blend=0]])

			vim.cmd([[highlight VertSplit  guifg=#292e42]])
			vim.cmd([[highlight FloatBorder  guifg=#394b70 guibg=none]])
			vim.cmd([[highlight SagaBorder  guifg=#394b70]])
			vim.cmd([[highlight SagaTitle  guifg=#394b70]])
			vim.cmd([[highlight ctrlsfMatch guifg=#F2CDCD guibg=#394b70]])

			vim.cmd([[highlight jsonKeyword guifg=#b4beff ]])

			vim.cmd([[highlight @property.json guifg=#b4beff ]])
			vim.cmd([[highlight @property.jsonc guifg=#b4beff ]])
			vim.cmd([[highlight @property guifg=#b4beff ]])
			-- @property      xxx guifg=#b4beff

			vim.cmd([[highlight @text.uri gui=none]])

			vim.cmd([[highlight QuickFixLine gui=none guibg=#264F78]])
			vim.cmd([[highlight QuickFixLineNr gui=none guifg=#747ebd]])

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
			-- vim.cmd([[hi barbecue_modified guifg=#bbc2e0]])
			vim.cmd([[hi barbecue_modified guifg=#737aa2]])
			-- vim.cmd([[hi barbecue_modified guifg=red]])

			vim.cmd([[hi NvimTreeFolderIcon guifg=#89B4FA]])
			vim.cmd([[hi NvimTreeRootFolder gui=none]])
			vim.cmd([[highlight NvimTreeGitDirty guifg=#F5E0DC]])
			vim.cmd([[highlight NvimTreeGitStaged guifg=#8ee2cf]])
			vim.cmd([[highlight NvimTreeExecFile gui=none guifg=#F5C2E7]])
			-- vim.cmd([[highlight NvimTreeExecFile gui=none guifg=#F38BA8]])
			-- vim.cmd([[highlight NvimTreeModifiedFile gui=none guifg=#737aa2]])
			-- vim.cmd([[highlight NvimTreeModifiedFile gui=none guifg=#c0caf5]])

			vim.cmd([[highlight NvimTreeModifiedFile gui=none guifg=#EFF1F5]])
			vim.cmd([[highlight NvimTreeGitNew guifg=#89ddff]])
			-- vim.cmd([[hi @markup.raw guifg=#F5E0DC]])
			vim.cmd([[hi @markup.raw guifg=#CDD6F4]])
			vim.cmd([[hi ContextVt guifg=#747ebd]])

			vim.cmd([[hi GitConflictIncoming gui=none guibg=#1a3754]])
			vim.cmd([[hi GitConflictCurrent gui=none guibg=#103235]])
			vim.cmd([[hi GitConflictMiddle guibg=none guifg=#c0caf5]])

			vim.cmd([[hi GitConflictIncomingLabel guibg=#394b70]])
			vim.cmd([[hi GitConflictIncomingMark guibg=#394b70]])
			vim.cmd([[hi GitConflictCurrentMark guibg=#104235]])

			vim.cmd([[hi GitHeader guibg=none]])
			vim.cmd([[hi GitFooter guibg=none]])
			vim.cmd([[hi GitAppBar guibg=none]])
			vim.cmd([[hi NormalFloat guibg=none]])
			-- vim.cmd([[hi @none guifg=#7384a4]])

			vim.api.nvim_set_hl(0, "SubstituteSubstituted", { link = "Visual" })

			-- Name	Latte	Frappe	Macchiato	Mocha	Usage
			-- rosewater	#dc8a78	#F2D5CF	#F4DBD6	#F5E0DC	Winbar
			-- flamingo	#DD7878	#EEBEBE	#F0C6C6	#F2CDCD	Target word
			-- pink	#ea76cb	#F4B8E4	#F5BDE6	#F5C2E7	Just pink
			-- mauve	#8839EF	#CA9EE6	#C6A0F6	#CBA6F7	Tag
			-- red	#D20F39	#E78284	#ED8796	#F38BA8	Error
			-- maroon	#E64553	#EA999C	#EE99A0	#EBA0AC	Lighter red
			-- peach	#FE640B	#EF9F76	#F5A97F	#FAB387	Number
			-- yellow	#df8e1d	#E5C890	#EED49F	#F5E0DC	Warning
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
			vim.g.terminal_color_3 = "#F5E0DC"
			vim.g.terminal_color_4 = "#B4BEFE"
			vim.g.terminal_color_5 = "#CA9EE6"
			vim.g.terminal_color_6 = "#89DCEB"
			vim.g.terminal_color_7 = "#a3a7bc"
			vim.g.terminal_color_8 = "#a3a7bc"
			vim.g.terminal_color_9 = "#F5C2E7"
			vim.g.terminal_color_10 = "#94E2D5"
			vim.g.terminal_color_11 = "#F5E0DC"
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
