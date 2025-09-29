-- return {}
return {
	keys = {
		{
			"<M-f>",
			mode = { "n", "i", "v" },
			function()
				require("grug-far").toggle_instance({
					instanceName = "far",
					staticTitle = "Find and Replace",
					-- prefills = { flags = "-i -w" },
				})
			end,
		},
	},
	cmd = { "GrugFar" },
	"MagicDuck/grug-far.nvim",
	config = function()
		require("grug-far").setup({
      debounceMs = 200,
      engines = {
        ripgrep = {
          defaults = {
            search = nil,
            replacement = nil,
            filesFilter = "" ,
            flags = "-i -w -g !**__template__** -g !**migrations** -g !**spec**",
            paths = nil,
          },
        }
      },
			startInInsertMode = false,
			-- shortcuts for the actions you see at the top of the buffer
			-- set to '' or false to unset. Mappings with no normal mode value will be removed from the help header
			-- you can specify either a string which is then used as the mapping for both normal and insert mode
			-- or you can specify a table of the form { [mode] = <lhs> } (ex: { i = '<C-enter>', n = '<localleader>gr'})
			-- it is recommended to use <localleader> though as that is more vim-ish
			-- see https://learnvimscriptthehardway.stevelosh.com/chapters/11.html#local-leader
			keymaps = {
				replace = { n = "<localleader>r" },
				qflist = { n = "<localleader>q" },
				syncLocations = { n = "<localleader>s" },
				syncLine = { n = "<localleader>l" },
				close = { n = "<localleader>c" },
				historyOpen = { n = "<localleader>t" },
				historyAdd = { n = "<localleader>a" },
				refresh = { n = "<localleader>f" },
				openLocation = { n = "<localleader>o" },
				openNextLocation = { n = "<down>" },
				openPrevLocation = { n = "<up>" },
				gotoLocation = { n = "<enter>" },
				pickHistoryEntry = { n = "<enter>" },
				abort = { n = "<localleader>b" },
				help = { n = "g?" },
				toggleShowCommand = { n = "<localleader>w" },
				swapEngine = { n = "<localleader>e" },
				previewLocation = { n = "<bs>" },
				swapReplacementInterpreter = { n = "<localleader>x" },
				applyNext = { n = "<localleader>j" },
				applyPrev = { n = "<localleader>k" },
				syncNext = { n = "<localleader>n" },
				syncPrev = { n = "<localleader>p" },
				syncFile = { n = "<localleader>v" },
				nextInput = { n = "<tab>" },
				prevInput = { n = "<s-tab>" },
			},
      folding = {
        -- whether to enable folding
        enabled = true,

        -- sets foldlevel, folds with higher level will be closed.
        -- result matche lines for each file have fold level 1
        -- set it to 0 if you would like to have the results initially collapsed
        -- See :h foldlevel
        foldlevel = 1,

        -- visual indicator of folds, see :h foldcolumn
        -- set to '0' to disable
        foldcolumn = '1',

        -- whether to include file path in the fold, by default, only lines under the file path are included
        include_file_path = true,
      },
			wrap = false,
      helpLine = {
        enabled = false,
      },
      showInputsTopPadding = false,
      showInputsBottomPadding = true,
      showCompactInputs = false,
			resultsHighlight = true,
			resultLocation = {
				-- whether to show the result location number label
				-- this can be useful for example if you would like to use that number
				-- as a count to goto directly to a result
				-- (for instance `3<enter>` would goto the third result's location)
				showNumberLabel = false, -- position of the number when visible, acceptable values are:
				-- 'right_align', 'eol' and 'inline'
				numberLabelPosition = "right_align",

				-- format for the number label, by default it displays as for example:  [42]
				numberLabelFormat = " [%d]",
			},
		})
	end,
}
