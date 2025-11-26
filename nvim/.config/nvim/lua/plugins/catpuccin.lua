-- return {}

return {
	{
		"catppuccin/nvim",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, or mocha
				transparent_background = true,
				auto_integrations = true,
				color_overrides = {
					all = {
						yellow = "#89ddff",
						green = "#94E2D5",
						maroon = "#FAB387",
					},
				},
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
					symbols_outline = true,
					lsp_trouble = true,
					neotree = true,
					octo = true,
					lsp_saga = true,
					mason = true,
					dap = true,
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
						-- remove bold from gui, use style = {}
						Boolean = { fg = "#F38BA8" },
						Number = { fg = "#F38BA8" },
						NormalFloat = { fg = "none", bg = "none" },
						GitHeader = { bg = "none" },
						GitFooter = { bg = "none" },
						GitAppBar = { bg = "none" },
						String = { fg = "#F2CDCD" },
						OverOldValue = { bg = "#F38BA8", fg = "black" },
						OverNewValue = { bg = "#94E2D5", fg = "black" },
						SnippetTabstop = { bg = "none" },
						["@module.hurl"] = { fg = "#89ddff", style = {} },
						["@keyword.ghactions"] = { fg = "#89ddff" },
						["@property.ghactions"] = { fg = "#cdd6f5" },
						["@module.builtin.ghactions"] = { fg = "#89ddff" },
						["@function.call.bash"] = { fg = "#C6A0F6", style = {} },
						["@function.builtin.bash"] = { fg = "#C6A0F6", style = {} },
						["@variable.parameter.bash"] = { fg = "#F5C2E7" },
						["@string.special.url.comment"] = { style = { "underline" } },
						fzf1 = { fg = "#737aa2", bg = "#292e42" },
						fzf2 = { fg = "#737aa2", bg = "#292e42" },
						fzf3 = { fg = "#737aa2", bg = "#292e42" },
						StatusLine = { fg = "#737aa2", bg = "#292e42" },
						DiffviewFolderName = { style = {}, fg = "#89B4FA" },
						NvimTreeStatusLine = { fg = "#737aa2", bg = "none" },
						NvimTreeStatusLineNC = { fg = "#737aa2", bg = "none" },
						MatchParen = { bg = "#394b70", fg = "#F5E0DC" },
						IlluminatedWordText = { bg = "#394b70" },
						IlluminatedWordRead = { bg = "#394b70" },
						IlluminatedWordWrite = { bg = "#394b70" },
						illuminatedCurWord = { bg = "#394b70" },
						Cursor = { bg = "#a9b1d6" },
						illuminatedWord = { bg = "#394b70" },
						RenderMarkdownCode = { bg = "#1f2335" },
						Folded = { bg = "#292e42" },
						LspInlayHint = { fg = "#737aa2" },
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
						NvimTreeCursorLine = { bg = "#3b4261" },
						NvimTreeGitStagedIcon = { fg = "#8ee2cf" },
						MatchupVirtualText = { fg = "#747ebd" },
						BlinkCmpGitKindCommit = { fg = "#8ee2cf" },
						BlinkCmpGitLabelCommitId = { fg = "#8ee2cf" },
						GitSignsCurrentLineBlame = { fg = "#B4BEFE" },
						FloatBorder = { fg = "#394b70" },
						FloatTitle = { fg = "#394b70", bg = "none" },
						BlinkCmpKindSnippet = { fg = "#747ebd" },
						BlinkCmpKindVariable = { fg = "#F5C2E7" },
						BlinkCmpMenuBorder = { fg = "#394b70" },
						AvanteSidebarWinSeparator = { fg = "#394b70" },
						NvimTreeSpecialFile = { fg = "#CDD6F4" },
						AvanteTaskCompleted = { fg = "#8ee2cf" },
						AvanteStateSpinnerSucceeded = { bg = "#8ee2cf", fg = "black" },
						octo_mb_b60205 = { fg = "#ffffff", bg = "#F5C2E7" },
						octo_mf_b60205 = { fg = "#F5C2E7" },
						octo_mb_4493f8 = { fg = "#ffffff", bg = "#394b70" },
						octo_mf_4493f8 = { fg = "#394b70" },
						BlinkCmpMenuSelection = { bg = "#394b70", style = {} },
						LspReferenceText = { bg = "#264f78" },
						BlinkCmpDocBorder = { fg = "#394b70" },
						BlinkCmpSignatureHelpBorder = { fg = "#394b70" },
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
						AvanteTitle = { bg = "#94E2D5", fg = "#1e222a" },
						AvanteReversedTitle = { fg = "#94E2D5" },
						AvanteThirdTitle = { bg = "#F2CDCD", fg = "#1e222a" },
						AvanteReversedThirdTitle = { fg = "#F2CDCD" },
						gitcommitOverflow = { style = {} },
						AvanteConflictIncoming = { style = {}, bg = "#103235" },
						AvanteConflictCurrent = { style = {}, fg = "#394b70" },
						LineNR = { style = {}, fg = "#3b4261" },
						CursorLineNR = { style = {}, fg = "#737aa2" },
						["@lsp.typemod.method.defaultLibrary.typescript"] = { link = "Function" },
						TelescopePathSeparator = { link = "TelescopeNormal" },
						TreesitterContext = { link = "Function" },
						IndentBlanklineChar = { fg = "#3b4251" },
						IndentBlanklineContextChar = { fg = "#737aa2" },
						RenderMarkdownH1 = { fg = "#F5C2E7" },
						RenderMarkdownH2 = { fg = "#89ddff" },
						RenderMarkdownH3 = { fg = "#94E2D5" },
						RenderMarkdownH4 = { fg = "#B4BEFE" },
						RenderMarkdownH1Bg = { bg = "#492a33" },
						RenderMarkdownH2Bg = { bg = "#528599" },
						RenderMarkdownH3Bg = { bg = "#675161" },
						RenderMarkdownH4Bg = { bg = "#526c96" },
						RenderMarkdownH5Bg = { bg = "#6c7298" },
						RenderMarkdownH6Bg = { bg = "#36394d" },
						DiffviewFilePanelSelected = { bg = "#394b70", fg = "none" },
						DevIconBash = { fg = "#94E2D5", style = {} },
						RenderMarkdownCodeInline = { bg = "#0F2745", fg = "#94E2D5" },
						RenderMarkdown_Inverse_RenderMarkdownCode = { fg = "#394b70" },
						RenderMarkdown_DevIconBash_RenderMarkdownSign = { fg = "#94E2D5" },
						["@ibl.scope.underline.1"] = { sp = "#737aa2" },
						DevIconJsonc = { fg = "#F5C2E7" },
						["@ibl.indent.char.1"] = { fg = "#3b4251" },
						["@ibl.whitespace.char.1"] = { fg = "#3b4251" },
						["@ibl.scope.char.1"] = { fg = "#737aa2" },
						IblIndent = { fg = "#3b4251" },
						IblScope = { fg = "#737aa2" },
						HarpoonBorder = { fg = "#394b70" },
						TSRainbowRed = { fg = "#74C7EC" },
						TSRainbowYellow = { fg = "#C6A0F6" },
						TSRainbowBlue = { fg = "#89B4FA" },
						TSRainbowOrange = { fg = "#74C7EC" },
						TSRainbowGreen = { fg = "#C6A0F6" },
						TSRainbowViolet = { fg = "#89B4FA" },
						TSRainbowCyan = { fg = "#74C7EC" },
						["@markup.strong"] = { style = { "bold" }, fg = "#F5C2E7" },
						["@markup.heading"] = { style = {}, fg = "#89B4FA" },
						["@markup.heading.gitcommit"] = { style = {}, fg = "#89B4FA" },
						gitcommitSummary = { style = {}, fg = "#f5e0dd" },

						GitSignsAdd = { fg = "#30969f" },
						GitSignsChange = { fg = "#F2CDCD" },
						GitSignsChangeInLine = { fg = "#F2CDCD" },
						GitSignsDelete = { fg = "#F38BA8" },
						GitSignsDeleteVirtLn = { bg = "#3F2D3D", fg = "none" },
						GitSignsStagedAddLn = { bg = "#103235" },
						GitSignsStagedUntrackedLn = { bg = "#103235" },
						GitSignsStagedAddCul = { fg = "#94E2D5" },
						GitSignsStagedUntracked = { fg = "#94E2D5" },
						GitSignsStagedAdd = { fg = "#94E2D5" },
						GitSignsStagedUntrackedNr = { fg = "#94E2D5" },
						GitSignsStagedUntrackedCul = { fg = "#94E2D5" },
						GitSignsStagedAddNr = { fg = "#94E2D5" },
						GitSignsStagedDelete = { fg = "#F38BA8" },
						GitSignsStagedTopdelete = { fg = "#F38BA8" },
						GitSignsStagedDeleteNr = { fg = "#F38BA8" },
						GitSignsStagedTopdeleteNr = { fg = "#F38BA8" },
						GitSignsStagedDeleteCul = { fg = "#F38BA8" },
						GitSignsStagedTopdeleteCul = { fg = "#F38BA8" },
						GitSignsStagedChangeLn = { bg = "#272d43" },
						GitSignsStagedChangedeleteLn = { bg = "#272d43" },
						GitSignsStagedTopdeleteLn = { bg = "#3f2d3d" },
						GitSignsStagedChangeNr = { fg = "#F2CDCD" },
						GitSignsStagedChangedeleteNr = { fg = "#F2CDCD" },
						GitSignsStagedChangeCul = { fg = "#F2CDCD" },
						GitSignsStagedChangedeleteCul = { fg = "#F2CDCD" },
						GitSignsStagedChange = { fg = "#F2CDCD" },
						GitSignsStagedChangedelete = { fg = "#F2CDCD" },
						DiagnosticUnderlineWarn = { style = { "undercurl" }, sp = "#F5E0DC" },
						DiagnosticUnderlineHint = { style = { "underline" }, sp = "#89ddff" },
						DiagnosticUnderlineInfo = { style = { "undercurl" }, sp = "#89B4FA" },
						DiagnosticUnderlineError = { style = { "undercurl" }, sp = "#f38bad" },
						DiffviewFilePanelRootPath = { fg = "#B4BEFE" },
						DiffviewFilePanelTitle = { fg = "#B4BEFE" },
						DiffviewFilePanelCounter = { fg = "#89B4FA" },
						TelescopeSelection = { bg = "#394b70", fg = "none", style = {} },
						TelescopePreviewLine = { bg = "#394b70", style = {} },
						CmpPmenu = { bg = "none" },
						CmpPmenuBorder = { fg = "#394b70" },
						SubstituteSubstituted = { link = "Visual" },
						DapUIPlayPauseNC = { link = "DapUIPlayPause" },
						DapUIRestartNC = { link = "DapUIRestart" },
						DapUIStopNC = { link = "DapUIStop" },
						DapUIStepOverNC = { link = "DapUIStepOver" },
						DapUIStepIntoNC = { link = "DapUIStepInto" },
						DapUIStepBackNC = { link = "DapUIStepBack" },
						DapUIStepOutNC = { link = "DapUIStepOut" },
            HimalayaSender = { fg = "#B4BEFE" },
            HimalayaUnseen = { fg = "#89ddff" },
            HimalayaDate = { fg = "#F5C2E7" }
					}
				end,
			})

			-- setup must be called before loading
			vim.cmd.colorscheme("catppuccin")

			vim.cmd([[hi CmpItemKindField guifg=#f38ba9]])
			vim.cmd([[hi! PmenuSel guibg=#394b70 gui=none]])
			vim.cmd([[hi DiffAdd gui=none guifg=none guibg=#103235]])
			vim.cmd([[hi DiffChange gui=none guifg=none guibg=#103235]])
			vim.cmd([[hi DiffText gui=none guifg=none guibg=#456f80]])
			vim.cmd([[hi DiffDelete gui=none guifg=none guibg=#3F2D3D]])
			vim.cmd([[hi DiffviewDiffAddAsDelete guibg=#3f2d3d gui=none guifg=none]])
			vim.cmd([[hi DiffviewDiffDelete gui=none guifg=#3B4252 guibg=none]])
			vim.cmd([[hi diffAdded gui=none guifg=none guibg=#103235]])
			vim.cmd([[hi diffRemoved gui=none guifg=none guibg=#3F2D3D]])
			vim.cmd([[hi DiffviewStatusDeleted gui=none guifg=#f38bad guibg=none]])
			vim.cmd([[hi DiffviewStatusModified gui=none guifg=#89b4fa guibg=none]])
			vim.cmd([[hi DiffviewStatusAdded gui=none guifg=#1abc9c guibg=none]])
			vim.cmd([[hi DiffviewStatusUntracked gui=none guifg=#1abc9c guibg=none]])
			vim.cmd([[hi DiffviewFilePanelInsertions gui=none guifg=#1abc9c guibg=none]])
			vim.cmd([[hi DiffviewFilePanelDeletions gui=none guifg=#f38bad guibg=none]])
			vim.cmd([[hi DiffAddAsDelete gui=none guifg=none guibg=#3F2D3D]])
			vim.cmd([[hi DiffDeleteText gui=none guifg=none guibg=#7b3038]])
			vim.cmd([[hi DiffAddText gui=none guifg=none guibg=#456f80]])
			vim.cmd([[hi GitSignsAddPreview gui=none guifg=none guibg=#103235]])
			vim.cmd([[hi GitSignsDeletePreview gui=none guifg=none guibg=#3F2D3D]])
			vim.cmd([[hi BufferLineTabSeparator gui=none guifg=#13182e]])
			vim.cmd([[hi BufferLineTabSeparatorSelected gui=none guifg=#13182e]])
			vim.cmd([[hi BufferLineTabSelected gui=none guibg=#394b70]])
			vim.cmd([[hi InclineNormal  guibg=#292e42]])
			vim.cmd([[hi InclineNormalNC  guibg=#292e42 guifg=#7C7F93]])
			vim.cmd([[hi Winbar guifg=#bbc2e0]])
			vim.cmd([[hi WinbarNC guifg=#7C7F93]])
			vim.cmd([[hi TreesitterContextLineNumber guibg=#00122e guifg=#737aa2]])
			vim.cmd([[hi TreesitterContext guifg=none guibg=none]])
			vim.cmd([[hi WinSeparator guifg=#292e42 ]])
			vim.cmd([[hi NvimTreeFolderIcon guifg=#89B4FA]])
			vim.cmd([[hi NvimTreeFolderArrowClosed guifg=#89B4FA]])
			vim.cmd([[hi NvimTreeFolderArrowOpen guifg=#89B4FA]])
			vim.cmd([[hi NvimTreeWinSeparator guifg=#292e42]])
			vim.cmd([[hi NvimTreeIndentMarker guifg=#292e42]])
			vim.cmd([[hi BufferLineOffsetSeparator guifg=#292e42]])
			vim.cmd([[hi TelescopeBorder guifg=#394b70]])
			vim.cmd([[hi DiagnosticWarn guifg=#F9E2AF]])
			vim.cmd([[hi DiagnosticFloatingWarn guifg=#F9E2AF]])
			vim.cmd([[hi DiagnosticSignWarn guifg=#F9E2AF]])
			vim.cmd([[hi DiagnosticError guifg=#F38BA8]])
			vim.cmd([[hi DiagnosticSignError guifg=#F38BA8]])
			vim.cmd([[hi TroublePreview guibg=#264F78 guifg=none]])
			vim.cmd([[hi TroubleFileName guifg=#F5C2E7 guibg=none]])
			vim.cmd([[hi DiagnosticHint guifg=#89DCEB]])
			vim.cmd([[hi DiagnosticFloatingHint guifg=#89DCEB]])
			vim.cmd([[hi DiagnosticSignHint guifg=#89DCEB]])
			vim.cmd([[hi Visual gui=none cterm=none guibg=#264F78]])
			vim.cmd([[hi DiffviewFilePanelFileName guifg=#c0caf5]])
			vim.cmd([[hi @tag guifg=#9CDCFE]])
			vim.cmd([[hi @tag.delimiter.angular guifg=#9CDCFE]])
			vim.cmd([[hi @tag.delimiter guifg=#9CDCFE]])
			vim.cmd([[hi @tag.attribute guifg=#B4BEFE]])
			vim.cmd([[hi Error gui=none guifg=#F38BA8]])
			vim.cmd([[hi ErrorMsg gui=none guifg=#F38BA8]])
			vim.cmd([[hi TreesitterContextBottom guifg=none gui=none]])
			vim.cmd([[hi @property.class.scss guifg=#74C7EC]])
			vim.cmd([[hi @lsp.type.type guifg=#89ddff]])
			vim.cmd([[hi @lsp.type.interface guifg=#89ddff]])
			vim.cmd([[hi @attribute.typescript guifg=#89ddff]])
			vim.cmd([[hi @variable.member.lua guifg=#B4BEFE]])
			vim.cmd([[hi @variable.member guifg=#B4BEFE]])
			vim.cmd([[hi @variable guifg=#CAD3F5]])
			vim.cmd([[hi @variable.angular guifg=#B4BEFE]])
			vim.cmd([[hi LspSignatureActiveParameter gui=none guifg=none guibg=#264F78]])
			vim.cmd([[hi SignatureActiveParameter gui=none guifg=none guibg=#264F78]])
			vim.cmd([[hi WarningMsg guifg=#F2CDCD]])
			vim.cmd([[hi DiagnosticUnnecessary guibg=none guifg=none gui=italic,undercurl guisp=#949cbb]])
			vim.cmd([[hi CopilotSuggestion gui=none]])
			vim.cmd([[hi @keyword  gui=bold guifg=#CBA6F7]])
			vim.cmd([[hi @keyword.return  gui=bold]])
			vim.cmd([[hi @keyword.operator  gui=bold]])
			vim.cmd([[hi @keyword.exception  gui=bold guifg=#F5C2E7]])
			vim.cmd([[hi @keyword.jsdoc  gui=none guifg=#CBA6F7]])
			vim.cmd([[hi Constant gui=none cterm=none guibg=none blend=0]])
			vim.cmd([[hi Title gui=none cterm=none guibg=none blend=0]])
			vim.cmd([[hi NonText gui=none cterm=none guibg=none blend=0]])
			vim.cmd([[hi VertSplit  guifg=#292e42]])
			vim.cmd([[hi FloatBorder  guifg=#394b70 guibg=none]])
			vim.cmd([[hi SagaBorder  guifg=#394b70]])
			vim.cmd([[hi SagaTitle  guifg=#394b70]])
			vim.cmd([[hi ctrlsfMatch guifg=#F2CDCD guibg=#394b70]])
			vim.cmd([[hi jsonKeyword guifg=#b4beff ]])
			vim.cmd([[hi @property.json guifg=#b4beff ]])
			vim.cmd([[hi @property.jsonc guifg=#b4beff ]])
			vim.cmd([[hi @property guifg=#b4beff ]])
			vim.cmd([[hi @text.uri gui=none]])
			vim.cmd([[hi QuickFixLine gui=none guibg=#264F78]])
			vim.cmd([[hi QuickFixLineNr gui=none guifg=#747ebd]])
			vim.cmd([[hi TabLine guibg=none]])
			vim.cmd([[hi TabLineSel guibg=none]])
			vim.cmd([[hi DiagnosticVirtualTextWarn guifg=#DCDCAA guibg=#233745]])
			vim.cmd([[hi DiagnosticVirtualTextInfo guifg=#2ac3de guibg=#192b38]])
			vim.cmd([[hi DiagnosticVirtualTextError guifg=#db4b4b guibg=#362c3d]])
			vim.cmd([[hi DiagnosticVirtualTextHint guifg=#89DCEB guibg=#233745]])
			vim.cmd([[hi EndOfBuffer guifg=#737aa2]])
			vim.cmd([[hi DiagnosticVirtualTextWarnLine guifg=#DCDCAA guibg=#292e42]])
			vim.cmd([[hi DiagnosticVirtualTextInfoLine guifg=#2ac3de guibg=#292e42]])
			vim.cmd([[hi DiagnosticVirtualTextErrorLine guifg=#db4b4b guibg=#292e42]])
			vim.cmd([[hi DiagnosticVirtualTextHintLine guifg=#89DCEB guibg=#292e42]])
			vim.cmd([[hi DiagnosticUnderlineHint gui=undercurl]])
			vim.cmd([[hi barbecue_modified guifg=#737aa2]])
			vim.cmd([[hi NvimTreeFolderIcon guifg=#89B4FA]])
			vim.cmd([[hi NvimTreeRootFolder gui=none]])
			vim.cmd([[hi NvimTreeGitDirty guifg=#F5E0DC]])
			vim.cmd([[hi NvimTreeGitStaged guifg=#8ee2cf]])
			vim.cmd([[hi NvimTreeExecFile gui=none guifg=#F5C2E7]])
			vim.cmd([[hi NvimTreeModifiedFile gui=none guifg=#EFF1F5]])
			vim.cmd([[hi NvimTreeGitNew guifg=#89ddff]])
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

			vim.g.terminal_color_0 = "#1E1E2E"
			vim.g.terminal_color_8 = "#585B70"

			vim.g.terminal_color_1 = "#F38BA8"
			vim.g.terminal_color_9 = "#F5C2E7"

			vim.g.terminal_color_2 = "#94E2D5"
			vim.g.terminal_color_10 = "#94E2D5"

			vim.g.terminal_color_3 = "#F5E0DC"
			vim.g.terminal_color_11 = "#F5E0DC"

			vim.g.terminal_color_4 = "#B4BEFE"
			vim.g.terminal_color_12 = "#89B4FA"

			vim.g.terminal_color_5 = "#CA9EE6"
			vim.g.terminal_color_13 = "#F2CDCD"

			vim.g.terminal_color_6 = "#89DCEB"
			vim.g.terminal_color_14 = "#89DCEB"

			vim.g.terminal_color_7 = "#BAC2DE"
			vim.g.terminal_color_15 = "#7C7F93"

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
