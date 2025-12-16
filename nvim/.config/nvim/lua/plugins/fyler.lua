return {
	{
		"A7Lavinraj/fyler.nvim",
		enabled = true,
    lazy = true,
		cmd = { "Fyler" },
    -- event = { "VeryLazy" },
		-- branch = "stable",
		branch = "main",
		dependencies = { "nvim-mini/mini.icons" },
		keys = {
			{
				"<leader>fe",
				function()
					-- vim.cmd("Fyler kind=split_right")
					-- for _, win in ipairs(vim.api.nvim_list_wins()) do
					-- 	if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "fyler" then
					-- 		return vim.api.nvim_win_close(win, false)
					-- 	end
					-- end
					-- -- vim.cmd.Fyler()

					local fyler = require("fyler")
					fyler.focus()
				end,
				desc = "Fyler",
			},
		},
		opts = {
			hooks = {
				-- function(path) end
				on_delete = nil,
				-- function(src_path, dst_path) end
				on_rename = nil,
				-- function(hl_groups, palette) end
				on_highlight = nil,
			},
			integrations = {
				icon = "mini_icons",
			},
			views = {
				finder = {
					-- Close explorer when file is selected
					close_on_select = false,
					-- Auto-confirm simple file operations
					confirm_simple = false,
					-- Replace netrw as default explorer
					default_explorer = true,
					-- Move deleted files/directories to the system trash
					delete_to_trash = true,
					-- Git status
					git_status = {
						enabled = true,
						symbols = {
							Untracked = "?",
							Added = "+",
							Modified = "!",
							Deleted = "✗",
							Renamed = "󰕛 ",
							Copied = "~",
							Conflict = "󰀨 ",
							Ignored = " ",
						},
					},
					-- Icons for directory states
					icon = {
						directory_collapsed = nil,
						directory_empty = nil,
						directory_expanded = nil,
					},
					-- Indentation guides
					indentscope = {
						enabled = true,
						group = "FylerIndentMarker",
						marker = "│",
					},
					-- Key mappings
          mappings = {
            -- ["Y"] = function(view)
            --   print('hi')
            -- end,
            ["q"] = "CloseView",
            ["<CR>"] = "Select",
            ["L"] = "Select",
            ["<C-t>"] = "SelectTab",
            ["<C-v>"] = "SelectVSplit",
            ["<C-s>"] = "SelectSplit",
            ["-"] = "GotoParent",
            ["="] = "GotoCwd",
            ["."] = "GotoNode",
            ["#"] = "CollapseAll",
            ["<BS>"] = "CollapseNode",
            ["H"] = "CollapseNode",
          },
					-- Current file tracking
					follow_current_file = false,
					-- File system watching(includes git status)
					watcher = {
						enabled = true,
					},
					-- Window configuration
					win = {
						border = vim.o.winborder == "" and "single" or vim.o.winborder,
						buf_opts = {
							filetype = "fyler",
							syntax = "fyler",
							buflisted = false,
							buftype = "acwrite",
							expandtab = true,
							shiftwidth = 2,
						},
						kind = "replace",
            -- kind = "split_left",
						kinds = {
							float = {
								height = "70%",
								width = "70%",
								top = "10%",
								left = "15%",
							},
							replace = {},
							split_above = {
								height = "70%",
							},
							split_above_all = {
								height = "70%",
							},
							split_below = {
								height = "70%",
							},
							split_below_all = {
								height = "70%",
							},
							split_left = {
								width = "30%",
							},
							split_left_most = {
								width = "30%",
							},
							split_right = {
								width = "30%",
							},
							split_right_most = {
								width = "30%",
							},
						},
						win_opts = {
              winbar = "%#NvimTreeRootFolder#%{substitute(v:lua.vim.fn.getcwd(), '^' . $HOME, '~', '')}  %#ModeMsg#%{%&modified ? '⏺' : ''%}",
							concealcursor = "nvic",
							conceallevel = 3,
							cursorline = true,
							number = true,
							relativenumber = true,
							winhighlight = "Normal:FylerNormal",
							wrap = false,
						},
					},
				},
			},
		},
	},
}
