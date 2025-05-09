return {
	{
		"jake-stewart/multicursor.nvim",
		branch = "1.0",
		keys = {
			{
				mode = { "n", "x" },
				"<up>",
				function()
					require("multicursor-nvim").lineAddCursor(-1)
				end,
			},
			{
				mode = { "n", "x" },
				"<down>",
				function()
					require("multicursor-nvim").lineAddCursor(1)
				end,
			},
			{
				mode = { "n", "x" },
				"<leader><up>",
				function()
					require("multicursor-nvim").lineSkipCursor(-1)
				end,
			},
			{
				mode = { "n", "x" },
				"<leader><down>",
				function()
					require("multicursor-nvim").lineSkipCursor(1)
				end,
			},
			{
				mode = { "n", "x" },
				"<M-e>",
				function()
					require("multicursor-nvim").matchAddCursor(1)
				end,
			},
			{
				mode = { "n", "x" },
				"<M-r>",
				function()
					require("multicursor-nvim").matchSkipCursor(1)
				end,
			},
			{
				mode = { "n" },
				"<c-leftmouse>",
				function()
					require("multicursor-nvim").handleMouse()
				end,
			},
			{
				mode = { "n" },
				"<c-leftdrag>",
				function()
					require("multicursor-nvim").handleMouseDrag()
				end,
			},
			{
				mode = { "n" },
				"<c-leftrelease>",
				function()
					require("multicursor-nvim").handleMouseRelease()
				end,
			},
			{
				mode = { "n", "x" },
				"<c-q>",
				function()
					require("multicursor-nvim").toggleCursor()
				end,
			},
		},
		config = function()
			local mc = require("multicursor-nvim")
			mc.setup()

			-- local set = vim.keymap.set

			-- Add or skip cursor above/below the main cursor.
			-- set({ "n", "x" }, "<up>", function() mc.lineAddCursor(-1) end)
			-- set({ "n", "x" }, "<down>", function() mc.lineAddCursor(1) end)
			-- set({ "n", "x" }, "<leader><up>", function() mc.lineSkipCursor(-1) end)
			-- set({ "n", "x" }, "<leader><down>", function() mc.lineSkipCursor(1) end)

			-- Add or skip adding a new cursor by matching word/selection
			-- set({ "n", "x" }, "<M-e>", function()
			-- 	mc.matchAddCursor(1)
			-- end)
			-- set({ "n", "x" }, "<M-r>", function()
			-- 	mc.matchSkipCursor(1)
			-- end)
			-- set({ "n", "x" }, "<leader>N", function()
			-- 	mc.matchAddCursor(-1)
			-- end)
			-- set({ "n", "x" }, "<leader>S", function()
			-- 	mc.matchSkipCursor(-1)
			-- end)

			-- Add and remove cursors with control + left click.
			-- set("n", "<c-leftmouse>", mc.handleMouse)
			-- set("n", "<c-leftdrag>", mc.handleMouseDrag)
			-- set("n", "<c-leftrelease>", mc.handleMouseRelease)
			--
			-- -- Disable and enable cursors.
			-- set({ "n", "x" }, "<c-q>", mc.toggleCursor)

			-- Mappings defined in a keymap layer only apply when there are
			-- multiple cursors. This lets you have overlapping mappings.
			mc.addKeymapLayer(function(layerSet)
				-- Select a different cursor as the main one.
				layerSet({ "n", "x" }, "<left>", mc.prevCursor)
				layerSet({ "n", "x" }, "<right>", mc.nextCursor)

				-- Delete the main cursor.
				layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

				-- Enable and clear cursors using escape.
				layerSet("n", "<esc>", function()
					if not mc.cursorsEnabled() then
						mc.enableCursors()
					else
						mc.clearCursors()
					end
				end)
			end)

			-- Customize how cursors look.
			local hl = vim.api.nvim_set_hl
			hl(0, "MultiCursorCursor", { reverse = true })
			hl(0, "MultiCursorVisual", { link = "Visual" })
			hl(0, "MultiCursorSign", { link = "SignColumn" })
			hl(0, "MultiCursorMatchPreview", { link = "Search" })
			hl(0, "MultiCursorDisabledCursor", { reverse = true })
			hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
			hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
		end,
	},
	{
		"mg979/vim-visual-multi",
		enabled = false,
		keys = {
			{ "<M-e>", mode = { "n", "v" } },
			{ "<M-r>", mode = { "n", "v" } },
			{ "<C-Down>", mode = { "n", "v" } },
			{ "<C-Up>", mode = { "n", "v" } },
		},
		-- event = "VeryLazy",
		-- event = { "BufRead", "BufNewFile" },
		init = function()
			vim.cmd([[highlight! VM_Mono guibg=#004b72]])
			vim.cmd([[highlight! VM_Extend guibg=#004b72]])
			vim.g.VM_Mono_hl = "Visual"
			vim.g.VM_Mono = "Visual"
			vim.g.VM_Extend = "Visual"
			vim.g.VM_Extend_hl = "Visual"
			vim.g.VM_Insert_hl = "Visual"
			vim.g.VM_default_mappings = 0
			-- vim.g.VM_set_statusline = 0
			-- vim.g.VM_silent_exit = 1
			-- vim.g.VM_quit_after_leaving_insert_mode = 1
			vim.g.VM_show_warnings = 0
			vim.g.VM_maps = {
				-- ["Undo"] = "u",
				-- ["Redo"] = "<C-r>",
				["Find Under"] = "<M-e>",
				["Select All"] = "<M-a>",
				["Find Subword Under"] = "<M-e>",
				-- ["Skip Region"] = "<C-s>",
				["Select h"] = "<S-Left>",
				["Select l"] = "<S-Right>",
				["Add Cursor Up"] = "<C-Up>",
				["Add Cursor Down"] = "<C-Down>",
				["Select Operator"] = "gs",
				-- ["Mouse Cursor"] = "<C-LeftMouse>",
				-- ["Mouse Column"] = "<C-RightMouse>",
			}
			-- vim.g.VM_custom_remaps = {
			--   ["<C-c>"] = "<Esc>",
			-- }
			-- vim.g.VM_highlight_matches = ""
		end,
		-- config = function()
		--   vim.cmd([[highlight! VM_Mono guibg=#004b72]])
		--   vim.cmd([[highlight! VM_Extend guibg=#004b72]])
		--   vim.g.VM_Mono_hl = "Visual"
		--   vim.g.VM_Mono = "Visual"
		--   vim.g.VM_Extend = "Visual"
		--   vim.g.VM_Extend_hl = "Visual"
		--   vim.g.VM_Insert_hl = "Visual"
		--   vim.g.VM_default_mappings = 0
		--   vim.g.VM_maps = {}
		--   vim.g.VM_maps["Find Under"] = "<M-e>"
		--   vim.g.VM_maps["Find Subword Under"] = "<M-e>"
		--   vim.g.VM_maps["Select Operator"] = "gs"
		--   vim.g.VM_maps["Select All"] = "<M-r>"
		--   -- vim.g.VM_maps["Add Cursor Down"] = "<C-S-D-Down>"
		--   -- vim.g.VM_maps["Add Cursor Up"] = "<C-S-D-Up>"
		--   -- vim.cmd[[let g:VM_maps["Add Cursor Down"]             = '<C-Down>']]
		--   -- vim.cmd[[let g:VM_maps["Add Cursor Up"]               = '<C-Up>']]
		--
		--   -- vim.cmd[[let g:VM_maps["Select Cursor Down"]          = '<M-C-Down>']]
		--   -- vim.cmd[[let g:VM_maps["Select Cursor Down"]          = '<M-C-Up>']]
		--   -- vim.cmd[[let g:VM_maps["Add Cursor Down"]             = '<C-S-D-Down>']]
		--   -- vim.cmd[[let g:VM_maps["Add Cursor Up"]               = '<C-S-D-Up>']]
		-- end,
	},
}
